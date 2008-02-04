Return-Path: <linux-kernel-owner+w=401wt.eu-S1755962AbYBDNIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbYBDNIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 08:08:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbYBDNIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 08:08:32 -0500
Received: from ozlabs.org ([203.10.76.45]:48073 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526AbYBDNIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 08:08:31 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] virtio updates
Date: Tue, 5 Feb 2008 00:08:13 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802050008.13834.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 9135f1901ee6449dfe338adf6e40e9c2025b8150:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../bart/ide-2.6

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus master

Anthony Liguori (4):
      virtio: Fix vring_init/vring_size to take unsigned long
      virtio: Put the virtio under the virtualization menu
      virtio: PCI device
      virtio: Use PCI revision field to indicate virtio PCI ABI version

Christian Borntraeger (4):
      virtnet: remove double ether_setup
      virtio_blk: provide getgeo
      virtio_blk: Dont waste major numbers
      virtio_blk: implement naming for vda-vdz,vdaa-vdzz,vdaaa-vdzzz

Dor Laor (1):
      virtio_net: parametrize the napi_weight for virtio receive queue.

Rusty Russell (16):
      virtio: Implement skb_partial_csum_set, for setting partial csums on untrusted packets.
      virtio: simplify config mechanism.
      virtio: explicit enable_cb/disable_cb rather than callback return.
      virtio: configuration change callback
      virtio: clarify NO_NOTIFY flag usage
      virtio: remove unused id field from struct virtio_blk_outhdr
      virtio: Net header needs hdr_len
      virtio: Tweak virtio_net defines
      virtio: populate network rings in the probe routine, not open
      virtio: reset function
      virtio: handle interrupts after callbacks turned off
      virtio: Use the sg_phys convenience function.
      virtio: Allow virtio to be modular and used by modules
      virtio: flush buffers on open
      virtio: free transmit skbs when notified, not on next xmit.
      virtio: balloon driver

 Documentation/lguest/lguest.c   |  231 ++++++++++++++-------
 arch/x86/kvm/Kconfig            |    1 +
 drivers/Kconfig                 |    2 -
 drivers/block/Kconfig           |    3 +-
 drivers/block/virtio_blk.c      |  106 ++++++----
 drivers/char/virtio_console.c   |    4 +-
 drivers/lguest/lguest_device.c  |  146 ++++++++-----
 drivers/net/Kconfig             |    3 +-
 drivers/net/virtio_net.c        |  155 ++++++++------
 drivers/virtio/Kconfig          |   31 +++-
 drivers/virtio/Makefile         |    2 +
 drivers/virtio/virtio.c         |   65 ++----
 drivers/virtio/virtio_balloon.c |  284 +++++++++++++++++++++++++
 drivers/virtio/virtio_pci.c     |  446 +++++++++++++++++++++++++++++++++++++++
 drivers/virtio/virtio_ring.c    |   51 +++--
 include/linux/lguest_launcher.h |    9 +-
 include/linux/skbuff.h          |    1 +
 include/linux/virtio.h          |   19 +-
 include/linux/virtio_balloon.h  |   18 ++
 include/linux/virtio_blk.h      |   22 +-
 include/linux/virtio_config.h   |  104 +++++-----
 include/linux/virtio_net.h      |   32 ++--
 include/linux/virtio_pci.h      |   57 +++++
 include/linux/virtio_ring.h     |   14 +-
 net/9p/trans_virtio.c           |    8 +-
 net/core/skbuff.c               |   29 +++
 26 files changed, 1422 insertions(+), 421 deletions(-)
 create mode 100644 drivers/virtio/virtio_balloon.c
 create mode 100644 drivers/virtio/virtio_pci.c
 create mode 100644 include/linux/virtio_balloon.h
 create mode 100644 include/linux/virtio_pci.h
