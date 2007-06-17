Return-Path: <linux-kernel-owner+w=401wt.eu-S1758467AbXFQJQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467AbXFQJQ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756434AbXFQJQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:16:47 -0400
Received: from nn7.de ([85.214.94.156]:60145 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756371AbXFQJQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:16:46 -0400
Subject: Re: [PATCH] hwmon/coretemp: Fix a broken error path
From: Soeren Sonnenburg <kernel@nn7.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Rudolf Marek <r.marek@assembler.cz>
In-Reply-To: <20070616231745.1b0f7bd9@hyperion.delvare>
References: <1182026585.4230.8.camel@localhost>
	 <20070616231745.1b0f7bd9@hyperion.delvare>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sun, 17 Jun 2007 11:16:43 +0200
Message-Id: <1182071803.4815.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-06-16 at 23:17 +0200, Jean Delvare wrote:
> Hi Soeren,

Hi Jean,

[...]

> Thanks for reporting. Indeed this patch is broken, sorry for
> overlooking it. I tested it but my hardware is such that the faulty
> error path was never taken. Please test the following patch (on top of
> git-current) and confirm it fixes your problem:
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Rudolf Marek <r.marek@assembler.cz>
> ---
>  drivers/hwmon/coretemp.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-2.6.22-rc4.orig/drivers/hwmon/coretemp.c	2007-06-05 10:25:54.000000000 +0200
> +++ linux-2.6.22-rc4/drivers/hwmon/coretemp.c	2007-06-16 23:14:06.000000000 +0200
> @@ -185,6 +185,7 @@ static int __devinit coretemp_probe(stru
>  		/* check for microcode update */
>  		rdmsr_on_cpu(data->id, MSR_IA32_UCODE_REV, &eax, &edx);
>  		if (edx < 0x39) {
> +			err = -ENODEV;
>  			dev_err(&pdev->dev,
>  				"Errata AE18 not fixed, update BIOS or "
>  				"microcode of the CPU!\n");

this patch indeed fixes the problem. Thanks!

Unfortunately the coretemp sensors are simply never there when that
patch is applied... which I guess was the intention ... As apple
probably won't update the bios does anyone know how to get a newer
microcode for a core duo cpu  (not core 2 duo!) ?

Soeren
-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.
