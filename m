Return-Path: <linux-kernel-owner+w=401wt.eu-S1761238AbZLKTV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761238AbZLKTV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 14:21:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760947AbZLKTVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 14:21:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760919AbZLKTVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 14:21:23 -0500
Subject: Re: [PATCH 0/2] Add support for Sphairon Homelink 1202 USB WLAN
From: Dan Williams <dcbw@redhat.com>
To: Stefan Seyfried <stefan.seyfried@googlemail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20091211160124.4db2da76@strolchi.home.s3e.de>
References: <1260282095-17042-1-git-send-email-stefan.seyfried@googlemail.com>
	 <20091211133603.46bec686@strolchi.home.s3e.de>
	 <20091211144221.GA6663@tuxdriver.com>
	 <20091211160124.4db2da76@strolchi.home.s3e.de>
Content-Type: text/plain
Date: Fri, 11 Dec 2009 11:21:10 -0800
Message-Id: <1260559270.6254.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-11 at 16:01 +0100, Stefan Seyfried wrote:
> On Fri, 11 Dec 2009 09:42:22 -0500
> "John W. Linville" <linville@tuxdriver.com> wrote:
> 
> > On Fri, Dec 11, 2009 at 01:36:03PM +0100, Stefan Seyfried wrote:
> > > Is anyhting wrong with those?
> > > Are those too trivial and "USB only" and thus better suited for direct
> > > submission to Greg?
> > 
> > Trivial or not, they are wireless LAN patches and they go here.
> 
> That's what i guessed, too. I was just deafened by the silence ;)
> 
> > It strikes me as strange that you are hitting two drivers to support
> > one device.  Are you saying that your ar9170usb has the goofy storage
> > device thing using the same USB IDs that the zd1211rw devices like that
> > used?  I suppose that makes some sense given the shared heritage...
> 
> Yes, exactly. And a different configuration (different endpoint),
> that's why I had to touch the zd1211rw driver, even though it is
> otherwise totally unrelated to the device.
> 
> The method with the reverse loop counting down from ep1 to ep0 was
> chosen to be as sure as possible to not break the other devices that
> are already working.
> 
> > We did just have a long (and possibly unresolved thread) about
> > this type of practice (i.e. eject in the driver) not too long ago.
> > But since zd1211rw is already doing this, maybe this patch is
> > acceptable...?
> 
> Maybe a separate driver that is ejecting all those fake storage
> devices, be it 3G modems or wireless LAN might be a good idea, but I am
> probably not the right one to code that ;)
> Or maybe we decide that userspace should handle it for all devices...

If the device actually changes USB IDs after the switch, then the right
place to put this code is probably unusual_devs instead of
touching /two/ drivers.  I'd say extract the code from zd1211rw and put
the new code that works for both zd1211rw/ar9170 into unusual_devs.  In
fact, people might be happier if you posted two patches, (1) move the
code to unusual_devs unchanged, and (2) fix up the moved code to support
the new device's behavior.

Dan


