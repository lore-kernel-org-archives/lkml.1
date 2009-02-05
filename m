Return-Path: <linux-kernel-owner+w=401wt.eu-S1761346AbZBEBMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761346AbZBEBMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 20:12:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754410AbZBEBMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 20:12:08 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:54967 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753598AbZBEBMH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 20:12:07 -0500
Date: Wed, 4 Feb 2009 20:11:47 -0500 (EST)
From: Anders Kaseorg <andersk@MIT.EDU>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Jeff Arnold <jbarnold@MIT.EDU>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Denys Vlasenko <vda.linux@googlemail.com>,
       Tim Abbott <tabbott@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/7] Make section names compatible with -ffunction-sections
 -fdata-sections
In-Reply-To: <200902041845.48071.rusty@rustcorp.com.au>
Message-ID: <alpine.DEB.2.00.0902041950530.32142@vinegar-pot.mit.edu>
References: <1228521840-3886-1-git-send-email-jbarnold@mit.edu> <1228521840-3886-2-git-send-email-jbarnold@mit.edu> <200902041845.48071.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009, Rusty Russell wrote:
> PS.  Here's the extra ones I found.  Since you only enable sections on x86,
> it's not critical, but nice to cover them all.

It looks like you didn’t base your work on the current copy of the patch 
posted to this thread [1].  That copy already includes all but two of your 
changes (arch/s390/kernel/vdso.c and arch/sparc/kernel/init_task.c, in 
which the lines in question were introduced by recent commits), along with 
some others.

[1] <http://lkml.org/lkml/2009/1/4/196>

> --- a/arch/s390/kernel/vdso32/vdso32_wrapper.S
> +++ b/arch/s390/kernel/vdso32/vdso32_wrapper.S
> @@ -1,7 +1,7 @@
> #include <linux/init.h>
> #include <asm/page.h>
>
> -	.section ".data.page_aligned"
> +	.section ".kernel.data.page_aligned"
>
> 	.globl vdso32_start, vdso32_end
> 	.balign PAGE_SIZE

This change is wrong; you need to specify
	.section ".kernel.data.page_aligned", "aw"
like we do in [1], or else the assembler will not set the ALLOC flag on 
that section, leading to a crash at runtime.

We will send a new copy of the patch that includes your two changes 
shortly.

Anders
