Return-Path: <linux-kernel-owner+w=401wt.eu-S1762415AbYJJSbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762415AbYJJSbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 14:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758412AbYJJSaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 14:30:55 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57630 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757889AbYJJSaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 14:30:55 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 10 Oct 2008 20:30:35 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: What's in linux1394-2.6.git?
To: linux-kernel@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <tkrat.b23c4b2f8887d5b5@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "misc" branch
=================
essentially contains continuations of work in 2.6.27 on the old ieee1394
stack:
  - BKL removal (now complete in the IEEE 1394 subsystem),
  - more robustness against connection loss.

All of this except for "firewire: time out in fw_core_remove_card" is
merge-ready and will appear in a pull request mid of next week.  There
is nothing interesting for the new firewire stack in it, alas.

Jay Fenlason (1):
      firewire: fw_send_request_sync()

Julia Lawall (1):
      ieee1394: Use DIV_ROUND_UP

Stefan Richter (12):
      ieee1394: sbp2: stricter dma_sync
      ieee1394: sbp2: check for DMA mapping failures
      ieee1394: sbp2: enforce s/g segment size limit
      firewire: fw-sbp2: enforce s/g segment size limit
      firewire: fw-sbp2: fix another small generation access bug
      ieee1394: raw1394: replace BKL by local mutex, make ioctl() and mmap() thread-safe
      ieee1394: raw1394: narrow down the state_mutex protected region
      ieee1394: raw1394: make write() thread-safe
      ieee1394: nodemgr clean up class iterators
      ieee1394: survive a few seconds connection loss
      ieee1394: dv1394, video1394: remove unnecessary expressions
      firewire: time out in fw_core_remove_card


The "cdev" branch
=================
contains updates to the firewire-core userspace interface which I think
should be deferred to after 2.6.28 (for 2.6.29-rc1).  I would like to
add Jay Fenlason's other pending work on the userspace API (iso resource
management, broadcast requests...) and some touch-ups.  I wished I had
all of this ready for the currently open merge window, but I simply d id
not have the necessary time.

Well, actually the two fixes and the documentation patch can and will
already go in in next week's pull request.

David Moore (1):
      firewire: Include iso timestamp in headers when header_size > 4

Jay Fenlason (3):
      firewire: fw_send_request_sync()
      firewire: Add more documentation to firewire-cdev.h
      firewire: add a client_list_lock

Stefan Richter (2):
      firewire: fix setting tag and sy in iso transmission
      firewire: fix ioctl() return code


The "master" branch
===================
has stuff that is still not merge-ready even though it's half a year
old.

Stefan Richter (2):
      firewire: insist on successive self ID complete events
      firewire: unnecessary BM delay after generation rollover


The "firedtv" branch
====================
has one new driver for some FireWire DVB devices.  Well, it's actually
an old driver which went through v4l-experimental and Greg's staging
tree, and was taken into linux1394-2.6.git only for some mainline
submission preparations.

There are four things which would be nice to do before asking for this
to be pulled into mainline:
  - rename the directory, files and some types and variables from
    firesat to firedtv,
  - replace bitfield accesses of on-the-wire data by opencoded
    shifting/ masking/ endian conversion macros,
  - trivial but possibly numerous stylistic touchups (whitespace,
    comment style...),
  - post a snapshot on LKML.
These steps are all simple boring tasks.  I hope to complete them still
during the merge window.  Furthermore, maybe I will collapse most of the
commits which I authored into a single commit to condense less
interesting history.

I suppose I will ask Mauro instead of Linus to pull the driver, although
the patch queue does not touch the DVB subsystem except for adding the
driver to the Makefile and Kconfig.

Ben Backx (2):
      firesat: fix DVB-S2 device recognition
      firesat: add DVB-S support for DVB-S2 devices

Greg Kroah-Hartman (1):
      DVB: add firesat driver

Henrik Kurelid (2):
      firesat: update isochronous interface, add CI support
      firesat: avc resend

Stefan Richter (18):
      firesat: add missing copyright notes
      firesat: rename to firedtv
      firedtv: nicer registration message and some initialization fixes
      firedtv: some header cleanups
      firedtv: replace semaphore by mutex
      firedtv: move some code back to ieee1394 core
      firedtv: replace tasklet by workqueue job
      firedtv: fix remote control input
      ieee1394: use correct barrier types between accesses of nodeid and generation
      ieee1394: add hpsb_node_read() and hpsb_node_lock()
      ieee1394: inherit ud vendor_id from node vendor_id
      firedtv: use hpsb_node_read(), _write(), _lock()
      firedtv: add vendor_id and version to driver match table
      firedtv: remove unused dual subunit code from initialization
      firedtv: fix initialization of dvb_frontend.ops
      firedtv: remove unused struct members
      firedtv: fix string comparison and a few sparse warnings
      firedtv: register input device as child of a FireWire device
-- 
Stefan Richter
-=====-==--- =-=- -=-=-
http://arcgraph.de/sr/

