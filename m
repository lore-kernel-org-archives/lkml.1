Return-Path: <linux-kernel-owner+w=401wt.eu-S1756275AbZFAIPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275AbZFAIPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 04:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbZFAIPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 04:15:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59264 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbZFAIPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 04:15:23 -0400
To: Tobias Doerffel <tobias.doerffel@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: add specific support for Intel Atom architecture
From: Andi Kleen <andi@firstfloor.org>
References: <1243638699-15194-1-git-send-email-tobias.doerffel@gmail.com>
Date: Mon, 01 Jun 2009 10:15:24 +0200
In-Reply-To: <1243638699-15194-1-git-send-email-tobias.doerffel@gmail.com> (Tobias Doerffel's message of "Sat, 30 May 2009 01:11:39 +0200")
Message-ID: <87r5y4cqub.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tobias Doerffel <tobias.doerffel@gmail.com> writes:

> This adds another option when selecting CPU family so the kernel can
> be optimized for Intel Atom CPUs. If GCC supports tuning options for
> Intel Atom they will be used.

You seem to have ignored the earlier review feedback?

Like

> diff --git a/arch/x86/include/asm/module.h b/arch/x86/include/asm/module.h
> index 47d6274..e959c4a 100644
> --- a/arch/x86/include/asm/module.h
> +++ b/arch/x86/include/asm/module.h
> @@ -28,6 +28,8 @@ struct mod_arch_specific {};
>  #define MODULE_PROC_FAMILY "586MMX "
>  #elif defined CONFIG_MCORE2
>  #define MODULE_PROC_FAMILY "CORE2 "
> +#elif defined CONFIG_MATOM
> +#define MODULE_PROC_FAMILY "ATOM "

This is not needed because Atom is compatible to CORE2 (except for
one instruction the kernel doesn't use)

+	cflags-$(CONFIG_MATOM) += $(call cc-option,-march=atom) \
+		$(call cc-option,-mtune=atom,$(call cc-option,-mtune=generic))

It's doubtful that tune=generic is the best fallback for Atom, likely
tune=p5 is better


-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
