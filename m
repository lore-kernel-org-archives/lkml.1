Return-Path: <linux-kernel-owner+w=401wt.eu-S1759548AbZKFSKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548AbZKFSKS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 13:10:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759117AbZKFSKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 13:10:16 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:56412 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbZKFSJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 13:09:16 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, Christoph Hellwig <hch@lst.de>,
       netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [RFC, PATCH 0/7] net, compat_ioctl: move handlers to net/socket.c
Date: Fri,  6 Nov 2009 19:09:02 +0100
Message-Id: <1257530949-9695-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
X-Provags-ID: V01U2FsdGVkX1/FYgRv/2e8BCxIygFUH3/geS70liuntgxB2RJ
 RNqyKbSoO92ZQd79ibrU27buTZGGk62GpcDmY77uquqXnr6TgL
 v7R4xlwOGMGUSw/gouZng==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This cleans up some of the socket ioctl handling by moving it
from fs/compat_ioctl.c to net/socket.c. The code is still untested,
so this is an RFC for now. If you're happy with it, I'll do some
testing to see if everything still works.

This series is a prerequisite for cleaning up the rest of
compat_ioctl.c, saving some 30kb of kernel memory in the end.

The first four patches are probably worthwhile independently,
because they fix some bugs in compat_ioctl handling.
There is some obvious conflict with the ATM patch I sent
independently today. That one should probably be worked out
first.

	Arnd <><

---

Arnd Bergmann (7):
  compat: add struct compat_ifreq etc to compat.h
  net/tun: handle compat_ioctl directly
  net, compat_ioctl: handle socket ioctl abuses in tty drivers
  appletalk: handle SIOCATALKDIFADDR compat ioctl
  copy socket ioctl code to net/socket.h
  compat: move sockios handling to net/socket.c
  net, compat_ioctl: handle more ioctls correctly

 drivers/net/hamradio/6pack.c |   16 +
 drivers/net/hamradio/mkiss.c |   16 +
 drivers/net/slip.c           |   21 ++
 drivers/net/tun.c            |   55 +++-
 drivers/net/wan/x25_asy.c    |   15 +
 drivers/net/wireless/strip.c |   12 +
 fs/compat_ioctl.c            |  745 -----------------------------------------
 include/linux/compat.h       |   39 +++
 net/appletalk/ddp.c          |   12 +-
 net/socket.c                 |  748 +++++++++++++++++++++++++++++++++++++++++-
 10 files changed, 914 insertions(+), 765 deletions(-)

