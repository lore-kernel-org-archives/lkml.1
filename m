Return-Path: <linux-kernel-owner+w=401wt.eu-S1756852AbZJMLEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852AbZJMLEy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 07:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751115AbZJMLEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 07:04:53 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39418 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbZJMLEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 07:04:52 -0400
Date: Tue, 13 Oct 2009 13:04:08 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org
Subject: Re: 32-rc2: runtime_pm is noisy
Message-ID: <20091013110407.GC31984@elf.ucw.cz>
References: <20091006080241.GB1362@ucw.cz>
 <200910062342.20910.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910062342.20910.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-10-06 23:42:20, Rafael J. Wysocki wrote:
> On Tuesday 06 October 2009, Pavel Machek wrote:
> > Hi!
> > 
> > Maybe it is my config,
> 
> Yes it is.
> 
> > but pm_runtime_idle is a bit too noisy on
> > zaurus... ok, I do have pm_debug & pm_verbose
> 
> Exactly.
> 
> > set... but still, is it useful to print message about devices that do not
> > support it?
> 
> It may be useful, because, for example, PCI can put devices without drivers
> into low power states using this mechanism.
> 
> Still, perhaps we can drop the debug messages from __pm_runtime_idle().
> 
> Care to send a patch?

Yep, something like this?

---

pm_runtime_idle is somewhat noisy. Remove debug prints.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -51,8 +51,6 @@ static int __pm_runtime_idle(struct device *dev)
 {
 	int retval = 0;
 
-	dev_dbg(dev, "__pm_runtime_idle()!\n");
-
 	if (dev->power.runtime_error)
 		retval = -EINVAL;
 	else if (dev->power.idle_notification)
@@ -93,8 +91,6 @@ static int __pm_runtime_idle(struct device *dev)
 	wake_up_all(&dev->power.wait_queue);
 
  out:
-	dev_dbg(dev, "__pm_runtime_idle() returns %d!\n", retval);
-
 	return retval;
 }
 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
