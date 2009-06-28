Return-Path: <linux-kernel-owner+w=401wt.eu-S1754717AbZF1WBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbZF1WBO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 18:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbZF1WA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 18:00:59 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:55032 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbZF1WA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 18:00:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=PNzbN/dkTcKMZeNlzClDmYNDjDECuGWysb6O8h2BTgbxaHho/KUyrc9j63CAR7l/oF
         mO7a7pvb05OmsfqvVvx3JQ5GsuxJoY/C6oSJ1CyhDifXv3DEb7AyeuHCkth44l/fr1cH
         7Z767vdRowq04SmngHdSAl6NSniNL+OJZ+96A=
Message-ID: <4A47E85D.3020202@gmail.com>
Date: Sun, 28 Jun 2009 15:02:05 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009031304)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Len Brown <len.brown@intel.com>
Subject: Re: [PATCH] acpi processor: simplify needlessly complex printk
References: <200906282203.55643.elendil@planet.nl>
In-Reply-To: <200906282203.55643.elendil@planet.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> Why use three printk statements if one will do?
>
> Signed-off-by: Frans Pop<elendil@planet.nl>
>
> diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
> index 84e0f3c..b8fb74a 100644
> --- a/drivers/acpi/processor_core.c
> +++ b/drivers/acpi/processor_core.c
> @@ -772,12 +772,11 @@ static int __cpuinit acpi_processor_start(struct acpi_device *device)
>   	if (result)
>   		printk(KERN_ERR PREFIX "Create sysfs link\n");
>
> -	if (pr->flags.throttling) {
> -		printk(KERN_INFO PREFIX "%s [%s] (supports",
> -		       acpi_device_name(device), acpi_device_bid(device));
> -		printk(" %d throttling states", pr->throttling.state_count);
> -		printk(")\n");
> -	}
> +	if (pr->flags.throttling)
> +		printk(KERN_INFO PREFIX
> +			"%s [%s] (supports %d throttling states)\n",
> +			acpi_device_name(device), acpi_device_bid(device),
> +			pr->throttling.state_count);
>
>         end:
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>    
Would it be better to capitalize the S and add a period at the
end, or does it not matter?

Justin P. Mattock
