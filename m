Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbYAOHpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbYAOHpT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 02:45:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbYAOHpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 02:45:07 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:37789 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389AbYAOHpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 02:45:06 -0500
Date: Tue, 15 Jan 2008 08:45:11 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix 32bit build for git-x86
Message-ID: <20080115074511.GA15285@uranus.ravnborg.org>
References: <20080115010449.GA5521@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115010449.GA5521@basil.nowhere.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 02:04:49AM +0100, Andi Kleen wrote:
> 
> Fixes the 32build here with git-x86 (tip 2f42671697ea9abc7d10ea7f663d6ef6e8ec6358)
> 
> Fix git-x86 build 
> 
> Otherwise
> 
> make[3]: Nothing to be done for `vmlinux'.
> KBUILD_IMAGE := arch/x86/boot/bzImage
> make[2]: KBUILD_IMAGE: Command not found
> make[2]: *** [all] Error 127

Thanks Andi.

I wonder how these tabs came in.
I am almost sure they were not in my original patch. But as git-send-email
do not save copies of my sent mails I cannot be sure.

Ingo - do you have a script on your side that could have converted
the spaces to tabs?
It could be a simple "make checkpatch happy" change too - but in this case
it was wrong.

Leading tabs in Makefiles that are not in front of commands are a typical
source of non-so-easy-to-debug problems.
Been there before....

	Sam


> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> Index: linux/arch/x86/Makefile
> ===================================================================
> --- linux.orig/arch/x86/Makefile
> +++ linux/arch/x86/Makefile
> @@ -211,7 +211,8 @@ PHONY += zImage bzImage compressed zlilo
>  all: bzImage
>  
>  # KBUILD_IMAGE specify target image being built
> -		    KBUILD_IMAGE := $(boot)/bzImage
> +KBUILD_IMAGE := $(boot)/bzImage
> +
>  zImage zlilo zdisk: KBUILD_IMAGE := arch/x86/boot/zImage
>  
>  zImage bzImage: vmlinux
