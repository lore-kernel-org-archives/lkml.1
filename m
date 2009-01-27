Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbZA0Two@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbZA0Two (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 14:52:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755851AbZA0Twf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 14:52:35 -0500
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4234 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbZA0Twe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 14:52:34 -0500
Date: Tue, 27 Jan 2009 20:52:30 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29rc1 breakes usb: hiddev device no longer available
Message-ID: <20090127195229.GA6158@vanheusden.com>
References: <20090126170130.GG6158@vanheusden.com> <20090126182707.GI6158@vanheusden.com> <200901262005.08168.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200901262005.08168.oliver@neukum.org>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Reply-By: Sat Jan 24 21:33:23 CET 2009
X-Message-Flag: www.unixexpert.nl
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Since version 2.6.29rc1 querying cleware USb devices no longer works.
> > > 2.6.28 works fine. 2.6.29-rc2 also no longer works.
> > 
> 
> > the is the FAILURE situation (2.6.29-rc*):
> > open("/dev/usb/hiddev0", O_RDWR)        = 3
> > ioctl(3, HIDIOCGDEVINFO, 0xbf90c0d8)    = 0
> > ioctl(3, HIDIOCAPPLICATION, 0)          = -6291455
> > ioctl(3, HIDIOCGSTRING, 0x804e2c0)      = -1 ENODEV (No such device)
> Please try this patch.

Yes, that fixes it! Thanks!


Ack-by: folkert@vanheusden.com

> --- linux-2.6/drivers/hid/usbhid/hiddev.c.alt	2009-01-26 20:03:10.000000000 +0100
> +++ linux-2.6/drivers/hid/usbhid/hiddev.c	2009-01-26 20:03:17.000000000 +0100
> @@ -656,7 +656,7 @@ static long hiddev_ioctl(struct file *fi
>  
>  	case HIDIOCGSTRING:
>  		mutex_lock(&hiddev->existancelock);
> -		if (!hiddev->exist)
> +		if (hiddev->exist)
>  			r = hiddev_ioctl_string(hiddev, cmd, user_arg);
>  		else
>  			r = -ENODEV;


Folkert van Heusden

-- 
MultiTail è uno flexible tool per seguire di logfiles e effettuazione
di commissioni. Feltrare, provedere da colore, merge, 'diff-view',
etc. http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
