Return-Path: <linux-kernel-owner+w=401wt.eu-S932819AbXEVIjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819AbXEVIjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 04:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757321AbXEVIjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 04:39:00 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:6484 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756581AbXEVIi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 04:38:59 -0400
Date: Tue, 22 May 2007 10:38:57 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Kristian =?ISO-8859-15?Q?H=F8gsberg?= <krh@bitplanet.net>
Subject: Re: Race free attributes in sysfs
Message-ID: <20070522103857.17bf1a3e@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <1179775695.3320.82.camel@lov.localdomain>
References: <46502A8B.70803@drzeus.cx>
	<3ae72650705211050p6b6cefbdya70dd4e0a27e2d1b@mail.gmail.com>
	<4651E866.5010304@drzeus.cx>
	<1179775695.3320.82.camel@lov.localdomain>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.12; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007 21:28:15 +0200,
Kay Sievers <kay.sievers@vrfy.org> wrote:

> We could change the driver-core to suppress the creation of an attribute
> if the attribute's show() or store() method returns something like
> -ENOENT at registration time?
> The driver would pass _all_ possible attributes of the device at
> registration time, but the core would only create the attributes which
> are implemented for this particular device? Would that work for you?
> 
> There are already subsystems who need to do similar things internally
> (firewire), and it may be nice to add such functionality to the core.

This sounds a bit hackish (overloading the meaning of the show() and
store() methods).

> You can assign any number of attribute groups to the device. If they
> don't have a group name, they will all be created directly at the device
> level. Would that work for you?

What about generic "conditional attribute groups"? Add a check() method
which is called just before adding them, and only add them if check()
returned 0 (or doesn't exist)?
