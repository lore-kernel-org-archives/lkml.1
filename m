Return-Path: <linux-kernel-owner+w=401wt.eu-S1753219AbXFWGXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbXFWGXm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 02:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbXFWGXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 02:23:34 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:2679 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbXFWGXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 02:23:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=edq4d11Xa563AZ34SkPuRvhrMN/uG9CrmeCe3ojKTGZOUWIj27b6Jck9CCrKkGkHi0MRktceXW6khHfGS1QjKFsTv7m2ZIzG16AwQZAhRUenqfTv6SeQXD3kd63ijdwbFA/ubsncm8VSl/1G++m2osgEzWYASZkhiBMfB4y7fRc=
Message-ID: <21d7e9970706222323g69d64b2dtfcd337b2494ca3e9@mail.gmail.com>
Date: Sat, 23 Jun 2007 16:23:32 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Christoph Hellwig" <hch@infradead.org>,
       "john stultz" <johnstul@us.ibm.com>, "Oleg Nesterov" <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Dipankar Sarma" <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
In-Reply-To: <20070622215953.GA22917@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070622040014.234651401@goodmis.org>
	 <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org>
	 <20070622204058.GA11777@elte.hu>
	 <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org>
	 <20070622215953.GA22917@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Most of the tasklet uses are in rarely used or arcane drivers - in fact
> none of my 10 test-boxes utilizes _any_ tasklet in any way that could
> even get close to mattering to performance. In other words: i just
> cannot test this, nor do i think that others will really test this. I.e.
> if we dont approach this problem in some other way, nothing will happen
> and Steve's patch will be stalled forever and will live in -rt forever.
> (which might be a correct end result too, but i'm just not giving up
> this easily :-)

I've no idea but the drm uses tasklets to schedule the page flip or
front/back blit as close to the vblank interrupt as possible to avoid
tearing on vblank sync'ed applications (and compositing managers).

I'm not sure we have any way to quantify this other than the closer to
the irq the flip happens the better chance of the screen not tearing..
going forward where compositing is more used on a loaded system I
wonder will we see more tearing on loaded systems..

I await the cleanups for the DRM code, it came from TG to support the
above feature on Intel hw.

Dave.
