Return-Path: <linux-kernel-owner+w=401wt.eu-S935569AbXEVPlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935569AbXEVPlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 11:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759248AbXEVPk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 11:40:56 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:59169 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757885AbXEVPkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 11:40:55 -0400
Message-ID: <46530F02.7010802@drzeus.cx>
Date: Tue, 22 May 2007 17:40:50 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
       "=?ISO-8859-1?Q?Kristian_H=F8gsberg?=" <krh@bitplanet.net>
Subject: Re: Race free attributes in sysfs
References: <46502A8B.70803@drzeus.cx>	 <3ae72650705211050p6b6cefbdya70dd4e0a27e2d1b@mail.gmail.com>	 <4651E866.5010304@drzeus.cx> <1179775695.3320.82.camel@lov.localdomain>
In-Reply-To: <1179775695.3320.82.camel@lov.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> We could change the driver-core to suppress the creation of an attribute
> if the attribute's show() or store() method returns something like
> -ENOENT at registration time?
> The driver would pass _all_ possible attributes of the device at
> registration time, but the core would only create the attributes which
> are implemented for this particular device? Would that work for you?
>   

Not sure. Not in an obvious way at least.

It also doesn't feel like "the kernel way". Generally you can
create/allocate an object, assign attributes to it, then activate it.
Couldn't it be done so that I can add sysfs stuff to a device after I
just initialized it? (but before I add it).

> You can assign any number of attribute groups to the device. If they
> don't have a group name, they will all be created directly at the device
> level. Would that work for you?
>
>   

I've had a look at sysfs groups and the biggest beef I have with those
is that they're too low level. In order to use them I first need to
create device attributes, then create an array of pointers to each attr
member. It would be nice if I could just feed an array of device
attributes (i.e. I want wrappers).

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

