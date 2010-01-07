Return-Path: <linux-kernel-owner+w=401wt.eu-S1753078Ab0AGPGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab0AGPGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 10:06:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107Ab0AGPGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 10:06:46 -0500
Received: from poutre.nerim.net ([62.4.16.124]:62164 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811Ab0AGPGq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 10:06:46 -0500
Date: Thu, 7 Jan 2010 16:06:43 +0100
From: Jean Delvare <khali@linux-fr.org>
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
Cc: lm-sensors@lm-sensors.org, Julia Lawall <julia@diku.dk>,
       LKML <linux-kernel@vger.kernel.org>, cocci@diku.dk
Subject: Re: [lm-sensors] [PATCH 1/5] via686a: make PCI device id constant
Message-ID: <20100107160643.35af80a5@hyperion.delvare>
In-Reply-To: <4B427D3B.6080709@freemail.hu>
References: <4B427D3B.6080709@freemail.hu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Jan 2010 00:43:55 +0100, Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
> 
> The id_table field of the struct pci_driver is constant in <linux/pci.h>
> so it is worth to make pci_device_id also constant.
> 
> The semantic match that finds this kind of pattern is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r@
> identifier I1, I2, x;
> @@
> 	struct I1 {
> 	  ...
> 	  const struct I2 *x;
> 	  ...
> 	};
> @s@
> identifier r.I1, y;
> identifier r.x, E;
> @@
> 	struct I1 y = {
> 	  .x = E,
> 	};
> @c@
> identifier r.I2;
> identifier s.E;
> @@
> 	const struct I2 E[] = ... ;
> @depends on !c@
> identifier r.I2;
> identifier s.E;
> @@
> +	const
> 	struct I2 E[] = ...;
> // </smpl>
> 
> Signed-off-by: Márton Németh <nm127@freemail.hu>
> Cc: Julia Lawall <julia@diku.dk>
> Cc: cocci@diku.dk
> ---
> diff -u -p a/drivers/hwmon/via686a.c b/drivers/hwmon/via686a.c
> --- a/drivers/hwmon/via686a.c 2009-12-03 04:51:21.000000000 +0100
> +++ b/drivers/hwmon/via686a.c 2010-01-03 20:55:10.000000000 +0100
> @@ -767,7 +767,7 @@ static struct via686a_data *via686a_upda
>  	return data;
>  }
> 
> -static struct pci_device_id via686a_pci_ids[] = {
> +static const struct pci_device_id via686a_pci_ids[] = {
>  	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C686_4) },
>  	{ 0, }
>  };

I've merged all 5 patches are they are doing the exact same thing to 5
drivers. The resulting patch is applied, thanks.


-- 
Jean Delvare
