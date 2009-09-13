Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022AbZIMXIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbZIMXIH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 19:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839AbZIMXIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 19:08:06 -0400
Received: from vena.lwn.net ([206.168.112.25]:59011 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753334AbZIMXIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 19:08:05 -0400
Date: Sun, 13 Sep 2009 17:08:05 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Harald Welte <laforge@gnumonks.org>, Chris Ball <cjb@laptop.org>
Subject: [FYI] Three viafb trees
Message-ID: <20090913170805.52905437@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Sep 2009 16:01:40 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> Send 'em over.  I haven't heard anything from the original viafb
> submitters for a long time.  Hopefully Florian has time to help out
> with some review-n-test.

OK, I've been doing some hacking and a bunch of flinging patches around
in git.  The result is three branches, all of which are based on
2.6.31 and can be found in:

	git://git.lwn.net/linux-2.6.git

Whether these trees will be useful to anybody remains to be seen; I'm
hoping they can serve as a starting point for the pulling-together of a lot
of divergent via code.

Branch #1 is viafb-mm; it contains all of the patches found in -mm as
of today:

  Alexey Dobriyan (1):
      viafb: switch to seq_file

  Florian Tobias Schandinat (19):
      viafb: Remove duplicated cx700 register initialization
      viafb: remove temporary start address handling
      viafb: shrink and merge viafb_update_viafb_par
      viafb: split up viafb_set_start_addr
      viafb: clean up ioremap_nocache error handling
      viafb: clean up viamodeh
      viafb: remove duplicated mode information
      viafb: clean up duoview
      viafb: clean up virtual memory handling
      viafb: remove unused video device stuff
      viafb: remove lvds initialization
      viafb: another small cleanup of viafb_par
      viafb: improve viafb_par
      viafb: rewrite the 2d engine
      viafb: 2d engine rewrite v2
      viafb: Clean the hardware cursor handling up.
      viafb: improve pitch handling
      viafb: hardware acceleration initialization cleanup
      viafb: use read-only mode parsing

  Harald Welte (2):
      viafb: make module parameters visible in sysfs
      viafb: remove unused structure member

Branch #2 (olpc-vx855) is all of the viafb/vx855-related stuff from the
OLPC tree, separated from all the other OLPC stuff and pulled forward to
2.6.31.  What can be found there is:

  Chris Ball (3):
      viafb: Add 1200x900 DCON/LCD panel modes for OLPC XO-1.5
      viafb: Do not probe for LVDS/TMDS on OLPC XO-1.5
      Add missing includes to via/{hw,lcd}.c

  Daniel Drake (1):
      viafb: Don't accelerate blit of color images

  Deepak Saxena (2):
      vx855-gpio: Fix parameter order in call to outl
      vx855-gpio: Initialize spinlock prior to use

  Harald Welte (16):
      [FB] viafb: Add missing break statement in switch
      [FB] viafb: Add support for the VX855 chipset
      [FB] viafb: Fix various resource leaks during module_init()
      [FB] viafb: make viafb a first-class citizen using pci_driver
      viafb: pass reference to pci device when calling framebuffer_alloc()
      viafb: use proper pci config API
      viafb: get rid of some duplicated fields in private structure
      viafb: Remove MMIO from private structure
      viafb: make module parameters visible in sysfs
      viafb: clean up duplicated code from 2D acceleration
      viafb: introduce wrapper for 2D engine registers
      viafb: initialize 2D engine registers from loop
      viafb: Determine type of 2D engine and store it in chip_info
      viafb: Add support for 2D accelerated framebuffer on VX800/VX855
      viafb: rework the I2C support in the VIA framebuffer driver
      [MFD] Add VIA VX855 multi-function device

  Paul Fox (2):
      fix comment describing numeric API indices
      eliminate the spinlock when reading a gpio.

My sense is that all of this stuff could conceivably be merged for 2.6.32.
The only problem is that any attempt to merge with viafb-mm leads to the
sort of pain that only high-proof alcohol can fix.  I am almost certain not
to get this work done in the merge window - my liver can't handle it - and
there's no pressing reason to get this stuff into the mainline right now.
So I don't think 2.6.32 is in the cards for this stuff.

OLPC has earned itself a painful merge by keeping this stuff out-of-tree.
But I fear I'll be the one who eventually cleans up that mess.

Branch #3 (olpc-jc) is the work I've done so far, based on top of the OLPC
changes:

  Jonathan Corbet (4):
      viafb: Split via-core from viafb
      viafb: Separate out i2c initialization from viafb
      viafb: Move port configuration into via-core
      viafb: add support for onboard GPIOs

This is just there in case anybody wants to take a look; I'm really just
getting started.

jon
