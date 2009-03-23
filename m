Return-Path: <linux-kernel-owner+w=401wt.eu-S1758025AbZCWJQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025AbZCWJQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 05:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756713AbZCWJQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 05:16:33 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55641 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbZCWJQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 05:16:32 -0400
Date: Mon, 23 Mar 2009 10:16:19 +0100
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Daniel =?iso-8859-15?Q?Kr=FCger?= 
	<daniel.krueger@systec-electronic.com>
Cc: david@lang.hm, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Robert Schwebel <r.schwebel@pengutronix.de>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Michael Olbrich <mol@pengutronix.de>,
       Wolfram Sang <wsa@pengutronix.de>,
       Marc Kleine-Budde <mkl@pengutronix.de>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: The Linux Staging tree, what it is and is not.
Message-ID: <20090323091619.GN5367@pengutronix.de>
References: <20090318183232.GA11594@kroah.com> <20090320005808.GM5367@pengutronix.de> <20090320100146.6599f671@lxorguk.ukuu.org.uk> <20090320103545.GQ5367@pengutronix.de> <20090320105556.4375176d@lxorguk.ukuu.org.uk> <20090320111552.GS5367@pengutronix.de> <49C3B33F.1020905@systec-electronic.com> <20090320153713.65bf8e2d@lxorguk.ukuu.org.uk> <alpine.DEB.1.10.0903201332130.16753@asgard.lang.hm> <49C7505B.2010205@systec-electronic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49C7505B.2010205@systec-electronic.com>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 10:06:01 up 33 days, 59 min, 24 users,  load average: 0.10, 0.10,
	0.06
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 10:03:23AM +0100, Daniel Krüger wrote:
>> what I understand from this thread is that the hardware is a standard
>> ethernet card.
>
> It may be a standard Ethernet controller. But it could also be a
> controller with a special hardware acceleration.

Industrial Ethernets or CANopen can also be implemented with hardware
solutions like a netX or an FPGA, which both would have shared memory to
the CPU plus a part of the stack in userspace; however, this is nothing
that should be abstracted with this driver infrastructure. It is an
issue for a more higher level interface, which is what we will provide
with the OSADL Fieldbus Framework:

+------------------------------------+
I            Application             I
+------------------------------------+

+------------------------------------+
I         Process Data Library       I
+------------------------------------+

+--------------------+ +-------------+
I   $FIELDBUS Stack  I I  Userspace  I
I                    I I    Driver   I
+--------------------+ +-------------+

+--------------------+ +-------------+
I AF_CAN / AF_PACKET I I     UIO     I
I     Socket         I I             I
+--------------------+ +-------------+ Userspace
                                        ___^___
+--------------------+ +-------------+     v
I    eth/can Card    I I UIO driver  I  Kernel
I with normal driver I I             I
+--------------------+ +-------------+

rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
