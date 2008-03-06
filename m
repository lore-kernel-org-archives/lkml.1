Return-Path: <linux-kernel-owner+w=401wt.eu-S934852AbYCFQ1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934852AbYCFQ1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 11:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761554AbYCFQ1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 11:27:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37086 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754200AbYCFQ1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 11:27:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH] PM: Make PM core handle device registrations concurrent with suspend/hibernation
Date: Thu, 6 Mar 2008 17:26:02 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0803061022150.4061-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0803061022150.4061-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803061726.03277.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 6 of March 2008, Alan Stern wrote:
> On Thu, 6 Mar 2008, Rafael J. Wysocki wrote:
> 
> > > > Revised patch below.
> > > 
> > > It looks good.  Let's hope it doesn't mess up ACPI too badly...  :-)
> > > 
> > > Acked-by: Alan Stern <stern@rowland.harvard.edu>
> > 
> > Thanks!
> 
> I thought of one more thing you might want to add: device_pm_add() 
> doesn't handle the case where dev->parent is NULL.

I'm not sure what you mean.

If dev->parent is NULL, we get into the "successful" branch where the device is
added to dpm_active.  Do you think we should add any extra handling of this
case?

> You could put in that static "all_devices_sleeping" flag, which gets set at
> the end of dpm_suspend() and cleared at the start of dpm_resume().

Well, I don't think it's necessary.  dpm_active is empty in that case and
we can use the list_empty(&dpm_active) check instead.

Thanks,
Rafael
