Return-Path: <linux-kernel-owner+w=401wt.eu-S1755279AbZCXXTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbZCXXTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 19:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbZCXXTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 19:19:32 -0400
Received: from vena.lwn.net ([206.168.112.25]:38229 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848AbZCXXTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 19:19:31 -0400
Date: Tue, 24 Mar 2009 17:19:27 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Greg KH <gregkh@suse.de>
Cc: stoyboyker@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/13] [staging] changed ioctls to unlocked
Message-ID: <20090324171927.724da2f5@bike.lwn.net>
In-Reply-To: <20090324220136.GA12128@suse.de>
References: <1237929168-15341-2-git-send-email-stoyboyker@gmail.com>
	<20090324220136.GA12128@suse.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Mar 2009 15:01:36 -0700
Greg KH <gregkh@suse.de> wrote:

> Hm, why?  What does this patch accomplish becides just pushing the
> lock_kernel into the driver?  Shouldn't you fix the code to not need
> the lock_kernel at all instead?

Having done a lot of this myself, I can attest to what is going on
here.  If you're trying to push the BKL out of the core, there's not
much choice except to shove it down into the drivers and such below
it.  In very simple cases you can tell that the lock isn't needed.  
But going messing around with the locking in random drivers is a sure
way to create nasty subtle problems.

So, if a specific driver's situation is not obvious, or if it's clear
that some sort of fix is required, it's generally best to just make the
lock_kernel() (which has always been there) explicit.  Then people who
actually know the driver and have the hardware to test changes can
eliminate it at their leisure.  Pushing the BKL down gets it out of the
core, keeps the semantics the same, and sticks a red flag on code which
needs examination by suitably clueful maintainers.

I've not looked in depth at this series of patches, but I understand
where it's coming from.  Stoyan, if you want, I'd be happy to take
these through the BKL-removal tree once the maintainers are happy with
it.  OTOH, it looks like the locked ioctl() isn't going anywhere
anytime soon, so it might be best to just send these individually
through the appropriate subsystem trees.

jon
