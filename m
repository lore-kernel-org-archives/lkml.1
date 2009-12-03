Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbZLCRmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbZLCRmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 12:42:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754314AbZLCRmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 12:42:05 -0500
Received: from senator.holtmann.net ([87.106.208.187]:51399 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbZLCRmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 12:42:04 -0500
Subject: RE: [PATCH] DFU Driver for Atheros bluetooth chipset AR3011
From: Marcel Holtmann <marcel@holtmann.org>
To: Vikram Kandukuri <Vikram.Kandukuri@Atheros.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
       Luis Rodriguez <Luis.Rodriguez@Atheros.com>
In-Reply-To: <44EE5C37ADC36343B0625A05DD408C485069714222@CHEXMB-01.global.atheros.com>
References: <20091124101007.GC7551@atheros-laptop>
	 <44EE5C37ADC36343B0625A05DD408C485069714222@CHEXMB-01.global.atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Dec 2009 18:42:06 +0100
Message-Id: <1259862126.30413.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vikram,

> Signed-off-by: Vikram Kandukuri <Vikram.Kandukuri@atheors.com>

so first of all, you should learn how to write you employers name.

> Signed-off-by: Alicke Xu <sxu@atheros.com>
> Reviewed-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> 
> ---
>  drivers/bluetooth/Kconfig  |   12 +++
>  drivers/bluetooth/Makefile |    1 +
>  drivers/bluetooth/ath3k.c  |  191 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 204 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/bluetooth/ath3k.c
> 
> diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
> index 652367a..89f079e 100644
> --- a/drivers/bluetooth/Kconfig
> +++ b/drivers/bluetooth/Kconfig
> @@ -195,5 +195,17 @@ config BT_MRVL_SDIO
>           Say Y here to compile support for Marvell BT-over-SDIO driver
>           into the kernel or say M to compile it as module.
> 
> +config BT_ATH3K
> +       tristate "Atheros firmware download driver"
> +       depends on BT_HCIBTUSB
> +       select FW_LOADER
> +       help
> +         Bluetooth firmware download driver.
> +         This driver loads the firmware into the Atheros bluetooth
> +          chipset.
> +
> +         Say Y here to compile support for "Atheros AR30XX firmware download driver"
> +          into the  kernel or say M to compile it as module (ath3k).
> +
>  endmenu
> 
> diff --git a/drivers/bluetooth/Makefile b/drivers/bluetooth/Makefile
> index b3f57d2..6fcdeb7 100644
> --- a/drivers/bluetooth/Makefile
> +++ b/drivers/bluetooth/Makefile
> @@ -15,6 +15,7 @@ obj-$(CONFIG_BT_HCIBTUART)    += btuart_cs.o
>  obj-$(CONFIG_BT_HCIBTUSB)      += btusb.o
>  obj-$(CONFIG_BT_HCIBTSDIO)     += btsdio.o
> 
> +obj-$(CONFIG_BT_ATH3K)         += ath3k.o
>  obj-$(CONFIG_BT_MRVL)          += btmrvl.o
>  obj-$(CONFIG_BT_MRVL_SDIO)     += btmrvl_sdio.o

The Makefile and Kconfig changes don't apply at all. No idea how you
screwed that up, but you did.

> +MODULE_DEVICE_TABLE(usb, ath3k_table);
> +
> +#define USB_REQ_DFU_DNLOAD     1
> +#define FIRST_20BYTE            20

The FIRST_20BYTE is not used. So remove it.

> +#define BULK_SIZE               4096
> +
> +#define ATHBT_IN_EP(data)       (0x81)
> +#define ATHBT_OUT_EP(data)     (0x02)

This is not used either and wrong on so many levels. Remove it.

> +struct ath3k_data {
> +       struct usb_device *udev;
> +       u8 *fw_data;
> +       u32 fw_size;
> +       u32 fw_sent;
> +};
> +

And from here on. Please use tabs and not spaces. Did you actually run
checkpatch.pl on this patch?

Regards

Marcel


