Return-Path: <linux-kernel-owner+w=401wt.eu-S1760007AbYHUVGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760007AbYHUVGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 17:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755226AbYHUVGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 17:06:44 -0400
Received: from gw.goop.org ([64.81.55.164]:39174 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664AbYHUVGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 17:06:43 -0400
Message-ID: <48ADD8DE.3010209@goop.org>
Date: Thu, 21 Aug 2008 14:06:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: jmerkey@wolfmountaingroup.com, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       paulmck@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>
Subject: Re: [ANNOUNCE] mdb: Merkey's Linux Kernel Debugger  2.6.27-rc4 released
References: <200808210250.m7L2obNX028353@wolfmountaingroup.com> <48AD5A21.7020801@s5r6.in-berlin.de> <43593.166.70.238.46.1219321595.squirrel@webmail.wolfmountaingroup.com> <200808212337.38626.nickpiggin@yahoo.com.au>
In-Reply-To: <200808212337.38626.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Thursday 21 August 2008 22:26, jmerkey@wolfmountaingroup.com wrote:
>
>   
>> I used the smp_wmb() functions.  I noted a couple of things.  a) some of
>> these macros just emit __asm__ __volatile__ into the code so why not just
>> say "volatile" to begin with
>>     
>
> It is not the same as volatile type. What it does is tell the compiler
> to clobber all registers or temporaries. This something pretty well
> defined and hard to get wrong compared to volatile type.
>   

No, that's not what "asm volatile" means.  Its *only* meaning is "emit
this, even if it doesn't look like it has side-effects and its results
are not used".  An asm() with no outputs is "volatile" by default, which
makes most of the uses of "asm volatile" in the kernel redundant.  "asm
volatile" also has no effect on the ordering of the asm with respect to
other code; you must use constraints to do that.

An asm with a "memory" clobber is sufficient to make sure that gcc
doesn't cache memory values in registers; perhaps that's what you mean.

    J
