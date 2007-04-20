Return-Path: <linux-kernel-owner+w=401wt.eu-S1754474AbXDTTAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbXDTTAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 15:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbXDTTAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 15:00:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753306AbXDTTAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 15:00:47 -0400
Date: Fri, 20 Apr 2007 15:00:28 -0400
From: Dave Jones <davej@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: "Preston A. Elder" <prez@goth.net>, linux-kernel@vger.kernel.org
Subject: Re: AGPGart / AMD K7
Message-ID: <20070420190028.GF13939@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Greg KH <greg@kroah.com>,
	"Preston A. Elder" <prez@goth.net>, linux-kernel@vger.kernel.org
References: <46286775.5000507@goth.net> <20070420155537.GA20118@redhat.com> <4628F00B.3010304@goth.net> <20070420173337.GD20118@redhat.com> <462900BD.8020204@goth.net> <20070420182029.GF20118@redhat.com> <20070420182952.GA18930@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070420182952.GA18930@kroah.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 11:29:52AM -0700, Greg Kroah-Hartman wrote:
 > On Fri, Apr 20, 2007 at 02:20:29PM -0400, Dave Jones wrote:
 > > 
 > > btw Greg, wtf does driver_register return a 0 as 'success' if it
 > > completes the function, and 0 as 'failure' if !bus ?
 > > That seems doomed to failure.
 > 
 > I don't know why the code does that, we should always have a bus
 > assigned to a driver.  I'll change that and watch to see what breaks :)

Maybe this?

We should always have a bus in bus_add_driver()
Instead of returning success when we don't, BUG().

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 253868e..3ba8f1f 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -530,8 +530,7 @@ int bus_add_driver(struct device_driver *drv)
 	struct bus_type * bus = get_bus(drv->bus);
 	int error = 0;
 
-	if (!bus)
-		return 0;
+	BUG_ON(!bus);
 
 	pr_debug("bus %s: add driver %s\n", bus->name, drv->name);
 	error = kobject_set_name(&drv->kobj, "%s", drv->name);

-- 
http://www.codemonkey.org.uk
