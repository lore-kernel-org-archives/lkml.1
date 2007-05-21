Return-Path: <linux-kernel-owner+w=401wt.eu-S1762992AbXEUPoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762992AbXEUPoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 11:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755705AbXEUPoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 11:44:09 -0400
Received: from mx34.mail.ru ([194.67.23.200]:23530 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756243AbXEUPoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 11:44:08 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug 8498], [Bug 8510], and Re: Can't s2ram 22-rc2
Date: Mon, 21 May 2007 19:43:55 +0400
User-Agent: KMail/1.9.6
Cc: Soeren Sonnenburg <kernel@nn7.de>, Avuton Olrich <avuton@gmail.com>,
       Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0705211040330.4496-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0705211040330.4496-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2188584.Z8pGUFHVNp";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705211943.57283.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2188584.Z8pGUFHVNp
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 21 May 2007, Alan Stern wrote:
> Andrey, Soeren, and Avuton: Please try this patch with 2.6.22-rc2 or
> later and see if it fixes your problems.
>

It does; thank you!

> Greg, if this works then I'll send it in the proper form for a patch,
> and you can use it to replace
>
> 	usb-make-the-autosuspend-workqueue-thread-freezable.patch
>
> Alan Stern
>
>
> Index: 2.6.22-rc2/drivers/usb/core/usb.c
> ===================================================================
> --- 2.6.22-rc2.orig/drivers/usb/core/usb.c
> +++ 2.6.22-rc2/drivers/usb/core/usb.c
> @@ -205,7 +205,7 @@ struct device_type usb_device_type = {
>
>  static int ksuspend_usb_init(void)
>  {
> -	ksuspend_usb_wq = create_singlethread_workqueue("ksuspend_usbd");
> +	ksuspend_usb_wq = create_freezeable_workqueue("ksuspend_usbd");
>  	if (!ksuspend_usb_wq)
>  		return -ENOMEM;
>  	return 0;



--nextPart2188584.Z8pGUFHVNp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGUb49R6LMutpd94wRAn+gAKCHsimreEdVyPUPCfOTjOLzHjXFBACgh9Zt
65H2C5t6OGVU1byEOntbduk=
=DjLW
-----END PGP SIGNATURE-----

--nextPart2188584.Z8pGUFHVNp--
