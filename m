Return-Path: <linux-kernel-owner+w=401wt.eu-S1760805AbXEVAL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760805AbXEVAL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 20:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755100AbXEVALR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 20:11:17 -0400
Received: from gate.crashing.org ([63.228.1.57]:44697 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449AbXEVALQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 20:11:16 -0400
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: linux-kernel@vger.kernel.org,
       James Simmons <jsimmons@pentafluge.infradead.org>,
       Dave Airlie <airlied@gmail.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       dri-devel@lists.sourceforge.net
In-Reply-To: <200705171423.46748.jesse.barnes@intel.com>
References: <200705171423.46748.jesse.barnes@intel.com>
Content-Type: text/plain
Date: Tue, 22 May 2007 10:09:47 +1000
Message-Id: <1179792587.32247.769.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> In collaboration with the FB guys, we've been working on enhancing
> the 
> kernel's graphics subsystem in an attempt to bring some sanity to the 
> Linux graphics world and avoid the situation we have now where
> several 
> kernel and userspace drivers compete for control of graphics devices.

 .../...

A little note about initial mode setting at boot...

I do stongly beleive that the decision of what mode to choose should not
be made in the kernel. At boot the kernel should either leave the HW in
whatever state the FW set it (and text mode is fine) or setup some sane
default (ie 640x480 has the most chances of working) if that's not an
option, maybe some very minimum EDID parsing in case you have a fixed
frequency weirdo panel, but that's it (unless it's a mac an OF tells you
what to use :-)

The kernel would provide userland with connector infos (presence load
detect, EDID, ...) and userland gets to decide what to do.

Some reasons to keep that policy completely out of the kernel even at
boot time are:

 - User may want to configure his default gfx setup and have it up early

 - EDID do lie, monitors routinely ship with windows .inf files
containing "updated" infos apple has that too in OS X (EDID overrides
afaik) etc.... and if we're going to do such a database of known
monitors, it should definitely not be in the kernel. Besides, we want to
add more infos that EDIDs don't provide most of the time to it like
subpixel ordering etc...

 - It sounds better that way :-) (yeah, that's the best reason !)

So while I agree that the register frobbing, memory management, etc...
should be indeed moved to the kernel as you guys have been doing lately,
the policy of deciding what mode to set should totally stick to
userland.

IMHO, the best would be a lib (or daemon or both) for monitor detection
& mode setting that is separate from X :-) That could handle storing the
admin's default setup (including weird monitor info if any) and
restoring it at boot time, etc...

Cheers,
Ben.


