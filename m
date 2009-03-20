Return-Path: <linux-kernel-owner+w=401wt.eu-S1762087AbZCTAQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762087AbZCTAQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 20:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761589AbZCTAQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 20:16:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39774 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761537AbZCTAQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 20:16:16 -0400
Date: Thu, 19 Mar 2009 17:11:34 -0700
From: Greg KH <gregkh@suse.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] kobject: don't block for each kobject_uevent
Message-ID: <20090320001134.GB18325@suse.de>
References: <20090319090905.609d3750@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090319090905.609d3750@infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 09:09:05AM -0700, Arjan van de Ven wrote:
> From d44701ae98a2c43a898dd7a7765d8894fd2e6caa Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Thu, 19 Mar 2009 09:02:17 -0700
> Subject: [PATCH] kobject: don't block for each kobject_uevent
> 
> Right now, the kobject_uevent code blocks for each uevent that's being generated,
> due to using (for hystoric reasons) UHM_WAIT_EXEC as flag to call_usermode_helper().
> Specifically, the effect is that each uevent that is being sent causes the code to
> wake up keventd, then block until keventd has processed the work. Needless to say,
> this happens many times during the system boot.
> 
> This patches changes that to UHN_NO_WAIT (brilliant name for a constant btw) so
> that we only schedule the work to fire the uevent message, but do not wait for
> keventd to process the work.
> 
> This removes one of the bottlenecks during boot; each one of them is only a small
> effect, but the sum of them does add up.

A faster/easier way to remove this issue is to just set the kernel
helper application to "" in the kernel config.  That's what sane distros
do :)

Not to say this patch will not help things, just overall, it doesn't do
much, as your kernel shouldn't even be taking this codepath on modern
distros.  If it is, I suggest filing a bug against that distro.

I'll queue it up.

thanks,

greg k-h
