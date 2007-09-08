Return-Path: <linux-kernel-owner+w=401wt.eu-S1752673AbXIHIxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673AbXIHIxo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 04:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbXIHIxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 04:53:37 -0400
Received: from smtp-106-saturday.noc.nerim.net ([62.4.17.106]:4374 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751789AbXIHIxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 04:53:36 -0400
Date: Sat, 8 Sep 2007 10:55:34 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, dmitry.torokhov@gmail.com
Subject: Re: Platform device id
Message-ID: <20070908105534.2e8e7d8a@hyperion.delvare>
In-Reply-To: <20070908035022.GF4357@khazad-dum.debian.net>
References: <20070907153559.17faf9d1@hyperion.delvare>
	<d120d5000709070758i1b54a37o3d3977304a84b2c1@mail.gmail.com>
	<20070907164129.65816B9389@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	<20070907210029.GB4357@khazad-dum.debian.net>
	<20070907214116.5051B237214@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	<20070907220407.GE4357@khazad-dum.debian.net>
	<20070908001835.C7F721B729B@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	<20070908035022.GF4357@khazad-dum.debian.net>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Sep 2007 00:50:22 -0300, Henrique de Moraes Holschuh wrote:
> On Fri, 07 Sep 2007, David Brownell wrote:
> > > I don't feel like drivers like hdaps, thinkpad-acpi, dock, bay,
> > > and many others really belong in the platform bus.  But that's
> > > what happens right now.
> > 
> > As a rule, there needs to be a Good Reason to create a new bus
> > type.  A "feel" is a pretty weak reason...
> 
> The "feel" is there because:
> 
> 1. Comments about how what we do is wrong for the platform bus (i.e.  adding
>    the devices and the driver in the same module). Even the documentation
>    for platform devices make it quite clear we are abusing it.  There was
>    one of those comments in this very thread.

This more general than just the platform bus. It's how the Linux 2.6
device driver model is designed.

There are alternatives to the way hdaps and thinkpad_acpi instantiate
their devices:

* These drivers use DMI to find out whether they run on supported
hardware. The same detection code could be moved to a separate driver
(possibly the same one for all DMI-detected devices) and that separate
driver would instantiate the devices as needed. Then the usual
hotplug/coldplug rules apply.

* Detection could be moved to user-space entirely, then we would only
need a way to instantiate these specific devices from user-space. This
exists in other areas (scsi, network) for quite some times already so
it shouldn't be too difficult.

> 2. The fact that a module that has a number of different devices has to
>    register itself a number of times as a driver, if it wants to name the
>    devices something different...

Sounds like you have a design issue here to start with. Supporting
several significantly different devices in the same module is not
something that we do usually.

-- 
Jean Delvare
