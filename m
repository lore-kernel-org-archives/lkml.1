Return-Path: <linux-kernel-owner+w=401wt.eu-S1759338AbYBMCOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759338AbYBMCOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 21:14:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753744AbYBMCNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 21:13:53 -0500
Received: from rex.snapgear.com ([203.143.235.140]:60414 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753615AbYBMCNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 21:13:52 -0500
Message-ID: <47B2525D.4060002@snapgear.com>
Date: Wed, 13 Feb 2008 12:13:49 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: linux-kernel@vger.kernel.org, bernds_cb1@t-online.de
Subject: Re: [patch] FLAT binaries: drop BINFMT_FLAT bad header magic warning
References: <200802111235.03761.vapier.adi@gmail.com>
In-Reply-To: <200802111235.03761.vapier.adi@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Mike Frysinger wrote:
> The warning issued by fs/binfmt_flat.c when the format handler is given a
> non-FLAT and non-script executable is annoying to say the least when working
> with FDPIC ELF objects.  If you build a kernel that supports both FLAT and
> FDPIC ELFs on no-mmu, every time you execute an FDPIC ELF, the kernel spits
> out this message.  While I understand a lot of newcomers to the no-mmu world
> screw up generation of FLAT binaries, this warning is not usable for systems
> that support more than just FLAT.

I don't have a problem with this.

Acked-by: Greg Ungerer <gerg@snapgear.com>


> Signed-off-by: Jie Zhang <jie.zhang@analog.com>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> CC: Bernd Schmidt <bernds_cb1@t-online.de>
> CC: Greg Ungerer <gerg@snapgear.com>
> ---
> diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
> index d8a02f1..0498b18 100644
> --- a/fs/binfmt_flat.c
> +++ b/fs/binfmt_flat.c
> @@ -443,12 +443,12 @@ static int load_flat_file(struct linux_binprm * bprm,
>  
>  	if (strncmp(hdr->magic, "bFLT", 4)) {
>  		/*
> +		 * Previously, here was a printk to tell people
> +		 *   "BINFMT_FLAT: bad header magic".
> +		 * But for the kernel which also use ELF FD-PIC format, this
> +		 * error message is confusing.
>  		 * because a lot of people do not manage to produce good
> -		 * flat binaries,  we leave this printk to help them realise
> -		 * the problem.  We only print the error if its not a script file
>  		 */
> -		if (strncmp(hdr->magic, "#!", 2))
> -			printk("BINFMT_FLAT: bad header magic\n");
>  		ret = -ENOEXEC;
>  		goto err;
>  	}
> 

-- 
------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
Secure Computing Corporation                PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
