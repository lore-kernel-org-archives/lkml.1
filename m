Return-Path: <linux-kernel-owner+w=401wt.eu-S1752778AbYDHMVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbYDHMVm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 08:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbYDHMVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 08:21:34 -0400
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:26095 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbYDHMVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 08:21:33 -0400
Date: Tue, 8 Apr 2008 14:20:08 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       heukelum@fastmail.fm
Subject: Re: [PATCH 1/2] boot: increase stack size for kernel boot loader decompressor
Message-ID: <20080408122007.GA11832@mailshack.com>
References: <20080405013014.478571000@polaris-admin.engr.sgi.com> <20080405013014.693571000@polaris-admin.engr.sgi.com> <20080405134626.GA15894@mailshack.com> <47FA6478.1070301@sgi.com> <20080407214434.GA5296@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080407214434.GA5296@mailshack.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Tue, 08 Apr 2008 14:20:36 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.6.0.81; VDF: 7.0.3.133; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

I see you have applied the following patch to x86#for-akpm. It was
really ment for testing only. I think you ment to use this one instead?

[PATCH 1/2] boot: increase stack size for kernel boot loader decompressor
http://lkml.org/lkml/2008/3/25/497

Otherwise, please consider [PATCH] x86: cleanup boot-heap usage instead.
http://lkml.org/lkml/2008/4/8/90

Greetings,
	Alexander

On Mon, Apr 07, 2008 at 11:44:34PM +0200, Alexander van Heukelum wrote:
> diff --git a/arch/x86/boot/compressed/vmlinux_32.lds b/arch/x86/boot/compressed/vmlinux_32.lds
> index bb3c483..c858e30 100644
> --- a/arch/x86/boot/compressed/vmlinux_32.lds
> +++ b/arch/x86/boot/compressed/vmlinux_32.lds
> @@ -39,5 +39,6 @@ SECTIONS
>  		*(.bss.*)
>  		*(COMMON)
>  		_end = . ;
> +		_real_end = . + 0x4000;
>  	}
>  }
> diff --git a/arch/x86/boot/compressed/vmlinux_64.lds b/arch/x86/boot/compressed/vmlinux_64.lds
> index 7e5c720..9bef3cd 100644
> --- a/arch/x86/boot/compressed/vmlinux_64.lds
> +++ b/arch/x86/boot/compressed/vmlinux_64.lds
> @@ -44,5 +44,6 @@ SECTIONS
>  		pgtable = . ;
>  		. = . + 4096 * 6;
>  		_heap = .;
> +		_heap_end = . + 0x7000;
>  	}
>  }

