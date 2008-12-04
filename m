Return-Path: <linux-kernel-owner+w=401wt.eu-S1755485AbYLDUEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbYLDUEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 15:04:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751039AbYLDUDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 15:03:51 -0500
Received: from mail.gmx.net ([213.165.64.20]:60301 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750924AbYLDUDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 15:03:51 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX186Do1WtLg6XtW4wD9FPaCU7MQV34c/KT7AT784/O
	WN+UD53Gp8iJ0I
Date: Thu, 4 Dec 2008 21:03:59 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Dan Williams <dan.j.williams@intel.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] dmaengine redux continued
In-Reply-To: <e9c3a7c20812041052l7fa7c148jf0a40318a2fe8cf4@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0812042101150.8851@axis700.grange>
References: <20081204004514.27790.51174.stgit@dwillia2-linux.ch.intel.com> 
 <Pine.LNX.4.64.0812040937010.5079@axis700.grange>
 <e9c3a7c20812041052l7fa7c148jf0a40318a2fe8cf4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Dec 2008, Dan Williams wrote:

> On Thu, Dec 4, 2008 at 1:51 AM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > What about the last hunk from the patch at
> >
> > http://marc.info/?l=linux-arm-kernel&m=122607472721145&w=2
> >
> > ? Can we add this tx_free pointer? Would you like me to submit it as a
> > separate patch? I'd like to be able to reuse tx-descriptors in clients, so
> > I then have to explicitly release them in the dmaengine device
> > (controller) driver.
> >
> 
> I took a look but the description does not explain why the driver
> needs an explicit release.  In what cases is the implied release, when
> the descriptor is acked && done, insufficient?

v4l. I think, the proper moment to free tx-descriptors is at VIDIOC_DQBUF 
time. I.e., there is an explicit ioctl from user-space: "free buffers 
now". That's when I want to call .tx_free().

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
