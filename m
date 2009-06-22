Return-Path: <linux-kernel-owner+w=401wt.eu-S1758521AbZFVPpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758521AbZFVPpA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 11:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929AbZFVPot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 11:44:49 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:43039 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515AbZFVPos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 11:44:48 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 22 Jun 2009 17:43:16 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull] FireWire updates post 2.6.30, the rest
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.9282749343d60f9f@s5r6.in-berlin.de>
Message-ID: <tkrat.190a88350b3d25c7@s5r6.in-berlin.de>
References: <tkrat.9282749343d60f9f@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following IEEE 1394/ FireWire subsystem updates.
The shortlog says it all --- drivers/firewire gains IPv4 support and is
no longer considered experimental.

The "new" firewire stack is now preferable over the older ieee1394 stack
*except for audio devices* (FireWire audio devices for sound studios,
driven by the FFADO + Jack userspace framework), and for FireWire DVB
boxes driven by the firedtv kernel driver (to be adapted to the new
firewire stack RSN).  Distributors who like to utilize the enhanced
features, performance, and security of the new stack but also want to
support pro/ semi-pro FireWire audio and FireWire DVB too can easily
package both the old and the new stack.  Some more info is provided via
the Kconfig help text.

The code in this form has been in linux-next for merely a week, even
though the bulk of it was supplied to linux1394-devel in May.  Sorry for
my being slow to line it up.

Jay Fenlason (1):
      firewire: add IPv4 support

Stefan Richter (10):
      firewire: net: add Kconfig item, rename driver
      firewire: net: style changes
      firewire: net: allow for unordered unit discovery
      firewire: net: remove unused code
      firewire: net: adjust net_device ops
      firewire: core: fix DMA unmapping in iso buffer removal
      firewire: core: fix iso context shutdown on card removal
      firewire: net: fix card driver reloading
      firewire: net: better FIFO address range check and rcodes
      firewire: new stack is no longer experimental

 drivers/firewire/Kconfig     |   60 +-
 drivers/firewire/Makefile    |    4 +-
 drivers/firewire/core-card.c |   20 +-
 drivers/firewire/core-iso.c  |   11 +-
 drivers/firewire/core.h      |   87 ---
 drivers/firewire/net.c       | 1655 ++++++++++++++++++++++++++++++++++++++++++
 drivers/ieee1394/Kconfig     |   19 +-
 include/linux/firewire.h     |   87 +++
 8 files changed, 1807 insertions(+), 136 deletions(-)
 create mode 100644 drivers/firewire/net.c

Thanks,
-- 
Stefan Richter
-=====-==--= -==- =-==-
http://arcgraph.de/sr/

