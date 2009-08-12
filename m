Return-Path: <linux-kernel-owner+w=401wt.eu-S1751153AbZHLVRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751153AbZHLVRV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 17:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbZHLVRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 17:17:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60005 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844AbZHLVRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 17:17:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH V2 0/4] introduce device async actions mechanism
Date: Wed, 12 Aug 2009 23:18:12 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: Zhang Rui <rui.zhang@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-acpi" <linux-acpi@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>,
       "dtor@mail.ru" <dtor@mail.ru>
References: <Pine.LNX.4.44L0.0908121633220.23954-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0908121633220.23954-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908122318.12145.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 August 2009, Alan Stern wrote:
> On Wed, 12 Aug 2009, Rafael J. Wysocki wrote:
> 
> > > The one thing I'm not sure of is the pm_runtime_put_noidle calls in 
> > > driver_probe_device and __device_release_driver.  It seems that we 
> > > should always call pm_runtime_put regardless of whether the probe 
> > > succeeds or not.
> > 
> > Did you mean pm_runtime_put_sync()?
> 
> Yes.  I haven't used the new code yet so the names don't stick in my 
> mind.
> 
> > > For example, the USB stack is set up to suspend devices that don't have
> > > a driver (this is handled at the bus subsystem level).  But if probing
> > > failed, there wouldn't be any idle callback and so the suspend wouldn't
> > > take place.
> > 
> > OK, I'll make this change.
> 
> Thanks.  Now I just have to figure out the best way to convert USB over 
> to the new framework...

:-)

On a second thought, though, would it be a good idea to add
pm_runtime_get_noresume() / pm_runtime_put_sync() around the bus_for_each_drv()
in device_attach()?  That would prevent us from resuming-suspending the device
on each failing probe.

Rafael
