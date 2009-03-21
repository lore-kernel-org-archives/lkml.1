Return-Path: <linux-kernel-owner+w=401wt.eu-S1756786AbZCUNBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbZCUNBe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 09:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbZCUNBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 09:01:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42672 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752454AbZCUNBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 09:01:24 -0400
Date: Sat, 21 Mar 2009 05:55:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nitin Gupta <nitingupta910@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] compcache documentation
Message-Id: <20090321055532.db1045c0.akpm@linux-foundation.org>
In-Reply-To: <49C4DE2C.8010808@vflare.org>
References: <49C3A31D.6070208@vflare.org>
	<49C3A4B0.3050503@vflare.org>
	<20090321032636.fdeae224.akpm@linux-foundation.org>
	<49C4DE2C.8010808@vflare.org>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Mar 2009 18:01:40 +0530 Nitin Gupta <nitingupta910@gmail.com> wrote:

> Andrew Morton wrote:
> > On Fri, 20 Mar 2009 19:44:08 +0530 Nitin Gupta <ngupta@vflare.org> wrote:
> > 
> >> ...
> >>
> >> +   backing_dev: This is block device to be used as backing store for compcache.
> >> +	It must be a valid swap partition. We move data to this device when we
> >> +	encounter incompressible page or memlimit is reached. TODO: we may also
> >> +	move some pages from compcache to this device in case system is really
> >> +	low on memory.
> >> +	This device is not directly visible to kernel as a swap device
> >> +	(/proc/swaps will only show /dev/ramzswap0 and not this device).
> >> +	Managing this backing device is the job of compcache module.
> > 
> > hrm, OK, it kinda/sorta/maybe might be a little bit like a "compressed
> > cache".  But if someone comes up with a real compressed cache (ie:
> > pagecache) then they'll want their name back.
> > 
> Rename is in progress: compcache->ramzswap :)
> 
> > Also, the kernel already has a widespread and well-established "backing
> > device" concept, in include/linux/backing-dev.h.  This new feature's
> > poaching of that identifier is a bit confusing.  It would be nice to do a
> > wholesale rename if possible.  secondary_dev?  nv_dev?
> > 
> 
> backing_swap?

Well that gets us back to my other question.  It's a block device driver,
yes?  It is in fact not tied to swap in any way, apart from swap being the
expected application?
