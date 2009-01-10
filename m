Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbZAJJ5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbZAJJ5n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 04:57:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbZAJJ5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 04:57:35 -0500
Received: from mga09.intel.com ([134.134.136.24]:60668 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668AbZAJJ5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 04:57:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,243,1231142400"; 
   d="scan'208";a="480537494"
Subject: Re: [git pull] drm
From: Richard Purdie <rpurdie@linux.intel.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <21d7e9970901091804x61e2ba3cofd37d536df2d48b3@mail.gmail.com>
References: <alpine.DEB.2.00.0812290819020.20427@skynet.skynet.ie>
	 <1231513655.5317.30.camel@dax.rpnet.com>
	 <1231524232.5317.43.camel@dax.rpnet.com>
	 <1231550011.5317.72.camel@dax.rpnet.com>
	 <21d7e9970901091804x61e2ba3cofd37d536df2d48b3@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 10 Jan 2009 09:58:11 +0000
Message-Id: <1231581491.5330.8.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2009-01-10 at 12:04 +1000, Dave Airlie wrote:
> On Sat, Jan 10, 2009 at 11:13 AM, Richard Purdie
> <rpurdie@linux.intel.com> wrote:
> > On Fri, 2009-01-09 at 18:03 +0000, Richard Purdie wrote:
> >> On Fri, 2009-01-09 at 15:07 +0000, Richard Purdie wrote:
> >> > I just updated to the latest kernel from git to test some other patches
> >> > and after logging into GDM the X server hangs before launching the
> >> > desktop (it appears to be trying to run glxinfo) on my Thinkpad T61
> >> > (i915 graphics). Bisection shows this happens after applying this
> >> > commit:
> >> >
> >> > On Mon, 2008-12-29 at 08:32 +0000, Dave Airlie wrote:
> >> > > commit 7c1c2871a6a3a114853ec6836e9035ac1c0c7f7a
> >> > > Author: Dave Airlie <airlied@redhat.com>
> >> > > Date:   Fri Nov 28 14:22:24 2008 +1000
> >
> > The patch below gets my system working again with the latest kernels.
> > Was dropping the drm_addmap() call for i915 intentional or not?
> 
> Yes, so now we need to find out what happens in your userspace, when
> it hangs is the machine dead?
> 
> or can you ssh in? any oops in the logs? can you get a sysrq-t
> backtrace for X.org and glxinfo?

The machine's keyboard and console switching is dead and the login in
process drops the wifi but I think I can get in through ssh over
ethernet. The power button does make it shutdown cleanly and there is no
oops. I'll try and get backtraces later, probably tonight.

I have a question though, where in the i915 driver is
master_priv->sarea_priv assigned a value? or master_priv->sarea for that
matter? As far as I can tell those pointers are never assigned values?
Is there a drm_getsarea() call missing? 

Perhaps my patch fixes things since sarea and sarea_priv are given a
value?

Cheers,

Richard


