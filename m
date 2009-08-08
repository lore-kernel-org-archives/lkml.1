Return-Path: <linux-kernel-owner+w=401wt.eu-S1751184AbZHHVHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751184AbZHHVHS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 17:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750799AbZHHVHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 17:07:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38554 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbZHHVHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 17:07:16 -0400
Message-ID: <4A7DE8B6.80801@zytor.com>
Date: Sat, 08 Aug 2009 14:05:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Akinobu Mita <akinobu.mita@gmail.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, x86@kernel.org
Subject: Re: [PATCH tip:x86/asm] x86: Introduce GDT_ENTRY_INIT()
References: <20090808094905.GA2954@localhost.localdomain>
In-Reply-To: <20090808094905.GA2954@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2009 02:49 AM, Akinobu Mita wrote:
> diff --git a/drivers/char/vr41xx_giu.c b/drivers/char/vr41xx_giu.c
> deleted file mode 100644
> index e69de29..0000000
> diff --git a/drivers/pnp/pnpbios/bioscalls.c b/drivers/pnp/pnpbios/bioscalls.c
> index 45ad3e9..bd035e3 100644
> --- a/drivers/pnp/pnpbios/bioscalls.c
> +++ b/drivers/pnp/pnpbios/bioscalls.c
> @@ -60,7 +60,7 @@ do { \
>  	set_desc_limit(&gdt[(selname) >> 3], (size) - 1); \
>  } while(0)
>  
> -static struct desc_struct bad_bios_desc;
> +static struct desc_struct bad_bios_desc = GDT_ENTRY_INIT(0x4092, 0, 0);
>  
>  /*
>   * At some point we want to use this stack frame pointer to unwind
> @@ -476,9 +476,6 @@ void pnpbios_calls_init(union pnp_bios_install_struct *header)
>  	pnp_bios_callpoint.offset = header->fields.pm16offset;
>  	pnp_bios_callpoint.segment = PNP_CS16;
>  
> -	bad_bios_desc.a = 0;
> -	bad_bios_desc.b = 0x00409200;
> -
>  	set_desc_base(&bad_bios_desc, (unsigned long)__va(0x40UL << 4));
>  	set_desc_limit(&bad_bios_desc, 4095 - (0x40 << 4));
>  	for_each_possible_cpu(i) {

Please also fix this hunk to do the full initialization statically
instead of doing some fields statically and some dynamically.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

