Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304AbZKHME3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbZKHME3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 07:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbZKHME2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 07:04:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34739 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380AbZKHME2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 07:04:28 -0500
Date: Sun, 8 Nov 2009 13:04:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <herrmann.der.user@googlemail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 1/2] x86, amd-ucode: Check UCODE_MAGIC before loading the
 container file
Message-ID: <20091108120418.GV11372@elte.hu>
References: <20091029134552.GC30802@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091029134552.GC30802@alberich.amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andreas Herrmann <herrmann.der.user@googlemail.com> wrote:

> >From 5183dd763c6dc9f760e29f3313e0ae3dda5228a2 Mon Sep 17 00:00:00 2001
> From: Borislav Petkov <borislav.petkov@amd.com>
> Date: Thu, 29 Oct 2009 14:00:54 +0100
> Subject: [PATCH 1/2] x86, amd-ucode: Check UCODE_MAGIC before loading the container file
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---
>  arch/x86/kernel/microcode_amd.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
> index 366baa1..f4c538b 100644
> --- a/arch/x86/kernel/microcode_amd.c
> +++ b/arch/x86/kernel/microcode_amd.c
> @@ -317,6 +317,12 @@ static enum ucode_state request_microcode_fw(int cpu, struct device *device)
>  		return UCODE_NFOUND;
>  	}
>  
> +	if (*(u32 *)firmware->data != UCODE_MAGIC) {
> +		printk(KERN_ERR "microcode: invalid UCODE_MAGIC (0x%08x)\n",
> +		       *(u32 *)firmware->data);
> +		return UCODE_ERROR;
> +	}
> +
>  	ret = generic_load_microcode(cpu, firmware->data, firmware->size);
>  
>  	release_firmware(firmware);

hm, there's no changelog. How was it found, what's the significance, do 
we want it for .32 - i suspect we want - but we need a better changelog 
for that.

Thanks,

	Ingo
