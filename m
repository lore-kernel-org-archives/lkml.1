Return-Path: <linux-kernel-owner+w=401wt.eu-S1753168AbZLPQsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbZLPQsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 11:48:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbZLPQsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 11:48:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109AbZLPQsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 11:48:21 -0500
Subject: Re: [PATCH] move eject code from zd1211rw to usb-storage
From: Dan Williams <dcbw@redhat.com>
To: Stefan Seyfried <stefan.seyfried@googlemail.com>
Cc: Josua Dietze <digidietze@draisberghof.de>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       usb-storage@lists.one-eyed-alien.net
In-Reply-To: <20091216131452.49ad183b@strolchi.home.s3e.de>
References: <1260878800-14691-1-git-send-email-stefan.seyfried@googlemail.com>
	 <4B278191.1010009@draisberghof.de> <200912151611.08576.oliver@neukum.org>
	 <20091215180300.GF16426@one-eyed-alien.net>
	 <20091216114932.4bede511@strolchi.home.s3e.de>
	 <4B28C2F7.7040207@draisberghof.de>
	 <20091216131452.49ad183b@strolchi.home.s3e.de>
Content-Type: text/plain
Date: Wed, 16 Dec 2009 08:47:17 -0800
Message-Id: <1260982037.2179.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-16 at 13:14 +0100, Stefan Seyfried wrote:
> On Wed, 16 Dec 2009 12:22:31 +0100
> Josua Dietze <digidietze@draisberghof.de> wrote:
> 
> > Stefan Seyfried schrieb:
> > > Preferably some code that can be built actually?
> > 
> > If the "eject" from SCSI tools does not work, "usb_modeswitch" can 
> > send customized bulk messages to devices.
> 
> for my device, eject seems to be enough, so I'll be trying to get
> this into udev.
> 
> > http://www.draisberghof.de/usb_modeswitch/
> 
> Unfortunately it cannot be built with current libusb and once you
> compile it without warnings turned off (which is the default!), you
> probably don't want to run it anymore ;)

At this point, however, usb_modeswitch is the correct place to put eject
code for all devices.  I wouldn't put this code into udev; I'd put it
into usb_modeswitch instead, since usb_modeswitch is (a) the de-facto
standard, (b) has the most users, and (c) has the most devices.  Yes, it
has problems, but at this point we should fix those problems instead of
creating 5 different eject tools.

Dan


