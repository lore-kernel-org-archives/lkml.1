Return-Path: <linux-kernel-owner+w=401wt.eu-S1754511AbZHLUKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbZHLUKK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 16:10:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753747AbZHLUKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 16:10:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59701 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbZHLUKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 16:10:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH V2 0/4] introduce device async actions mechanism
Date: Wed, 12 Aug 2009 22:10:35 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: Zhang Rui <rui.zhang@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-acpi" <linux-acpi@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>,
       "dtor@mail.ru" <dtor@mail.ru>
References: <Pine.LNX.4.44L0.0908120958200.2955-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0908120958200.2955-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908122210.35591.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 August 2009, Alan Stern wrote:
> On Wed, 12 Aug 2009, Rafael J. Wysocki wrote:
> 
> > That looks quite complicated at first sight, but asynchronous resume with
> > completions can be done in a relatively simple patch.  I've got one, so
> > tomorow I'll post it for further discussion.
> 
> Okay.  I would think that managing the threads would account for most 
> of the complexity in either implementation, but I'll wait to see how 
> your approach works out.
> 
> > Thanks,
> > Rafael
> > 
> > 
> > PS
> > Did you have a chance to look at rev. 15 of the runtime PM patch
> > (http://patchwork.kernel.org/patch/40306/)?
> 
> Yes, sorry for not getting back to you.  It looks okay.
> 
> The one thing I'm not sure of is the pm_runtime_put_noidle calls in 
> driver_probe_device and __device_release_driver.  It seems that we 
> should always call pm_runtime_put regardless of whether the probe 
> succeeds or not.

Did you mean pm_runtime_put_sync()?

> For example, the USB stack is set up to suspend devices that don't have
> a driver (this is handled at the bus subsystem level).  But if probing
> failed, there wouldn't be any idle callback and so the suspend wouldn't
> take place.

OK, I'll make this change.

Thanks,
Rafael
