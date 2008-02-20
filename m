Return-Path: <linux-kernel-owner+w=401wt.eu-S932647AbYBTRRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647AbYBTRRt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:17:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754721AbYBTRRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:17:39 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:4825 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606AbYBTRRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:17:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:mime-version:content-type;
        b=vDIiGjEl+HAsx5FmUD71QjmbpW6ZgF7iFjBQarytmBazvg/TDf6rff1n0SstQrdlJnjxkAtxT2YfmGCXWznYZVBNoBiapfahGWTtZLyjeoTwsXeaAw0nsFoPK/7ooZFzCwVAaODk5yMnW+bhc8O804A07Eo/nN8VR4CISU3EUQE=
Date: Thu, 21 Feb 2008 01:17:15 +0800 (SGT)
From: Jeff Chua <jeff.chua.linux@gmail.com>
X-X-Sender: root@boston.corp.fedex.com
To: Jesse Barnes <jesse.barnes@intel.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@linux.ie>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Greg KH <gregkh@suse.de>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk.
 Screen becomes green.
Message-ID: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Feb 20, 2008 2:19 PM, Jeff Chua
> I'll try the "idle=poll" to see if that works and will try some printk

I don't know what exactly the i915_suspend() and i915_resume() are 
supposed to do because it works better without them.

After inserting "return 0;" right at the top of those two functions, 
suspend (and power-off properly), and resume (without green screen) works 
just fine.

I would like to know what they're for.

Tested suspend-to-ram, and suspend-to-disk, both console and X on notebook 
internal LCD display, all works without these two functions.

But, anyway, got down to just one line in i915_drv.c causing the hang 
during suspend. "pci_set_power_state(dev->pdev, PCI_D3hot);".

And green screen problem during resume is caused by i915_restore_vga(dev);

So, let me where to go from here.


Thanks,
Jeff.




--- linux/drivers/char/drm/i915_drv.c.bad	2008-02-20 
11:29:14 +0800
+++ linux/drivers/char/drm/i915_drv.c	2008-02-21 00:58:37 +0800
@@ -369,7 +369,7 @@
  	if (state.event == PM_EVENT_SUSPEND) {
  		/* Shut down the device */
  		pci_disable_device(dev->pdev);
-		pci_set_power_state(dev->pdev, PCI_D3hot);
+		//pci_set_power_state(dev->pdev, PCI_D3hot);
  	}

  	return 0;
@@ -521,7 +521,7 @@
  	for (i = 0; i < 3; i++)
  		I915_WRITE(SWF30 + (i << 2), dev_priv->saveSWF2[i]);

-	i915_restore_vga(dev);
+	//i915_restore_vga(dev);

  	return 0;
  }
