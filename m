Return-Path: <linux-kernel-owner+w=401wt.eu-S1756703AbZCZAcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbZCZAcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 20:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbZCZAcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 20:32:06 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:58465 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbZCZAcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 20:32:05 -0400
Date: Wed, 25 Mar 2009 17:31:54 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       shai@scalex86.org
Subject: Re: [PATCH] x86: don't compile vsmp_64 for 32bit
Message-ID: <20090326003154.GA10614@localdomain>
References: <20090302235120.GF27240@localdomain> <20090322124818.GA31466@elte.hu> <20090324061429.GH7278@localdomain> <20090324091035.GA6605@elte.hu> <20090325185138.GI7278@localdomain> <49CAAD2E.3060904@goop.org> <20090325223642.GK7278@localdomain> <49CABB25.8040106@goop.org> <20090325232921.GL7278@localdomain> <49CAC543.5020205@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CAC543.5020205@goop.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 04:58:59PM -0700, Jeremy Fitzhardinge wrote:
> Ravikiran G Thirumalai wrote:
>> The point in this thread was, is_vsmp_box() needs to be meaningful even 
>> when
>> CONFIG_X86_VSMP is not on.  This is needed because is_vsmp_box() is used 
>> to
>> determine if the platform has reliable tscs.
>>   
>
> Well, as I said, that code is inoperative at present.  But aside from that, 

If you read this thread completely and the patch that is being discussed, you'd find
that code would be operative.

Here's a threaded view of the complete discussion as we discuss  for
everyone's convenience, as people seem to be jumping into the discussion
without actually reading up the context of the discussion.

http://lkml.org/lkml/2009/2/26/5


> how well will a non-VSMP kernel work on your hardware, with a normal 
> cacheline, etc.  Is the tsc stability really all that important, given that 
> the kernel should notice if the tsc is busted pretty quickly anyway.
>

The installer kernels do not have vSMP enabled, and needs to be atleast able
to install the full distro reliably.


> unsynchronized_tsc() just returns a guess anyway, and if you don't have 
> X86_FEATURE_CONSTANT_TSC set, then it will return unstable for your 
> hardware anyway, even without the is_vsmp_box() test.

Unfortunately we use hardware which has X86_FEATURE_CONSTANT_TSC.

>
> Failing that, you could add yourself to bad_tsc_dmi_table[] and have that 
> mark the tsc as unstable (you have DMI, right?).
>

Newer versions of the VMM does, but older ones don't :(, and obviously we
have older versions out in the field that still needs to be supported.

