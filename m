Return-Path: <linux-kernel-owner+w=401wt.eu-S932481AbXCSUa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481AbXCSUa7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 16:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932501AbXCSUa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 16:30:59 -0400
Received: from sccrmhc12.comcast.net ([204.127.200.82]:48440 "EHLO
	sccrmhc12.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932481AbXCSUa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 16:30:58 -0400
X-Greylist: delayed 603 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Mar 2007 16:30:58 EDT
Subject: Re: BSOD
From: Jim Gettys <jg@laptop.org>
Reply-To: jg@laptop.org
To: David Miller <davem@davemloft.net>
Cc: jesse.barnes@intel.com, zaitcev@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20070319.130544.115907938.davem@davemloft.net>
References: <20070319120807.af36ef5d.zaitcev@redhat.com>
	 <20070319.123836.39155546.davem@davemloft.net>
	 <200703191254.36373.jesse.barnes@intel.com>
	 <20070319.130544.115907938.davem@davemloft.net>
Content-Type: text/plain
Organization: OLPC
Date: Mon, 19 Mar 2007 16:20:50 -0400
Message-Id: <1174335650.6832.156.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I agree with David and Jessie.

All the kernel needs to know for oopses is frame buffer depth, start,
stride, and how to get the GPU to "stop" (or it may very well overwrite
the screen).  Trying to get back to a default mode setting first in the
middle of oopsing is very unlikely to succeed.

The time you want mode switching (or lack othereof) is at suspend/resume
time, not at oopses.

This presumes the frame buffer is accessible in the address space of the
kernel.  There have been display devices where this is not true; but not
many.
                               - Jim




On Mon, 2007-03-19 at 13:05 -0700, David Miller wrote:
> From: Jesse Barnes <jesse.barnes@intel.com>
> Date: Mon, 19 Mar 2007 12:54:36 -0700
> 
> > Kernel based modesetting should get us a lot of things:
> 
> But for panics you're ignoring what Peter and I are saying.
> 
> Mode setting is complex and it is not going to work exactly when you
> need the kernel crash message the most.
> 
> After debugging the kernel for 10+ years I can tell you one thing, for
> a bad crash what's going to happen is you'll get the printk but that's
> about all that will work at that point, and the kernel is going to
> hang next.  Sometimes you won't get the whole panic message, just
> the beginning, even with the most simplistic printk implementation.
> 
> You will not, I repeat, will not be able to mode switch or anything
> non-trivial like that when the kernel is in this state.
> 
> Mode switching on panic, just say no. :-)
> 
-- 
Jim Gettys
One Laptop Per Child


