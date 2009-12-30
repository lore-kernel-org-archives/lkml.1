Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbZL3S7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbZL3S7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 13:59:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbZL3S7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 13:59:48 -0500
Received: from mail.perches.com ([173.55.12.10]:1462 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030AbZL3S7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 13:59:48 -0500
Subject: Re: [PATCH] drivers/atm/lanai.c: use %pM to show MAC address
From: Joe Perches <joe@perches.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       David Miller <davem@davemloft.net>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090200F645@mi8nycmail19.Mi8.com>
References: <BD79186B4FD85F4B8E60E381CAEE19090200F645@mi8nycmail19.Mi8.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Dec 2009 10:59:46 -0800
Message-ID: <1262199586.2545.43.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-30 at 13:50 -0500, H Hartley Sweeten wrote:
> Use the %pM kernel extension to display the MAC address.
> diff --git a/drivers/atm/lanai.c b/drivers/atm/lanai.c
> index cf97c34..7fe7c32 100644
> --- a/drivers/atm/lanai.c
> +++ b/drivers/atm/lanai.c
[]
> @@ -2483,14 +2481,8 @@ static int lanai_proc_read(struct atm_dev *atmdev, loff_t *pos, char *page)
>  		return sprintf(page, "revision: board=%d, pci_if=%d\n",
>  		    lanai->board_rev, (int) lanai->pci->revision);
>  	if (left-- == 0)
> -		return sprintf(page, "EEPROM ESI: "
> -		    "%02X:%02X:%02X:%02X:%02X:%02X\n",
> -		    lanai->eeprom[EEPROM_MAC + 0],
> -		    lanai->eeprom[EEPROM_MAC + 1],
> -		    lanai->eeprom[EEPROM_MAC + 2],
> -		    lanai->eeprom[EEPROM_MAC + 3],
> -		    lanai->eeprom[EEPROM_MAC + 4],
> -		    lanai->eeprom[EEPROM_MAC + 5]);
> +		return sprintf(page, "EEPROM ESI: %pM\n",
> +		    &lanai->eeprom[EEPROM_MAC]);

This is a user-visible change from upper case to lower case.
Probably doesn't matter, but maybe...


