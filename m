Return-Path: <linux-kernel-owner+w=401wt.eu-S1760170AbYFDU7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760170AbYFDU7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 16:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbYFDU7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 16:59:24 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:43067 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbYFDU7Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 16:59:24 -0400
Date: Wed, 4 Jun 2008 22:58:30 +0200
From: Jean Delvare <khali@linux-fr.org>
To: =?ISO-8859-1?B?yXJpYw==?= Piel <Eric.Piel@tremplin-utc.net>
Cc: Andrew Morton <akpm@osdl.org>, pavel@ucw.cz,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Yan Burman <burman.yan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       HWMON <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 2.6.25.4] hwmon: HP Mobile Data Protection  System 3D
 ACPI driver -- please review!
Message-ID: <20080604225830.1dff64fc@hyperion.delvare>
In-Reply-To: <4846EBF5.2030406@tremplin-utc.net>
References: <1212235533.3815.5.camel@localhost>
	<4846EBF5.2030406@tremplin-utc.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Wed, 04 Jun 2008 21:24:37 +0200, Éric Piel wrote:
> We haven't received any review for this driver since last week's post by
> Yan :-( That's why I'm adding explicitly as receivers of this email all
> the people who have reviewed the first two previous takes. Apologies for
> the possible multiple receptions.
> 
> It would be _really really kind_ if some of you could take some time and
> comment (or simply ACK ;-) ) this code. It adds support for hardware
> which can be found in mostly every HP Compaq laptop less than three
> years old. It's quite worthy.
> 
> Mark, as maintainer of the hwmon tree, would accept this driver? Let us
> know if there are things we need to change.

If you didn't receive any answer, my guess is that it's because you're
trying to add this driver to the wrong tree. Why would this driver go
in drivers/hwmon and be reviewed by hwmon folks, when it doesn't expose
a single hwmon attribute to user-space?

I guess you thought putting the driver there would be fine because
that's where the hdaps and ams drivers are, but IMHO the hdaps and ams
drivers should never have been placed in drivers/hwmon. These devices
really aren't hardware monitoring chips is the traditional sense of the
term. They are different chips, serving different purposes and
deserving a totally different interface. They'd better live in a
different subsystem and be maintainer by a different crew with interest
in these devices and hardware to test the drivers.

This discussion thread might sched some light on a possible approach:
http://marc.info/?l=lm-sensors&m=121127824726050&w=2

So my advice is that you don't wait for a review from the hwmon people,
because apparently we don't have much interest in this type of device,
so you'll be waiting forever. You're much better adding the mdps driver
to drivers/misc through Andrew Morton, at least until someone takes
care of creating a subsystem for this type of devices and move all
existing drivers there.

Would someone object to moving the hdaps and ams (and possibly
applesmc) drivers to drivers/misc?

-- 
Jean Delvare
