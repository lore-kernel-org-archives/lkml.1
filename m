Return-Path: <linux-kernel-owner+w=401wt.eu-S1754955AbZA0VF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbZA0VF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 16:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbZA0VFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 16:05:18 -0500
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1845 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbZA0VFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 16:05:16 -0500
Date: Tue, 27 Jan 2009 22:05:10 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29rc1 brakes usb
Message-ID: <20090127210509.GG6158@vanheusden.com>
References: <20090126170130.GG6158@vanheusden.com> <200901262011.20545.oliver@neukum.org> <20090127195519.GB6158@vanheusden.com> <200901272204.22702.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901272204.22702.oliver@neukum.org>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Reply-By: Sat Jan 24 21:33:23 CET 2009
X-Message-Flag: www.vanheusden.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > Since version 2.6.29rc1 querying cleware USb devices no longer works.
> > > > 2.6.28 works fine. 2.6.29-rc2 also no longer works.
> > > 
> > > What kind of device is this? What happens if you try to use the device?
> > > Isn't it detected, do you get an error?
> > 
> > It is a powerswitch that can be toggled via USB. Cleware also has
> > sensors (temperature, humidity, etc.) that all can be handled via a
> > commandline utility I wrote.
> > It has been a while but if i remember correctly the failing ioctl is for
> > determing the serial number of the device. That is required to talk to
> > the right device. http://www.vanheusden.com/clewarecontrol/
> 
> There's a known bug in hiddev. Please test the included patch.

Works!

Acked-by: Folkert van Heusden <folkert@vanheusden.com>

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
MultiTail is een flexibele tool voor het volgen van logfiles en
uitvoer van commando's. Filteren, van kleur voorzien, mergen,
'diff-view', etc. http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
