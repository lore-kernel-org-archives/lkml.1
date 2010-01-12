Return-Path: <linux-kernel-owner+w=401wt.eu-S1753895Ab0ALOfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab0ALOfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 09:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870Ab0ALOfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 09:35:42 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:49355 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752113Ab0ALOfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 09:35:41 -0500
X-Sasl-enc: 5oqlgKTg3SX2ebyKMSiIsFSB+9n2HCcnDJDXC1NLGJ10 1263306940
Message-ID: <4B4C88B6.406@imap.cc>
Date: Tue, 12 Jan 2010 15:35:34 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; de; rv:1.9.1.7) Gecko/20100104 SeaMonkey/2.0.2
MIME-Version: 1.0
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
CC: Karsten Keil <isdn@linux-pingi.de>, isdn4linux@listserv.isdn4linux.de,
       LKML <linux-kernel@vger.kernel.org>, Julia Lawall <julia@diku.dk>,
       cocci@diku.dk
Subject: Re: [PATCH] isdn: make USB device id constant
References: <4B4C2A52.70800@freemail.hu>
In-Reply-To: <4B4C2A52.70800@freemail.hu>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Please provide a diffstat next time so that I don't have to scan
the entire patch in order to see which source files it touches.

Thanks,
Tilman

Am 2010-01-12 08:52 schrieb Németh Márton:
> From: Márton Németh <nm127@freemail.hu>
> 
> The id_table field of the struct usb_device_id is constant in <linux/usb.h>
> so it is worth to make the initialization data also constant.
> 
> The semantic match that finds this kind of pattern is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r@
> disable decl_init,const_decl_init;
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
> diff -u -p a/drivers/isdn/hardware/mISDN/hfcsusb.h b/drivers/isdn/hardware/mISDN/hfcsusb.h
> --- a/drivers/isdn/hardware/mISDN/hfcsusb.h 2010-01-07 19:08:40.000000000 +0100
> +++ b/drivers/isdn/hardware/mISDN/hfcsusb.h 2010-01-08 13:36:54.000000000 +0100
> @@ -337,7 +337,7 @@ static const char *HFC_NT_LAYER1_STATES[
>  };
> 
>  /* supported devices */
> -static struct usb_device_id hfcsusb_idtab[] = {
> +static const struct usb_device_id hfcsusb_idtab[] = {
>  	{
>  	 USB_DEVICE(0x0959, 0x2bd0),
>  	 .driver_info = (unsigned long) &((struct hfcsusb_vdata)
> diff -u -p a/drivers/isdn/hisax/hfc_usb.c b/drivers/isdn/hisax/hfc_usb.c
> --- a/drivers/isdn/hisax/hfc_usb.c 2010-01-07 19:08:40.000000000 +0100
> +++ b/drivers/isdn/hisax/hfc_usb.c 2010-01-08 13:49:53.000000000 +0100
> @@ -64,7 +64,7 @@ typedef struct {
>  } hfcsusb_vdata;
> 
>  /* VID/PID device list */
> -static struct usb_device_id hfcusb_idtab[] = {
> +static const struct usb_device_id hfcusb_idtab[] = {
>  	{
>  	 USB_DEVICE(0x0959, 0x2bd0),
>  	 .driver_info = (unsigned long) &((hfcsusb_vdata)
> diff -u -p a/drivers/isdn/hisax/st5481_init.c b/drivers/isdn/hisax/st5481_init.c
> --- a/drivers/isdn/hisax/st5481_init.c 2009-12-03 04:51:21.000000000 +0100
> +++ b/drivers/isdn/hisax/st5481_init.c 2010-01-08 13:50:45.000000000 +0100
> @@ -160,7 +160,7 @@ static void disconnect_st5481(struct usb
>  /*
>   * The last 4 bits in the Product Id is set with 4 pins on the chip.
>   */
> -static struct usb_device_id st5481_ids[] = {
> +static const struct usb_device_id st5481_ids[] = {
>  	{ USB_DEVICE(ST_VENDOR_ID, ST5481_PRODUCT_ID+0x0) },
>  	{ USB_DEVICE(ST_VENDOR_ID, ST5481_PRODUCT_ID+0x1) },
>  	{ USB_DEVICE(ST_VENDOR_ID, ST5481_PRODUCT_ID+0x2) },
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

- -- 
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Ungeöffnet mindestens haltbar bis: (siehe Rückseite)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAktMiLYACgkQQ3+did9BuFuxHACeIOwmUG9hzbSN3LR6O5PESzv1
BaIAoJRH+u+megLsdwe++Bn8SwW6xl58
=iLF0
-----END PGP SIGNATURE-----
