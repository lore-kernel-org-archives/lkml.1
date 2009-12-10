Return-Path: <linux-kernel-owner+w=401wt.eu-S1761367AbZLJVBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761367AbZLJVBM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 16:01:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759477AbZLJVBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 16:01:11 -0500
Received: from www.tglx.de ([62.245.132.106]:44390 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758313AbZLJVBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 16:01:10 -0500
Date: Thu, 10 Dec 2009 22:01:10 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Greg KH <gregkh@suse.de>
cc: LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [patch] drivers: Fix bogus 0 error return in device_add()
In-Reply-To: <20091210205623.GA29097@suse.de>
Message-ID: <alpine.LFD.2.00.0912102158590.3089@localhost.localdomain>
References: <20091210193057.799393067@linutronix.de> <20091210205623.GA29097@suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Dec 2009, Greg KH wrote:
> On Thu, Dec 10, 2009 at 07:32:49PM -0000, Thomas Gleixner wrote:
> > If device_add() is called with a device which does not have dev->p set
> > up, then device_private_init() is called. If that succeeds, then the
> > error variable is set to 0. Now if the dev_name(dev) check further
> > down fails, then device_add() correctly terminates, but returns 0.
> > That of course lets the driver progress. If later another driver uses
> > this half set up device as parent then device_add() of the child
> > device explodes and renders sysfs completely unusable.
> > 
> > Set the error to -EINVAL if dev_name() check fails.
> 
> That's a good catch, thanks.
> 
> Is anything currently triggering this?  Or did you just find it by
> reading the code?

Hans-Juergen had a buggy vendor driver where init_name was not
initialized. So the driver probing succeeded and after that a
depending driver crashed somewhere in device_add().

Thanks,

	tglx
