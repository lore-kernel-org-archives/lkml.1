Return-Path: <linux-kernel-owner+w=401wt.eu-S1756861AbZD2MTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861AbZD2MTX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 08:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbZD2MTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 08:19:14 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:49113 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbZD2MTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 08:19:13 -0400
Date: Wed, 29 Apr 2009 14:19:01 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Michael E Brown <Michael_E_Brown@dell.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: Class device namespaces
Message-ID: <20090429141901.4b8ff47b@hyperion.delvare>
In-Reply-To: <ac3eb2510904280536k656fad91neb0383f77bfb8ee7@mail.gmail.com>
References: <20090329174836.6de797d6@hyperion.delvare>
	<ac3eb2510903290936tc80e904o2266108bd6c04cf2@mail.gmail.com>
	<20090330104952.26f03c13@hyperion.delvare>
	<ac3eb2510903300424s2604d027h653a3f77163e0242@mail.gmail.com>
	<20090426085401.3788fc9c@hyperion.delvare>
	<ac3eb2510904260642s66a15a8eg5811fdc6b339d493@mail.gmail.com>
	<20090427180036.269a40b3@hyperion.delvare>
	<ac3eb2510904271457w30aac8f5j9ee0d6508f8444c1@mail.gmail.com>
	<20090428100830.1a5d944c@hyperion.delvare>
	<ac3eb2510904280536k656fad91neb0383f77bfb8ee7@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kay,

On Tue, 28 Apr 2009 14:36:27 +0200, Kay Sievers wrote:
> On Tue, Apr 28, 2009 at 10:08, Jean Delvare <khali@linux-fr.org> wrote:
> > On Mon, 27 Apr 2009 23:57:40 +0200, Kay Sievers wrote:
> 
> >> Register a "i2c" bus_type with the core, and instead of assigning
> >> dev.class = class, you assign dev.bus = bus to the devices you
> >> register, that should work, if there is nothing more complicated going
> >> on in the background.
> >
> > Err, I'm confused. We _already_ have an "i2c" bus type, and we already
> > assign dev.bus = &i2c_bus_type, but for i2c devices (or slaves if you
> > prefer), not adapters (masters). Doing the same for adapters (the
> > parents) and devices (the children) looks totally wrong to me.
> >
> > Are you really certain that i2c-adapters should be bus devices rather
> > than class devices?
> 
> i2c seem to do things nothing else is doing, so I can not really be
> certain. :) But I still think it would be nice to do that, if the
> adapters have child devices.
> 
> It is unusual to stack class devices of different classes. The common
> model would be to put the adapters, and all other possible device
> types to the already existing "i2c" bus, and distinguish them by name,
> and internally by "struct device_type" if needed.
> 
> Like USB puts usb-interface, usb-device, root-hub under the "usb"
> bus_type, or SCSI puts host, target, lun under the "scsi" bus. All
> these different devices build the tree of the core devices of a
> specific subsystem.
> 
> Any possible class devices would only be leaves in these trees, which
> do not have any interconnection between the individual class devices.

OK, I see the idea. I may give it a try, but I'd rather get rid of the
legacy i2c binding model first. One subsystem-wide cleanup at a time ;)

Thanks for the clarification!

-- 
Jean Delvare
