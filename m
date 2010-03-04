Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab0CDSnq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 13:43:46 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38170 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753835Ab0CDSnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 13:43:45 -0500
Date: Thu, 4 Mar 2010 10:43:30 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Dave Airlie <airlied@linux.ie>
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
In-Reply-To: <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1003041035380.3751@localhost.localdomain>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie> <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Mar 2010, Linus Torvalds wrote:
> 
> I see the commit that does this was very aware of it:
> 
> 	commit a1606a9596e54da90ad6209071b357a4c1b0fa82
> 	Author: Ben Skeggs <bskeggs@redhat.com>
> 	Date:   Fri Feb 12 10:27:35 2010 +1000
> 
> 	    drm/nouveau: new gem pushbuf interface, bump to 0.0.16
> 
> 	    This commit breaks the userspace interface, and requires a new libdrm for
> 	    nouveau to operate again.

Quite frankly, the more I look at that commit, the worse it looks.

That commit seems to _on_purpose_ try to avoid at all cost being 
compatible. It not only removes some old entry-points, it literally 
re-numbers all the ioctl numbers as it does so, apparently entirely in 
order to just make it difficult to have some libdrm that can handle both 
versions.

This all means that I literally cannot test the current -git tree. 

I suspect I have to revert it. 

Or is there a version of X that can handle _both_ the 0.0.15 and the 
0.0.16 interfaces?

That's absolutely required - so that it's not a flag-day any more to 
upgrade the kernel, and so that people (including very much me) can test 
and bisect other things without having to worry about basic functionality 
coming and going as you bisect things,

			Linus
