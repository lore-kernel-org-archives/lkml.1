Return-Path: <linux-kernel-owner+w=401wt.eu-S1753825AbZHMIz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbZHMIz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 04:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753799AbZHMIz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 04:55:28 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58175 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbZHMIz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 04:55:26 -0400
Date: Thu, 13 Aug 2009 10:55:25 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Xavier Bestel <xavier.bestel@free.fr>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       gregkh@suse.de, Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
	/dev
Message-ID: <20090813085525.GK13320@pengutronix.de>
References: <20090805171513.GA10443@kroah.com> <20090812213348.GY13320@pengutronix.de> <1250151940.18980.424.camel@skunk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1250151940.18980.424.camel@skunk>
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
X-Uptime: 10:52:48 up 7 days, 20:11, 42 users,  load average: 6.06, 5.83,
	5.30
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 10:25:40AM +0200, Xavier Bestel wrote:
> On Wed, 2009-08-12 at 23:33 +0200, Robert Schwebel wrote:
> > On Wed, Aug 05, 2009 at 10:15:13AM -0700, Greg KH wrote:
> > > Here's the devtmpfs patch again.
> > 
> > As an embedded distro maintainer, I'd really like such an approach. With
> > ptxdist, we can today build the complete rootfs for an embedded system
> > without root permissions - just if we want to nfs-root boot the boards
> > during development, it doesn't work, because you have to create
> > /dev/console, /dev/null and /dev/zero and that works only for root.
> 
> Have you tried genext2fs ? It lets you create a filesystem image
> complete with device nodes as a normal user.

Creating images is no problem, we use fakeroot to create all kinds of
images (JFFS2, ext2, ext3 etc). But during development, embedded people
often boot their boards with tftpboot/nfsroot in order to do quick
development cycles without re-flashing the hardware, and creating
devicenodes on nfs-exported filesystems doesn't work without root
access.

Since udev, the whole system works almost without pre-created device
nodes, but for console, null and zero there is no real alternative. We
use sudo right now when they are created, but that's a rather uggly
solution.

rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
