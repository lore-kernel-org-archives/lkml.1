Return-Path: <linux-kernel-owner+w=401wt.eu-S1751635AbXA0LPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635AbXA0LPA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 06:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbXA0LPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 06:15:00 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:31126 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbXA0LO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 06:14:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=J8+nvwDjfLLZcVfayFNULb2M1dPeMD0KddDI6N+ywbAev7BNT24IJZo8iJhESYAp3OKX71GsuX8hsYzti/V8IKR5pg6e817fs+2wafnCqr0SAIriHDbqZs77WxrovYzaHfJgW3SnwHDJeKdAb5YD1anfcNbtamCvGvc9kSV1k4E=
Message-ID: <9e0cf0bf0701270314t3369dc7fke7fe8589be1d5bd7@mail.gmail.com>
Date: Sat, 27 Jan 2007 13:14:57 +0200
From: "Alon Bar-Lev" <alon.barlev@gmail.com>
To: "akpm@osdl.org" <akpm@osdl.org>
Subject: Re: + dynamic-kernel-command-line-sparc64-fix.patch added to -mm tree
Cc: mm-commits@vger.kernel.org, davem@davemloft.net,
       "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <200701271103.l0RB32ES007734@shell0.pdx.osdl.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200701271103.l0RB32ES007734@shell0.pdx.osdl.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/27/07, akpm@osdl.org <akpm@osdl.org> wrote:
> diff -puN drivers/sbus/char/openprom.c~dynamic-kernel-command-line-sparc64-fix drivers/sbus/char/openprom.c
> --- a/drivers/sbus/char/openprom.c~dynamic-kernel-command-line-sparc64-fix
> +++ a/drivers/sbus/char/openprom.c
> @@ -283,7 +283,7 @@ static int oprompath2node(void __user *a
>
>  static int opromgetbootargs(void __user *argp, struct openpromio *op, int bufsize)
>  {
> -       char *buf = saved_command_line;
> +       char *buf = boot_command_line;
>         int len = strlen(buf);
>
>         if (len > bufsize)

Hello Andrew,

I don't think this is correct.
The boot_command_line should only be used by init code.
Drivers should continue to use saved_command_line.

I don't know why saved_command_line cannot be resolved and
boot_command_line can be.
They are both located in linux/init.h

extern char __initdata boot_command_line[];
extern char *saved_command_line;

And the drivers/sbus/char/openprom.c do include it and I assume
__ASSEMBLY__ is not defined.

Best Regards,
Alon Bar-Lev.
