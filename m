Return-Path: <linux-kernel-owner+w=401wt.eu-S936837AbYEBUgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936837AbYEBUgy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 16:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936750AbYEBUgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 16:36:33 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:46259 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934352AbYEBUgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 16:36:31 -0400
Date: Fri, 2 May 2008 22:36:15 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Jean Delvare <khali@linux-fr.org>, Kasper Sandberg <lkml@metanurb.dk>,
       Rudolf Marek <r.marek@assembler.cz>,
       Maxim Levitsky <maximlevitsky@gmail.com>, trenn@suse.de,
       Len Brown <lenb@kernel.org>, Matthew <jackdachef@gmail.com>,
       linux-acpi@vger.kernel.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Zhang, Rui" <rui.zhang@intel.com>
Subject: Re: Linux 2.6.25 (coretemp reads high temperatures)
Message-ID: <20080502203615.GF3956@ucw.cz>
References: <e85b9d30804180837y39c52e26i588e4b67c87a5e9d@mail.gmail.com> <200804182151.49021.lenb@kernel.org> <200804231143.10875.maximlevitsky@gmail.com> <1209406784.11608.15.camel@localhost> <1209474423.1784.837.camel@queen.suse.de> <20080429170824.09540206@hyperion.delvare> <48179DB4.8040701@assembler.cz> <1209514274.27499.12.camel@localhost> <20080430082005.4b76186f@hyperion.delvare> <20080430145110.GC3543@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080430145110.GC3543@khazad-dum.debian.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

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
> 
> Nobody in userspace should be reading hwmon sysfs directly without the
> use of libsensors.  If they are, it is their bug, and it is unsupported
> AFAIK.

Hmm, that's an interesting ABI design. No, I do not think that's a
good idea.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
