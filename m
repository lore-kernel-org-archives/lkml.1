Return-Path: <linux-kernel-owner+w=401wt.eu-S1757729AbZCYKXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729AbZCYKXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 06:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753911AbZCYKX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 06:23:28 -0400
Received: from mail.gmx.net ([213.165.64.20]:38193 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753686AbZCYKX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 06:23:28 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18Dd5RoqwkDKw7VK0VjS5dPU+l1X+Z2bW9oC35YBA
	tyOviR0SXDbMnx
Date: Wed, 25 Mar 2009 11:23:30 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Ming Lei <tom.leiming@gmail.com>
cc: kay.sievers@vrfy.org, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com
Subject: Re: [PATCH] driver core: check bus->match without holding device
 lock
In-Reply-To: <d82e647a0903250313ka2d270ag78335e7c7f525f22@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0903251117220.5795@axis700.grange>
References: <1232458448-4412-1-git-send-email-tom.leiming@gmail.com> 
 <Pine.LNX.4.64.0903250039160.4451@axis700.grange> 
 <d82e647a0903241815l66abfc18ldbb26abd7d2c6b4@mail.gmail.com> 
 <Pine.LNX.4.64.0903250817090.5590@axis700.grange>
 <d82e647a0903250313ka2d270ag78335e7c7f525f22@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Mar 2009, Ming Lei wrote:

> >> > Now, without .match() no probing is done. Is this an intended change and
> >> > soc-camera has to be fixed or is this a bug?
> >>
> >> It is not a driver-core bug, and soc-camera should be fixed.
> >
> > So, you're saying this used to be a bug and it has been fixed by this
> > patch? Then why isn't this mentioned in the commit message? The commit
> > text seems to suggest, that this patch shouldn't introduce any change in
> > behaviour, but it does. So, before .match == NULL lead to .probe() being
> > called, and now it doesn't anymore?
> 
> Where is soc-camera  driver in kernel tree?

drivers/media/video/soc_camera.c

> Which bus  is soc-camera device (driver) attached to ?

camera bus.

> Why doesn't soc-camera  driver  have a match method?

Why should it? Because there is only one driver on this bus by definition 
(and I only register a device on the bus when I find a match between a 
device and its parent / driver).

What I in any case see wrong with this patch, is that it _silently_ 
changes kernel behaviour without even mentioning it in the commit log!

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
