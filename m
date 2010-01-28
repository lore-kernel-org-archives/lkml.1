Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171Ab0A1UMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab0A1UMH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 15:12:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590Ab0A1UMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 15:12:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39408 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088Ab0A1UMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 15:12:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/2] PM / Runtime: Clean up pm_runtime_disable()
Date: Thu, 28 Jan 2010 21:12:48 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc5-rjw; KDE/4.3.5; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1001281037120.1384-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1001281037120.1384-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001282112.48214.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 January 2010, Alan Stern wrote:
> On Thu, 28 Jan 2010, Rafael J. Wysocki wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Remove the second argument of __pm_runtime_disable(), which is not
> > necessary any more, and rename this funtion to pm_runtime_disable().
> > Accordingly, drop the static inline definition of
> > pm_runtime_disable() using __pm_runtime_disable() and export
> > pm_runtime_disable() as appropriate.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  drivers/base/power/runtime.c |   31 ++++---------------------------
> >  include/linux/pm_runtime.h   |    9 ++-------
> >  2 files changed, 6 insertions(+), 34 deletions(-)
> > 
> > Index: linux-2.6/drivers/base/power/runtime.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/base/power/runtime.c
> > +++ linux-2.6/drivers/base/power/runtime.c
> > @@ -943,20 +943,15 @@ int pm_runtime_barrier(struct device *de
> >  EXPORT_SYMBOL_GPL(pm_runtime_barrier);
> >  
> >  /**
> > - * __pm_runtime_disable - Disable run-time PM of a device.
> > + * pm_runtime_disable - Disable run-time PM of a device.
> >   * @dev: Device to handle.
> > - * @check_resume: If set, check if there's a resume request for the device.
> >   *
> >   * Increment power.disable_depth for the device and if was zero previously,
> >   * cancel all pending run-time PM requests for the device and wait for all
> >   * operations in progress to complete.  The device can be either active or
> >   * suspended after its run-time PM has been disabled.
> > - *
> > - * If @check_resume is set and there's a resume request pending when
> > - * __pm_runtime_disable() is called and power.disable_depth is zero, the
> > - * function will wake up the device before disabling its run-time PM.
> >   */
> > -void __pm_runtime_disable(struct device *dev, bool check_resume)
> > +void pm_runtime_disable(struct device *dev)
> >  {
> 
> Why did you decide to remove the check_resume argument?  That decision 
> should be explained in the patch description.

Well, I thought the "which is not necessary any more" would be a sufficient
explanation ...

Rafael
