Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053AbZKBQro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbZKBQro (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755908AbZKBQrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:47:43 -0500
Received: from trinity.fluff.org ([89.16.178.74]:44095 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755925AbZKBQrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:47:43 -0500
Date: Mon, 2 Nov 2009 16:47:44 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Ben Dooks <ben-linux@fluff.org>, Antonio Ospite <ospite@studenti.unina.it>,
       openezx-devel@lists.openezx.org, Samuel Ortiz <sameo@linux.intel.com>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Mike Rapoport <mike@compulab.co.il>, Daniel Ribeiro <drwyrm@gmail.com>
Subject: Re: Using statically allocated memory for platform_data.
Message-ID: <20091102164743.GE23772@trinity.fluff.org>
References: <20091102112316.16163f6a.ospite@studenti.unina.it> <20091102150011.GB20341@fluff.org.uk> <20091102150525.GB5785@n2100.arm.linux.org.uk> <20091102152500.GD23772@trinity.fluff.org> <20091102155231.GC20341@fluff.org.uk> <20091102155625.GC5785@n2100.arm.linux.org.uk> <20091102162839.GD20341@fluff.org.uk> <20091102163701.GD5785@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091102163701.GD5785@n2100.arm.linux.org.uk>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 04:37:01PM +0000, Russell King - ARM Linux wrote:
> On Mon, Nov 02, 2009 at 04:28:39PM +0000, Ben Dooks wrote:
> > On Mon, Nov 02, 2009 at 03:56:25PM +0000, Russell King - ARM Linux wrote:
> > > The reason we have platform_device_add_data() is that people think that
> > > the device data needs to persist for the lifetime of the device.  I
> > > personally disagree with that - once you unregister the device, it's
> > > guaranteed that device drivers will have been unregistered, so who's
> > > going to use the platform data?
> > 
> > That doesn't make any sense, in the current case of using the
> > platform_device_alloc() and those calls the data is only living
> > for the lifetime of the device, as the release call is tidying up
> > the result.
> 
> What I'm saying is that the lifetime of the data finishes once
> the _unregister() call has returned.  So:
> 
> 	data = pdev->dev.platform_data;
> 	platform_device_unregister(pdev);
> 	kfree(data);
> 
> is an entirely valid way of handling the "I allocated my platform
> data" problem - it doesn't need to exist to the point where the
> device itself is freed.

Unforutnately pretty much everyone now assumes that the act of
unregistering the device will get rid of the data that the allocated
by the add functions.

This would mean going around fixing a number of current drivers which
all make that assumption.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

