Return-Path: <linux-kernel-owner+w=401wt.eu-S1752419AbZGAHJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbZGAHJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 03:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750969AbZGAHJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 03:09:08 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:40296 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbZGAHJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 03:09:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=P17ShVh2TzpeZs0m1hbqmrf7e3J/spe1cLsh+XTIW4triac/YkoxXMsoByWSIdhiSu
         YokZckOZZABzbPuV8gntBdYHDGOKH/5eWc5BD+E3+olIVWxU1Q/YtubNxO7Vvdk1QYlu
         WYX9ODJEzAmDu7beT/SNWtypaqjdk1mGRzhT8=
From: Alberto Gonzalez <alberto6674@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Kernel 2.6.30 and udevd problem
Date: Wed, 1 Jul 2009 09:09:03 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.29-ARCH; KDE/4.2.4; x86_64; ; )
Cc: Dave Airlie <airlied@linux.ie>, Alberto Gonzalez <alberto6674@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       linux-hotplug@vger.kernel.org
References: <200906280821.58631.info@gnebu.es> <alpine.DEB.2.00.0906300445550.4758@skynet.skynet.ie> <20090630090835.5536a465@jbarnes-g45>
In-Reply-To: <20090630090835.5536a465@jbarnes-g45>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907010909.03645.info@gnebu.es>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 June 2009 18:08:35 Jesse Barnes wrote:
> On Tue, 30 Jun 2009 04:46:38 +0100 (IST)
>
> Dave Airlie <airlied@linux.ie> wrote:
> > > On Sunday 28 June 2009 16:28:44 Kay Sievers wrote:
> > > > If there isn't something else running which acts on uevents that
> > > > trigger drm events, which I wouldn't expect, it seems like a drm
> > > > kernel problem.
> > >
> > > Ok, thanks for looking at it. I'll sum up the problem for DRM
> > > people:
> > >
> > > The problem started after upgrading to 2.6.30. At some point, udevd
> > > starts to use a lot of CPU time. It happens randomly, but it seems
> > > easier to trigger when running something graphics intensive
> > > (glxgears, gtkperf, tuxracer..).
> > >
> > > Killing udevd and starting it with the --debug switch throws up
> > > this when the problem starts:
> >
> > I've added jbarnes to the list,
> >
> > Jesses are we sending events yet? what for?
>
> Right now we just send uevents at hotplug time, so maybe one of our
> hotplug interrupt bits is getting stuck, resulting in a continuous
> stream of events as we generate other interrupts (which would happen
> when running 3D apps for example).
>
> There's a DRM_DEBUG statement in drivers/gpu/drm/i915/i915_irq.c under
> the if (I915_HAS_HOTPLUG(dev)) { check, if you make it into DRM_ERROR
> we can see which one is getting stuck.

I am afraid I'll need a bit more guidance here. I guess this means patching 
the kernel. Would it be possible to get a test patch against 2.6.30? And then 
after patching and compiling, how should I debug it?

Thanks,
Alberto.
