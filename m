Return-Path: <linux-kernel-owner+w=401wt.eu-S1753041AbZFAOzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbZFAOzi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 10:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754638AbZFAOzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 10:55:14 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:35420 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbZFAOzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 10:55:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=rgPeEyBlzHkcMTVPC4TBWoQz2jKvomuSjjGh5Cto9p3YwN2KP0oRAYllbCoPgMwseC
         eof/QEIo+BRPI27bgkwmk8uWEbLyex3mP4eoHXQfQGXzUhjE936jEJJKqrOeokxbLsi+
         uGKlUAXZKXRlsP0nbnep1fIf8DMLMZSuUXbIM=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org, slapin@ossfans.org,
       maxim.osipov@siemens.com, dmitry.baryshkov@siemens.com,
       oliver.fendt@siemens.com
Subject: [RFC][WIP] IEEE 802.15.4 implementation for Linux v1
Date: Mon,  1 Jun 2009 18:54:41 +0400
Message-Id: <1243868091-5315-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.6.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As a part of research activities the Embedded Systems - Open Platform Group
from Siemens Corporate Technology we are working on adding support for
the IEEE 802.15.4 Wireless Personal Area Networks to the Linux. Our current
implementation is neither certified nor even feature complete. However
we'd like to present current state of our patchset to the Linux developers
community to gain comments, fixes, ideas, etc. This is not yet a pull request,
but more like an RFC.

The project page is available at http://apps.sourceforge.net/trac/linux-zigbee
with source code of kernel part available from git at
http://zigbee-linux.git.sourceforge.net, mirrored for convenience at
git://git.kernel.org/pub/scm/linux/kernel/git/lumag/lowpan.git

The source code for userspace utils is available from git at
http://linux-zigbee.git.sourceforge.net/

Changes since previous RFC:
  * Split the code into socket family, netlink interface and separate
    MAC 802.15.4 implementation.
  * Add a sample driver for devices implementing mac level of IEEE 802.15.4
    on their own.
  * Major cleanup of public interfaces.
  * Drop our CRC implementation and use a variant of CRC-ITU-T one
  * Add preliminary version of AT86RF231 Atmel chip driver

The following changes since commit 59a3759d0fe8d969888c741bb33f4946e4d3750d:
  Linus Torvalds (1):
        Linux 2.6.30-rc7

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lumag/lowpan.git for-review-v1

Darren Salt (1):
      crc-itu-t: add bit-reversed calculation

Dmitry Eremin-Solenikov (9):
      Add constants for the ieee 802.15.4/ZigBee stack
      net: add IEEE 802.15.4 socket family implementation
      net: add NL802154 interface for configuration of 802.15.4 devices
      ieee802154: add simple HardMAC driver sample
      mac802154: add a software MAC 802.15.4 implementation
      ieee802154: add virtual loopback driver
      tty_io: export tty_class
      ieee802154: add serial dongle driver
      ieee802154: add at86rf230/rf231 spi driver

 drivers/Makefile                       |    1 +
 drivers/char/tty_io.c                  |    1 +
 drivers/ieee802154/Kconfig             |   42 ++
 drivers/ieee802154/Makefile            |    6 +
 drivers/ieee802154/at86rf230.c         |  971 +++++++++++++++++++++++++++++++
 drivers/ieee802154/fakehard.c          |  253 ++++++++
 drivers/ieee802154/fakelb.c            |  335 +++++++++++
 drivers/ieee802154/serial.c            |  999 ++++++++++++++++++++++++++++++++
 drivers/net/Kconfig                    |    2 +
 include/linux/crc-itu-t.h              |   10 +
 include/linux/if.h                     |    2 +
 include/linux/if_arp.h                 |    2 +
 include/linux/if_ether.h               |    2 +
 include/linux/socket.h                 |    6 +-
 include/linux/spi/at86rf230.h          |   32 +
 include/linux/tty.h                    |    3 +-
 include/net/ieee802154/af_ieee802154.h |   60 ++
 include/net/ieee802154/mac802154.h     |   79 +++
 include/net/ieee802154/mac_def.h       |  158 +++++
 include/net/ieee802154/netdevice.h     |   84 +++
 include/net/ieee802154/nl802154.h      |  165 ++++++
 lib/crc-itu-t.c                        |   18 +
 net/Kconfig                            |    2 +
 net/Makefile                           |    2 +
 net/core/dev.c                         |    6 +-
 net/core/sock.c                        |    3 +
 net/ieee802154/Kconfig                 |   12 +
 net/ieee802154/Makefile                |    5 +
 net/ieee802154/af802154.h              |   35 ++
 net/ieee802154/af_ieee802154.c         |  356 ++++++++++++
 net/ieee802154/dgram.c                 |  373 ++++++++++++
 net/ieee802154/netlink.c               |  485 ++++++++++++++++
 net/ieee802154/raw.c                   |  250 ++++++++
 net/mac802154/Kconfig                  |   13 +
 net/mac802154/Makefile                 |    5 +
 net/mac802154/beacon.c                 |  242 ++++++++
 net/mac802154/beacon.h                 |   48 ++
 net/mac802154/beacon_hash.c            |  103 ++++
 net/mac802154/beacon_hash.h            |   40 ++
 net/mac802154/dev.c                    |  843 +++++++++++++++++++++++++++
 net/mac802154/mac802154.h              |   64 ++
 net/mac802154/mac_cmd.c                |  325 +++++++++++
 net/mac802154/main.c                   |   96 +++
 net/mac802154/mdev.c                   |  283 +++++++++
 net/mac802154/mib.h                    |   32 +
 net/mac802154/pib.c                    |   87 +++
 net/mac802154/pib.h                    |   35 ++
 net/mac802154/scan.c                   |  215 +++++++
 48 files changed, 7187 insertions(+), 4 deletions(-)
 create mode 100644 drivers/ieee802154/Kconfig
 create mode 100644 drivers/ieee802154/Makefile
 create mode 100644 drivers/ieee802154/at86rf230.c
 create mode 100644 drivers/ieee802154/fakehard.c
 create mode 100644 drivers/ieee802154/fakelb.c
 create mode 100644 drivers/ieee802154/serial.c
 create mode 100644 include/linux/spi/at86rf230.h
 create mode 100644 include/net/ieee802154/af_ieee802154.h
 create mode 100644 include/net/ieee802154/mac802154.h
 create mode 100644 include/net/ieee802154/mac_def.h
 create mode 100644 include/net/ieee802154/netdevice.h
 create mode 100644 include/net/ieee802154/nl802154.h
 create mode 100644 net/ieee802154/Kconfig
 create mode 100644 net/ieee802154/Makefile
 create mode 100644 net/ieee802154/af802154.h
 create mode 100644 net/ieee802154/af_ieee802154.c
 create mode 100644 net/ieee802154/dgram.c
 create mode 100644 net/ieee802154/netlink.c
 create mode 100644 net/ieee802154/raw.c
 create mode 100644 net/mac802154/Kconfig
 create mode 100644 net/mac802154/Makefile
 create mode 100644 net/mac802154/beacon.c
 create mode 100644 net/mac802154/beacon.h
 create mode 100644 net/mac802154/beacon_hash.c
 create mode 100644 net/mac802154/beacon_hash.h
 create mode 100644 net/mac802154/dev.c
 create mode 100644 net/mac802154/mac802154.h
 create mode 100644 net/mac802154/mac_cmd.c
 create mode 100644 net/mac802154/main.c
 create mode 100644 net/mac802154/mdev.c
 create mode 100644 net/mac802154/mib.h
 create mode 100644 net/mac802154/pib.c
 create mode 100644 net/mac802154/pib.h
 create mode 100644 net/mac802154/scan.c
