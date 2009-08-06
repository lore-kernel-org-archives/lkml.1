Return-Path: <linux-kernel-owner+w=401wt.eu-S1755721AbZHFNKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721AbZHFNKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 09:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755684AbZHFNKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 09:10:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:60391 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755648AbZHFNKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 09:10:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Andi Kleen <andi@firstfloor.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 0/5] Kill the BKL in compat ioctl handling
Date: Thu,  6 Aug 2009 15:09:25 +0200
Message-Id: <1249564170-18627-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
X-Provags-ID: V01U2FsdGVkX1+K3CBT5NP9AoI76LMgTHeaSR0OnF85E7TeuMJ
 3ppkE2xFvjr46Izv8ZxmXfx9ip+pYgVf33X9jzm91U62vp9I8/
 BPeDKqUkxICgWpcOUJIVg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that compat_sys_ioctl still holds the big kernel
lock for all ioctl conversion handlers. It would be easy to
push this one level down and only do it where necessary,
but I decided to clean it up some more at the same time
and move all the VT ioctl handling into the specific drivers.

	Arnd <><

  arch/um: handle compat_ioctl in tty line driver
  s390: move keyboard compat ioctls into tty3270 driver
  tty: handle VT specific compat ioctls in vt driver
  compat_ioctl: remove VT specific ioctl handlers
  compat_ioctl: do not hold BKL in handlers

 arch/um/drivers/line.c          |    6 +
 arch/um/drivers/ssl.c           |    1 +
 arch/um/drivers/stdio_console.c |    1 +
 arch/um/include/shared/line.h   |    2 +
 drivers/char/vt.c               |    3 +
 drivers/char/vt_ioctl.c         |  203 +++++++++++++++++++++++++++++++++++++
 drivers/s390/char/tty3270.c     |   19 ++++
 fs/compat_ioctl.c               |  213 ---------------------------------------
 include/linux/tty.h             |    3 +
 9 files changed, 238 insertions(+), 213 deletions(-)

