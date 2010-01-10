Return-Path: <linux-kernel-owner+w=401wt.eu-S1753861Ab0AJRvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab0AJRvq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 12:51:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753686Ab0AJRvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 12:51:45 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:6121 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593Ab0AJRvo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 12:51:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TlhH3pu5b5orPGWou72Tq2CVPud4tnW+GbiWbAm+T1p/ql8VFPpgOF4Xee1AyiSOOI
         4i4liygCtb1TAdPfjnsROpyB5X85muv+wSYYdL3tpdweB0qPcea8bYqEQaurAcwc/2d3
         Y9doq3ZnKBwH4SjN7qlVghso2TR48yS6JoDwg=
MIME-Version: 1.0
In-Reply-To: <4B4A077C.7020406@freemail.hu>
References: <4B4A077C.7020406@freemail.hu>
Date: Sun, 10 Jan 2010 18:51:42 +0100
Message-ID: <e2d7436a1001100951w4dd7139as96e5808872f5c926@mail.gmail.com>
Subject: Re: [PATCH 3/3] serial: make PCI device id constant
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Julia Lawall <julia@diku.dk>, cocci@diku.dk
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/10 Németh Márton <nm127@freemail.hu>:
> From: Márton Németh <nm127@freemail.hu>
>
> The id_table field of the struct pci_driver is constant in <linux/pci.h>
> so it is worth to make initialization data also constant.
[...]
> diff -u -p a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
> --- a/drivers/serial/8250_pci.c 2009-12-03 04:51:21.000000000 +0100
> +++ b/drivers/serial/8250_pci.c 2010-01-08 18:40:05.000000000 +0100
> @@ -2567,7 +2567,7 @@ static int pciserial_resume_one(struct p
>  }
>  #endif
>
> -static struct pci_device_id serial_pci_tbl[] = {
> +static const struct pci_device_id serial_pci_tbl[] = {
>        /* Advantech use PCI_DEVICE_ID_ADVANTECH_PCI3620 (0x3620) as 'PCI_SUBVENDOR_ID' */
>        {       PCI_VENDOR_ID_ADVANTECH, PCI_DEVICE_ID_ADVANTECH_PCI3620,
>                PCI_DEVICE_ID_ADVANTECH_PCI3620, 0x0001, 0, 0,
[...]

There was similar patch sent to netdev couple days ago. For PCI
devices it used DEFINE_PCI_DEVICE_TABLE() like this:

static DEFINE_PCI_DEVICE_TABLE(serial_pci_tbl) = {

so that the ID data went to the proper .ko section.

Best Regards,
Micha³ Miros³aw
