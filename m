Return-Path: <linux-kernel-owner+w=401wt.eu-S1752974AbZG3Gln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbZG3Gln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 02:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbZG3Glm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 02:41:42 -0400
Received: from ozlabs.org ([203.10.76.45]:54861 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987AbZG3Glm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 02:41:42 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] lguest & virtio fixes, cleanups
Date: Thu, 30 Jul 2009 16:11:37 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: lguest <lguest@ozlabs.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org,
       "Michael S. Tsirkin" <mst@redhat.com>,
       Dan Carpenter <error27@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907301611.38480.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note that the bulk of this is comment updates and style fixups: the
diffstat on the 5 fixes is:

 Documentation/lguest/lguest.c |    6 -
 drivers/lguest/lguest_user.c  |    5
 drivers/virtio/virtio_pci.c   |  246 +++++++++++++++++++++++-------------------
 3 files changed, 147 insertions(+), 110 deletions(-)

The bulk of *that* is the virtio_pci MSI-X support "refactor": I should have
looked much harder at that before I merged it in.

Thanks,
Rusty.

The following changes since commit 658874f05d040ca96eb5ba9b1c30ce0ff287d762:                
  Linus Torvalds (1):                                                                       
        Merge branch 'i2c-fixes-rc4' of git://aeryn.fluff.org.uk/bjdooks/linux              

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Dan Carpenter (1):
      lguest: dereferencing freed mem in add_eventfd()

Michael S. Tsirkin (3):
      virtio: fix memory leak on device removal
      virtio: delete vq from list
      virtio: refactor find_vqs

Rusty Russell (4):
      lguest: fix descriptor corruption in example launcher
      lguest: fix comment style
      lguest: update commentry
      lguest and virtio: cleanup struct definitions to Linux style.

 Documentation/lguest/lguest.c         |  721 ++++++++++++++++++++++-----------
 arch/x86/include/asm/lguest.h         |    3 +-
 arch/x86/include/asm/lguest_hcall.h   |   18 +-
 arch/x86/lguest/boot.c                |  509 ++++++++++++++++--------
 arch/x86/lguest/i386_head.S           |  112 ++++--
 drivers/lguest/core.c                 |  119 ++++--
 drivers/lguest/hypercalls.c           |  145 +++++---
 drivers/lguest/interrupts_and_traps.c |  288 +++++++++-----
 drivers/lguest/lg.h                   |   32 +-
 drivers/lguest/lguest_device.c        |  160 +++++---
 drivers/lguest/lguest_user.c          |  232 ++++++++---
 drivers/lguest/page_tables.c          |  489 +++++++++++++++-------
 drivers/lguest/segments.c             |  106 ++++--
 drivers/lguest/x86/core.c             |  374 +++++++++++------
 drivers/lguest/x86/switcher_32.S      |   22 +-
 drivers/virtio/virtio_pci.c           |  240 +++++++-----
 include/linux/lguest.h                |   39 ++-
 include/linux/lguest_launcher.h       |   18 +-
 include/linux/virtio_blk.h            |    6 +-
 include/linux/virtio_config.h         |    3 +-
 include/linux/virtio_net.h            |    6 +-
 include/linux/virtio_ring.h           |   12 +-
 22 files changed, 2422 insertions(+), 1232 deletions(-)
