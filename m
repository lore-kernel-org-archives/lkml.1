Return-Path: <linux-kernel-owner+w=401wt.eu-S1757809AbYGIVFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757809AbYGIVFB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 17:05:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbYGIVEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 17:04:50 -0400
Received: from trinity.fluff.org ([89.145.97.151]:53971 "EHLO
	trinity.fluff.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757062AbYGIVEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 17:04:50 -0400
Date: Wed, 9 Jul 2008 22:04:44 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Ben Dooks <ben-linux@fluff.org>, dbaryshkov@gmail.com,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [patch 4/4] MFD: Change mfd platform device usage to wrapper platform_device
Message-ID: <20080709210444.GN8517@trinity.fluff.org>
References: <20080709104916.200210922@fluff.org> <20080709104933.101610936@fluff.org> <20080709205625.GE26734@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709205625.GE26734@flint.arm.linux.org.uk>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.9i
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, Jul 09, 2008 at 09:56:25PM +0100, Russell King - ARM Linux wrote:
> On Wed, Jul 09, 2008 at 11:49:20AM +0100, Ben Dooks wrote:
> > This patch changes the mfd core behaviour to wrapper the platform_device
> > it creates in an struct mfd_device which contains the information
> > about the cell that was created.
> 
> You can't do this.  Grab a reference to the platform device (by holding
> one of its sysfs files open) and then remove all the users of the mfd-core
> module and the mfd-core module itself.
> 
> Then, read from that file and close it.  Watch your kernel oops.
> 
> That's why device release methods inside modules are a BAD IDEA and why
> we have the platform device alloc API.

Would this be fixed by grabbing a reference to the mfd-core module whilst
the mfd device is open?

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

