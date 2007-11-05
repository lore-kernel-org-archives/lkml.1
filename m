Return-Path: <linux-kernel-owner+w=401wt.eu-S1756110AbXKEG3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbXKEG3h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 01:29:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbXKEG33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 01:29:29 -0500
Received: from gir.skynet.ie ([193.1.99.77]:42178 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbXKEG32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 01:29:28 -0500
Date: Mon, 5 Nov 2007 06:29:26 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: linux-kernel@vger.kernel.org
cc: dri-devel@lists.sourceforge.net
Subject: [PATCH series] DRM memory manager core
Message-ID: <Pine.LNX.4.64.0711050612110.8487@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

These patches are the first set of patches containing the core components 
of the DRI memory manger from Tungsten Graphics.

At least one patch is too big for the list, and I spent a lot of time
getting the separation even to this level...

the patches are here:
http://people.freedesktop.org/~airlied/ttm/

What is this?
The DRI memory manager is a new unified memory manager for GPUs initially
targetted at Intel Integrated devices.
http://www.tungstengraphics.com/wiki/index.php/TTM_Memory_Manager

What's changed recently?

The major thrust of recent work has been to try and stabilise the memory 
manager API (ioctls) such that we believe they are supportable going 
forward. Thomas Hellstrom (TG), Eric Anholt (Intel) and me (Red Hat), have 
worked to create a cleaner API that we believe should provide the 
functionality we need from a GPU memory manager going forward. We have 
focused on the API as this is set in stone once we merge the code into a 
stable kernel.

What are in these patches?
The patches contain the changes to the core DRM infrastructure to add 
support for fencing and buffer objects. It doesn't contain the AGP backend 
or the i915 driver which will be posted later.

Issues raised previously:
1. use of proc - drm already uses proc so until all of the drm moves out 
of proc, no point adding a whole new interface just for one info file.
2. heuristic for memory limiting. - Users can allocate a lot of locked 
memory using the GPU memory manager this is required for graphics 
applications. The current code just imposes a limit worked out from the 
amount of low memory. We have talked to benh about trying to solve this in 
a generic way along with SPU.
3. style - yes the code should nearly all be kernel style, and I don't 
think it introduces any new compat wrappers or anything for ppl to give 
out about (except maybe the memory limiter).

I think its about time we merged this code, it is in an area of the 
kernel wholly self-contained and mostly maintained by me, and adds a 
feature that allows userspace graphics to leverage features of graphics 
cards that only the binary vendors have done up until now.

Dave.

