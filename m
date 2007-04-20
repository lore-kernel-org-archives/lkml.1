Return-Path: <linux-kernel-owner+w=401wt.eu-S1751793AbXDTX3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793AbXDTX3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 19:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbXDTX3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 19:29:41 -0400
Received: from canuck.infradead.org ([209.217.80.40]:35011 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbXDTX3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 19:29:40 -0400
Date: Fri, 20 Apr 2007 16:26:51 -0700
From: Greg KH <greg@kroah.com>
To: Dave Jones <davej@redhat.com>, "Preston A. Elder" <prez@goth.net>,
       linux-kernel@vger.kernel.org
Subject: Re: AGPGart / AMD K7
Message-ID: <20070420232651.GB10949@kroah.com>
References: <46286775.5000507@goth.net> <20070420155537.GA20118@redhat.com> <4628F00B.3010304@goth.net> <20070420173337.GD20118@redhat.com> <462900BD.8020204@goth.net> <20070420182029.GF20118@redhat.com> <20070420182952.GA18930@kroah.com> <20070420190028.GF13939@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070420190028.GF13939@redhat.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 03:00:28PM -0400, Dave Jones wrote:
> On Fri, Apr 20, 2007 at 11:29:52AM -0700, Greg Kroah-Hartman wrote:
>  > On Fri, Apr 20, 2007 at 02:20:29PM -0400, Dave Jones wrote:
>  > > 
>  > > btw Greg, wtf does driver_register return a 0 as 'success' if it
>  > > completes the function, and 0 as 'failure' if !bus ?
>  > > That seems doomed to failure.
>  > 
>  > I don't know why the code does that, we should always have a bus
>  > assigned to a driver.  I'll change that and watch to see what breaks :)
> 
> Maybe this?
> 
> We should always have a bus in bus_add_driver()
> Instead of returning success when we don't, BUG().

Nah, I don't like adding BUG() calls to the kernel if it can be helped,
how about the version I copied you on a few hours ago, which is also
below?

thanks,

greg k-h

------
From: Greg Kroah-Hartman <gregkh@suse.de>
Subject: driver core: bus_add_driver should return an error if no bus

As pointed out by Dave Jones.

Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/bus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -601,7 +601,7 @@ int bus_add_driver(struct device_driver 
 	int error = 0;
 
 	if (!bus)
-		return 0;
+		return -EINVAL;
 
 	pr_debug("bus %s: add driver %s\n", bus->name, drv->name);
 	error = kobject_set_name(&drv->kobj, "%s", drv->name);
