Return-Path: <linux-kernel-owner+w=401wt.eu-S1763666AbYECMXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763666AbYECMXo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 08:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755254AbYECMXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 08:23:37 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:45408 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284AbYECMXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 08:23:36 -0400
Date: Sat, 3 May 2008 14:23:14 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clocksource: Fix permissions for available_clocksource
Message-ID: <20080503122314.GA5996@osiris.boeblingen.de.ibm.com>
References: <20080502104940.GA4426@osiris.boeblingen.de.ibm.com> <alpine.LFD.1.10.0805021635030.6003@apollo.tec.linutronix.de> <20080502152730.GA5220@osiris.boeblingen.de.ibm.com> <alpine.LFD.1.10.0805021731550.6003@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805021731550.6003@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 05:34:06PM +0200, Thomas Gleixner wrote:
> On Fri, 2 May 2008, Heiko Carstens wrote:
> > On Fri, May 02, 2008 at 04:36:37PM +0200, Thomas Gleixner wrote:
> > > On Fri, 2 May 2008, Heiko Carstens wrote:
> > > > From: Heiko Carstens <heiko.carstens@de.ibm.com>
> > > > 
> > > > File permissions for
> > > > /sys/devices/system/clocksource/clocksource0/available_clocksource
> > > > are 600 which allows write access. But this is in fact a read only
> > > > file. So change permissions to 400.
> > > 
> > > Indeed. The question is whether we should make this 444. There is no
> > > harm, when users can read the info. Same applies for the
> > > current_clocksource entry, making it 644 should be fine.
> > 
> > Sure, I can send an on-top patch for this.
> 
> Yes, please.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 kernel/time/clocksource.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/time/clocksource.c
===================================================================
--- linux-2.6.orig/kernel/time/clocksource.c
+++ linux-2.6/kernel/time/clocksource.c
@@ -471,10 +471,10 @@ sysfs_show_available_clocksources(struct
 /*
  * Sysfs setup bits:
  */
-static SYSDEV_ATTR(current_clocksource, 0600, sysfs_show_current_clocksources,
+static SYSDEV_ATTR(current_clocksource, 0644, sysfs_show_current_clocksources,
 		   sysfs_override_clocksource);
 
-static SYSDEV_ATTR(available_clocksource, 0400,
+static SYSDEV_ATTR(available_clocksource, 0444,
 		   sysfs_show_available_clocksources, NULL);
 
 static struct sysdev_class clocksource_sysclass = {
