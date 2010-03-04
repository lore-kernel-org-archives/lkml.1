Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab0CDSTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 13:19:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754140Ab0CDSS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 13:18:57 -0500
Date: Thu, 4 Mar 2010 10:18:03 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Dave Airlie <airlied@linux.ie>
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
In-Reply-To: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie>
Message-ID: <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hmm. What the hell am I supposed to do about

	(II) NOUVEAU(0): [drm] nouveau interface version: 0.0.16
	(EE) NOUVEAU(0): [drm] wrong version, expecting 0.0.15
	(EE) NOUVEAU(0): 879:

now?

What happened to the whole backwards compatibility thing? I wasn't even 
warned that this breaks existing user space. That makes it impossible to 
_test_ new kernels. Upgrading X and the kernel in lock-step is not a valid 
model, lots of people are just using some random distribution (F12 in my 
case), and you just broke it.

I see the commit that does this was very aware of it:

	commit a1606a9596e54da90ad6209071b357a4c1b0fa82
	Author: Ben Skeggs <bskeggs@redhat.com>
	Date:   Fri Feb 12 10:27:35 2010 +1000

	    drm/nouveau: new gem pushbuf interface, bump to 0.0.16

	    This commit breaks the userspace interface, and requires a new libdrm for
	    nouveau to operate again.

	    The multiple GEM_PUSHBUF ioctls that were present in 0.0.15 for
	    compatibility purposes are now gone, and replaced with the new ioctl which
	    allows for multiple push buffers to be submitted (necessary for hw index
	    buffers in the nv50 3d driver) and relocations to be applied on any buffer.

	    A number of other ioctls (CARD_INIT, GEM_PIN, GEM_UNPIN) that were needed
	    for userspace modesetting have also been removed.

	    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
	    Signed-off-by: Francisco Jerez <currojerez@riseup.net>

but why the hell wasn't I made aware of it before-hand? Quite frankly, I 
probably wouldn't have pulled it.

We can't just go around breaking peoples setups. This driver is, like it 
or not, used by Fedora-12 (and probably other distros). It may say 
"staging", but that doesn't change the fact that it's in production use by 
huge distributions. Flag days aren't acceptable.

		Linus
