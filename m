Return-Path: <linux-kernel-owner+w=401wt.eu-S1759182AbXEJR2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759182AbXEJR2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 13:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756317AbXEJR2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 13:28:35 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:52896 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073AbXEJR2e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 13:28:34 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 10 May 2007 19:26:56 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull] New firewire stack (updated)
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>,
       Christoph Hellwig <hch@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       John Stoffel <john@stoffel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Olaf Hering <olh@suse.de>, Gene Heskett <gene.heskett@gmail.com>,
       Adrian Bunk <bunk@stusta.de>,
       Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
       Bill Fink <billfink@mindspring.com>
In-Reply-To: <4637A29F.6070302@redhat.com>
Message-ID: <tkrat.b635518ff171071d@s5r6.in-berlin.de>
References: <4637A29F.6070302@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the juju branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git juju

to receive the new, alternative IEEE 1394 subsystem ( --- unless you
consider it too close to the end of the merge window now or have other
reservations...).

Many thanks to all who reviewed the submission from May 1st.  Your work
is of great help and is very much appreciated.

What changed since last submission:

Ivo van Doorn (1):
      CRC ITU-T V.41

Kristian Høgsberg (14):
      firewire: Use lib/ implementation of CRC ITU-T.
      firewire: Clean up comment style.
      firewire: Convert card_rwsem to a regular mutex.
      firewire: Coding style cleanup: no spaces after function names.
      firewire: Uppercase most macro names.
      firewire: Use linux/*.h instead of asm/*.h header files.
      firewire: Break out shared IEEE1394 constant to separate header file.
      firewire: Add to fw-core-y instead of assigning fw-core-objs in Makefile.
      firewire: Allocate scsi_host up front and allocate the sbp2_device as hostdata.
      firewire: Handle the last few DMA mapping error cases.
      firewire: Return SCSI_MLQUEUE_HOST_BUSY for out of memory cases in queuecommand.
      firewire: Drop single buffer request support.
      firewire: Always use parens with sizeof.
      firewire: Convert OHCI driver to use standard goto unwinding for error handling.

Kristian Høgsberg, Stefan Richter (1):
      firewire: Add a comment to describe why we split the sg list.

Olaf Hering (1):
      firewire: Provide module aliase for backwards compatibility.

What did _not_ change:

  - The drivers are still named fw-core, fw-ohci, fw-sbp2 (but they
    feature conditional aliases sbp2 and ohci1394 now).  Adrian
    suggested the prefix firewire- instead of fw-.

  - The drivers still live in drivers/firewire/, i.e. have not been put
    into mainline's drivers/ieee1394/.

As mentioned in the previous submission, the main item that is still to
do regarding the new codebase is to bring over IP over 1394, currently
known as eth1394.  But the biggest task is certainly to come up with a
transition schedule for the removal of the existing stack.  IMO,
exposure of the new stack at this time will enable the community of IEEE
1394 developers and users to provide us with the necessary feedback to
tackle that schedule.

To rehash the reasons to undertake this transition:

  + Considerably leaner codebase,

  + cleaned-up and improved in-stack APIs
    (with the side effect of getting rid of a bunch of old bugs),

  + consolidation of the currently four userspace ABIs into one improved
    ABI (which is already supported by the two FireWire low-level
    libraries libraw1394 and libdc1394),

  + improved host security and device security.

As noted, linux1394-2.6.git's juju branch is based on 2.6.21-rc3.  I can
rebase it onto 2.6.21 or current git if you wish.  The juju branch
contains a linear series of now 138 commits:

Adrian Bunk (1)
Andrew Morton (4)
Ivo van Doorn (1)
Kristian Høgsberg (106)
Marc Butler (1)
Olaf Hering (1)
Randy Dunlap (1)
Stefan Richter (22)
Thomas Gleixner (1)

 drivers/Makefile                   |    1 +
 drivers/firewire/Kconfig           |   61 ++
 drivers/firewire/Makefile          |   10 +
 drivers/firewire/fw-card.c         |  560 +++++++++++
 drivers/firewire/fw-cdev.c         |  961 ++++++++++++++++++
 drivers/firewire/fw-device.c       |  813 +++++++++++++++
 drivers/firewire/fw-device.h       |  146 +++
 drivers/firewire/fw-iso.c          |  163 +++
 drivers/firewire/fw-ohci.c         | 1943 ++++++++++++++++++++++++++++++++++++
 drivers/firewire/fw-ohci.h         |  153 +++
 drivers/firewire/fw-sbp2.c         | 1147 +++++++++++++++++++++
 drivers/firewire/fw-topology.c     |  537 ++++++++++
 drivers/firewire/fw-topology.h     |   92 ++
 drivers/firewire/fw-transaction.c  |  910 +++++++++++++++++
 drivers/firewire/fw-transaction.h  |  458 +++++++++
 drivers/ieee1394/Kconfig           |    2 +
 include/linux/crc-itu-t.h          |   28 +
 include/linux/firewire-cdev.h      |  229 +++++
 include/linux/firewire-constants.h |   67 ++
 lib/Kconfig                        |    8 +
 lib/Makefile                       |    1 +
 lib/crc-itu-t.c                    |   69 ++
 22 files changed, 8359 insertions(+), 0 deletions(-)
 create mode 100644 drivers/firewire/Kconfig
 create mode 100644 drivers/firewire/Makefile
 create mode 100644 drivers/firewire/fw-card.c
 create mode 100644 drivers/firewire/fw-cdev.c
 create mode 100644 drivers/firewire/fw-device.c
 create mode 100644 drivers/firewire/fw-device.h
 create mode 100644 drivers/firewire/fw-iso.c
 create mode 100644 drivers/firewire/fw-ohci.c
 create mode 100644 drivers/firewire/fw-ohci.h
 create mode 100644 drivers/firewire/fw-sbp2.c
 create mode 100644 drivers/firewire/fw-topology.c
 create mode 100644 drivers/firewire/fw-topology.h
 create mode 100644 drivers/firewire/fw-transaction.c
 create mode 100644 drivers/firewire/fw-transaction.h
 create mode 100644 include/linux/crc-itu-t.h
 create mode 100644 include/linux/firewire-cdev.h
 create mode 100644 include/linux/firewire-constants.h
 create mode 100644 lib/crc-itu-t.c


Thanks,
-- 
Stefan Richter
-=====-=-=== -=-= -=-=-
http://arcgraph.de/sr/

