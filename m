Return-Path: <linux-kernel-owner+w=401wt.eu-S1161140AbXBGKYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161140AbXBGKYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 05:24:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161141AbXBGKYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 05:24:14 -0500
Received: from tim.rpsys.net ([194.106.48.114]:40272 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161140AbXBGKYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 05:24:13 -0500
Subject: Re: [PATCH] input: Schedule removal of compaq touchscreen
	emulation (tsdev.c)
From: Richard Purdie <rpurdie@rpsys.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
       Linux-Input <linux-input@atrey.karlin.mff.cuni.cz>,
       James Simmons <jsimmons@infradead.org>
In-Reply-To: <20070206205202.fde782ce.akpm@linux-foundation.org>
References: <1170780159.5826.71.camel@localhost.localdomain>
	 <20070206205202.fde782ce.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 07 Feb 2007 10:23:46 +0000
Message-Id: <1170843826.5920.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-06 at 20:52 -0800, Andrew Morton wrote:
> On Tue, 06 Feb 2007 16:42:39 +0000 Richard Purdie <rpurdie@rpsys.net> wrote:
> 
> >  ---------------------------
> > +
> > +What:   Compaq touchscreen device emulation
> > +When:   Oct 2007
> > +Files:  drivers/input/tsdev.c
> > +Why:    The code says it was obsolete when it was written in 2001.
> > +        tslib is a userspace library which does anything tsdev can do and
> > +        much more besides in userspace where this code belongs. There is no
> > +        longer any need for tsdev and applications should have converted to
> > +        use tslib by now.
> > +        The name "tsdev" is also extremely confusing and lots of people have
> > +        it loaded when they don't need/use it.
> > +Who:    Richard Purdie <rpurdie@rpsys.net>
> 
> I think it best to add a printk to the driver's initialisation routine warning
> any remaining users that it is going away.

I suspect a message upon driver init will scare a lot of people due to
the "lots of people have it loaded when they don't need/use it" above.
How about printing something upon device open? A revised version is
below.

----

Schedule removal of Compaq touchscreen emulation (drivers/input/tsdev.c)

Its old, was obsolete when it was written by the authors own admission
and much better userspace solutions like tslib now exist. The name is
also confusing.

Signed-off-by: Richard Purdie <rpurdie@rpsys.net>
Acked-by: James Simmons <jsimmons@infradead.org>
---

 Documentation/feature-removal-schedule.txt |   14 ++++++++++++++
 drivers/input/tsdev.c                      |    4 ++++
 2 files changed, 18 insertions(+)

Index: linux/Documentation/feature-removal-schedule.txt
===================================================================
--- linux.orig/Documentation/feature-removal-schedule.txt	2007-02-06 20:32:59.000000000 +0000
+++ linux/Documentation/feature-removal-schedule.txt	2007-02-07 09:15:40.000000000 +0000
@@ -325,3 +325,17 @@ Why:	Unmaintained for years, superceded 
 Who:	Jeff Garzik <jeff@garzik.org>
 
 ---------------------------
+
+What:   Compaq touchscreen device emulation
+When:   Oct 2007
+Files:  drivers/input/tsdev.c
+Why:    The code says it was obsolete when it was written in 2001.
+        tslib is a userspace library which does anything tsdev can do and
+	much more besides in userspace where this code belongs. There is no
+	longer any need for tsdev and applications should have converted to
+	use tslib by now.
+        The name "tsdev" is also extremely confusing and lots of people have
+	it loaded when they don't need/use it.
+Who:    Richard Purdie <rpurdie@rpsys.net>
+
+---------------------------
Index: linux/drivers/input/tsdev.c
===================================================================
--- linux.orig/drivers/input/tsdev.c	2007-01-18 00:52:44.000000000 +0000
+++ linux/drivers/input/tsdev.c	2007-02-07 09:32:15.000000000 +0000
@@ -151,6 +151,10 @@ static int tsdev_open(struct inode *inod
 	int i = iminor(inode) - TSDEV_MINOR_BASE;
 	struct tsdev_list *list;
 
+	printk(KERN_WARNING "tsdev (compaq touchscreen emulation) is scheduled "
+		"for removal.\nSee Documentation/feature-removal-schedule.txt "
+		"for details.\n");
+
 	if (i >= TSDEV_MINORS || !tsdev_table[i & TSDEV_MINOR_MASK])
 		return -ENODEV;
 





