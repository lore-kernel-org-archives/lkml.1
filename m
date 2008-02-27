Return-Path: <linux-kernel-owner+w=401wt.eu-S1758230AbYB0UPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230AbYB0UPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 15:15:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757409AbYB0UPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 15:15:09 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:41379 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756270AbYB0UPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 15:15:08 -0500
Date: Wed, 27 Feb 2008 15:15:07 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Fundamental flaw in system suspend, exposed by freezer
 removal
In-Reply-To: <200802272050.39769.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0802271509230.9523-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008, Rafael J. Wysocki wrote:

> > All right, we can set it to RESUME_RUNNING before calling the resume
> > method and then set it to 0 afterwards.  The point is that the value
> > shouldn't remain SUSPEND_DONE while resume runs, because it should be
> > legal for resume to register new children.
> 
> I'm not sure.  The core moves the device to dpm_active only after ->resume()
> has run.

Actually the move is done before the method is called.  So this isn't a
problem.

...
> > > > The one tricky thing to watch out for is when a suspend or resume 
> > > > method wants to unregister the device being suspended or resumed.
> > > 
> > > That can't happen, because dev->sem is taken by suspend_device() and
> > > device_del() would lock up attempting to acquire it once again.
> > 
> > We'll have to fix device_del() to prevent that from happening.  Your 
> > in_sleep_context() approach should work.
> 
> I'm not sure if we need to do it.  It's always been like this, so the current
> drivers' ->suspend() and ->resume() don't unregister the device they're called
> for.  I don't see any advantage from doing that for future drivers.

All right, if it doesn't happen now then we don't need to allow for it.  
That makes life a little simpler.

Alan Stern

