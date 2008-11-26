Return-Path: <linux-kernel-owner+w=401wt.eu-S1753650AbYKZNUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650AbYKZNUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 08:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752529AbYKZNUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 08:20:15 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48896 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413AbYKZNUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 08:20:14 -0500
Date: Wed, 26 Nov 2008 15:20:06 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Host<->guest channel interface advice needed
Message-ID: <20081126132006.GD3521@redhat.com>
References: <20081126123919.GC3521@redhat.com> <20081126130701.GB8921@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126130701.GB8921@ioremap.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 04:07:01PM +0300, Evgeniy Polyakov wrote:
> On Wed, Nov 26, 2008 at 02:39:19PM +0200, Gleb Natapov (gleb@redhat.com) wrote:
> > The interfaces that are being considered are netlink socket (only datagram
> > semantics, linux specific), new socket family or character device with
> > different minor number for each channel. Which one better suits for
> > the purpose?  Is there other kind of interface to consider? New socket
> > family looks like a good choice, but it would be nice to hear other
> > opinions before starting to work on it.
> 
> What about X (or whatever else) protocol running over host-guest network
> device, which are in the kernel already?
> 
I should have mentioned that in my original mail. We don't want to
use IP stack for communication between host and guest for variety of
reasons. User of the VM may interfere with our communication by mis
configuring firewall for instance (and he/she may even not be aware
that an OS running inside a VM). We also want be able to communicate
with agent inside a guest even when guest's network is not yet configured.

--
			Gleb.
