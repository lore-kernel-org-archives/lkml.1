Return-Path: <linux-kernel-owner+w=401wt.eu-S1753871AbZGRWDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871AbZGRWDT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 18:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768AbZGRWDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 18:03:18 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:51806 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbZGRWDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 18:03:17 -0400
Subject: Re: Duplicate vsyscall/vdso gettimeofday implementations on x86_64
From: john stultz <johnstul@us.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@tglx.de>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <87ab32wmkv.fsf@basil.nowhere.org>
References: <1247868130.8334.40.camel@localhost.localdomain>
	 <87eisfvtzv.fsf@basil.nowhere.org>
	 <1247871284.8334.42.camel@localhost.localdomain>
	 <87ab32wmkv.fsf@basil.nowhere.org>
Content-Type: text/plain
Date: Sat, 18 Jul 2009 15:03:14 -0700
Message-Id: <1247954594.14494.12.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-07-18 at 08:07 +0200, Andi Kleen wrote:
> john stultz <johnstul@us.ibm.com> writes:
> >
> > Hrmm. Can we deprecate the old method and push glibc to use the new one?
> 
> That would break every old 64bit executable. Also not there are programs
> who don't use glibc.
> 
> Also glibc's way of calling the vDSO is still somewhat inefficient
> (although that could be probably fixed)
> 
> > If we remove it the vsyscall interface will old glibc's fall-back
> > gracefully? 
> 
> They would crash gracefully.
> 
> I had a couple of different transition plans, but they were all fairly
> complicated and had various disadvantages, so in the end nothing got
> done and the old code just left in.

Ok. Ulrich mailed me with the same points earlier and here's what I
said:

It seems the options are:

1) Keep the old vsyscall gtod implementation as is, despite it
duplicating things. Maybe avoid the code duplication via inlined
functions.

2) Set the old vsyscall gtod to directly call the syscall.

Neither of these help to avoid the non-randomized syscall instruction.
And #2 punishes old users for no really good reason, so #1 is probably
the best approach. 

I'll try to put a patch together next week just to try to clean things
up a bit. 

If anyone has any other ideas, let me know.

thanks
-john


