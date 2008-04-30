Return-Path: <linux-kernel-owner+w=401wt.eu-S1761608AbYD3P2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761608AbYD3P2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 11:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756442AbYD3P2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 11:28:23 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:4354 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309AbYD3P2W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 11:28:22 -0400
Date: Wed, 30 Apr 2008 17:28:04 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Kasper Sandberg <lkml@metanurb.dk>, Rudolf Marek <r.marek@assembler.cz>,
       Maxim Levitsky <maximlevitsky@gmail.com>, trenn@suse.de,
       Len Brown <lenb@kernel.org>, Matthew <jackdachef@gmail.com>,
       linux-acpi@vger.kernel.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Zhang, Rui" <rui.zhang@intel.com>
Subject: Re: Linux 2.6.25 (coretemp reads high temperatures)
Message-ID: <20080430172804.0bc3e05f@hyperion.delvare>
In-Reply-To: <20080430145110.GC3543@khazad-dum.debian.net>
References: <e85b9d30804180837y39c52e26i588e4b67c87a5e9d@mail.gmail.com>
	<200804182151.49021.lenb@kernel.org>
	<200804231143.10875.maximlevitsky@gmail.com>
	<1209406784.11608.15.camel@localhost>
	<1209474423.1784.837.camel@queen.suse.de>
	<20080429170824.09540206@hyperion.delvare>
	<48179DB4.8040701@assembler.cz>
	<1209514274.27499.12.camel@localhost>
	<20080430082005.4b76186f@hyperion.delvare>
	<20080430145110.GC3543@khazad-dum.debian.net>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 11:51:10 -0300, Henrique de Moraes Holschuh wrote:
> On Wed, 30 Apr 2008, Jean Delvare wrote:
> > On Wed, 30 Apr 2008 02:11:14 +0200, Kasper Sandberg wrote:
> > > So, im confused.. The reason for this is that the internal sensor is
> > > operating on some sort of weird scale, and thus when you interpolate it
> > > into "your" scale, it doesent quite come out in the actual degrees
> > > celcius the cpu temperature really is?
> > 
> > It's really only an offset, rather than scaling. The temperature
> > reported by the Core and Core2 CPUs is a relative temperature. It tells
> > how far you are from the maximum temperature the CPU can survive. The
> > value is expressed in (relative) degrees C.
> 
> Ah, please ignore my email about ITUs (Intel thermal units), then.  The
> above means 1ITU=1°C, but their zeros are at different places.
> 

Correct. 1ITU=1°C as a difference between temperatures but not as
absolute temperatures.

> > Rudolf did his best to find out the (absolute) temperature each CPU
> > model can survive (known as TJmax) so that the coretemp driver can
> > provide an absolute temperature to user-space, as all other hardware
> > monitoring drivers do. Our hope was to limit the confusion, but it
> > seems we failed ;) Maybe it would be better if the driver was reporting
> > the relative temperature value directly when we don't know the TJmax
> > value for sure - but then all user-space tools would need to learn how
> > to deal with this.
> 
> Actually, just libsensors would, and the local admin can adjust it at
> will using the config file.

Hmm, good point. I had not considered that we could hide this detail
inside libsensors. I'll need to think about it.

That being said, in practice that would probably not be too different
from just making temp1_crit writable in the coretemp driver.

> 
> Nobody in userspace should be reading hwmon sysfs directly without the
> use of libsensors.

Except for the features which are not supported by libsensors (e.g.
pwm).

> If they are, it is their bug, and it is unsupported AFAIK.

Unsupported by me, certainly, and stupid as well for sure, especially
given the amount of work that has gone into the new libsensors API to
avoid this.

-- 
Jean Delvare
