Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbXEUDM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbXEUDM3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 23:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540AbXEUDMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 23:12:21 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:39646 "EHLO
	asav13.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbXEUDMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 23:12:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgoXABirUEZKhRO4W2dsb2JhbACBXIVniEUdDQURAQ
From: Dmitry Torokhov <dtor@insightbb.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: Race free attributes in sysfs
Date: Sun, 20 May 2007 23:12:18 -0400
User-Agent: KMail/1.9.3
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>
References: <46502A8B.70803@drzeus.cx>
In-Reply-To: <46502A8B.70803@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705202312.19191.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 May 2007 07:01, Pierre Ossman wrote:
> Hi Greg,
> 
> I'm reworking the sysfs stuff in the MMC layer to be a bit more flexible, but
> there is one thing that has me baffled; how do you add attributes to an object
> in a race free manner when you have a dynamic set of attributes.
> 
> I've looked at other parts of the kernel and they all use:
> 
> 1. Add object.
> 2. Add attributes.
> 
> To me, it seems like there's a window between 1 and 2 where the object is in
> /sys but doesn't have the proper attributes. Life for user space gets very
> annoying if it has to add artificial delays to avoid this window.
> 
> So how do I do this properly? Something like this would, from my point of view,
> be the sane method:
> 
> 1. Add hidden object.
> 2. Add attributes.
> 3. Show object.
> 

1. dev->uevent_suppress = 1;
2. device_register(dev);
3. device_create_file(dev, ...);
4. dev->uevent_suppress = 0;
5. kobject_uevent(&dev->kobj, KOBJ_ADD);

-- 
Dmitry
