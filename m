Return-Path: <linux-kernel-owner+w=401wt.eu-S935913AbXEUT4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935913AbXEUT4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933965AbXEUT37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:29:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:64097 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934157AbXEUT35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:29:57 -0400
Subject: Re: Race free attributes in sysfs
From: Kay Sievers <kay.sievers@vrfy.org>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
       Kristian =?ISO-8859-1?Q?H=F8gsberg?= <krh@bitplanet.net>
In-Reply-To: <4651E866.5010304@drzeus.cx>
References: <46502A8B.70803@drzeus.cx>
	 <3ae72650705211050p6b6cefbdya70dd4e0a27e2d1b@mail.gmail.com>
	 <4651E866.5010304@drzeus.cx>
Content-Type: text/plain
Date: Mon, 21 May 2007 21:28:15 +0200
Message-Id: <1179775695.3320.82.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+m5MXNDUBji9B9v+qYvlSZz71gSUgQrxrghHv
 2LnjLCUFlODiK7K+moFCOsttgRUqo7GitR9ydxg/85JHGLkyAB
 9J2Eox4S1LmIAbSoaCfQf0ntN6eopBO
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-21 at 20:43 +0200, Pierre Ossman wrote:
> Kay Sievers wrote:
> >
> > Do you have a fixed set of attribute names, where you just want to
> > create a subset from that matches the individual device, or do you
> > need some sort of free naming for the attributes?
> 
> Currently, the names are fixed (and I don't see any pressing need for
> having dynamic names).

We could change the driver-core to suppress the creation of an attribute
if the attribute's show() or store() method returns something like
-ENOENT at registration time?
The driver would pass _all_ possible attributes of the device at
registration time, but the core would only create the attributes which
are implemented for this particular device? Would that work for you?

There are already subsystems who need to do similar things internally
(firewire), and it may be nice to add such functionality to the core.

> I do want to have the ability to add attributes
> in different parts of the code though since it allows me to group the
> sysfs stuff closer to the function it accesses.

You can assign any number of attribute groups to the device. If they
don't have a group name, they will all be created directly at the device
level. Would that work for you?

Thanks,
Kay

