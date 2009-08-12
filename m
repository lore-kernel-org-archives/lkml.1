Return-Path: <linux-kernel-owner+w=401wt.eu-S1754910AbZHLUeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbZHLUeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 16:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754873AbZHLUeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 16:34:37 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:32771 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754084AbZHLUeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 16:34:36 -0400
Date: Wed, 12 Aug 2009 16:34:37 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Zhang Rui <rui.zhang@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>,
       "dtor@mail.ru" <dtor@mail.ru>
Subject: Re: [PATCH V2 0/4] introduce device async actions mechanism
In-Reply-To: <200908122210.35591.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0908121633220.23954-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Aug 2009, Rafael J. Wysocki wrote:

> > The one thing I'm not sure of is the pm_runtime_put_noidle calls in 
> > driver_probe_device and __device_release_driver.  It seems that we 
> > should always call pm_runtime_put regardless of whether the probe 
> > succeeds or not.
> 
> Did you mean pm_runtime_put_sync()?

Yes.  I haven't used the new code yet so the names don't stick in my 
mind.

> > For example, the USB stack is set up to suspend devices that don't have
> > a driver (this is handled at the bus subsystem level).  But if probing
> > failed, there wouldn't be any idle callback and so the suspend wouldn't
> > take place.
> 
> OK, I'll make this change.

Thanks.  Now I just have to figure out the best way to convert USB over 
to the new framework...

Alan Stern

