Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036Ab0ARUYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab0ARUYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 15:24:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940Ab0ARUYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 15:24:23 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:46401 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab0ARUYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 15:24:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=q5Leb4faOPXmE+ELSvah3VT0IIy9Syn2xgbiR427WUQ0pJcKfrMgRIAKRmS/JjM+K5
         XsPkETqhqhRaOAzRjvq5m4qerfIAFD+TxEh/pPi9zpoVl/7GChIY8kIkWGO2t4P28zFY
         QQTi6S22ZmH9WNQJekeZ9hj+bCgzHcyNBdPYs=
Date: Mon, 18 Jan 2010 22:24:14 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: what's up with "make -j N" output?
Message-ID: <20100118202414.GA4207@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Script does effectively:

	make -k -j5 &>1.log

What's inside:

  C  LD      drivers/input/built-in.o
  ^^^^^
  CC      fs/sysfs/symlink.o
  CC [M]  net/bluetooth/l2cap.o
  CC [M]  drivers/ide/ide-eh.o
  CC [M]  drivers/ide/ide-proc.o
  CC      net/core/skbuff.o
  CC      fs/sysfs/mount.o
  CC      fs/sysfs/bin.o
o					<===
  CC [M]  drivers/ide/ide-gd.o
  CC      fs/sysfs/group.o
  LD      fs/sysfs/built-in.o
  CC [M]  drivers/ide/ide-disk.o
  CC      fs/anon_inodes.o

  	...


  CC      drivers/mmc/core/sdio_cis.o
  CC      lib/div64.o
54/built-in.o				<===
  CC      net/ipv4/route.o


IIRC, I never saw this before.
Maybe something wasn't guaranteed before, but, hey, logs are crap now.

Kernel is 2.6.33-rc4-00204-g7dc9c48, x86_64

CONFIG_PREEMPT=y
CONFIG_HZ=100

# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_DEBUG_FS is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_PREEMPT=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_SPINLOCK_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DEBUG_STRICT_USER_COPY_CHECKS=y
