Return-Path: <linux-kernel-owner+w=401wt.eu-S1753583AbZGZOly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbZGZOly (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 10:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753570AbZGZOlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 10:41:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:39295 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753565AbZGZOlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 10:41:53 -0400
Date: Sun, 26 Jul 2009 14:41:52 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.37.4
Message-ID: <20090726144152.GA2844@hera.kernel.org>
Reply-To: w@1wt.eu
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 26 Jul 2009 14:41:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've just released Linux 2.4.37.4.

It fixes a build error that my last fix to memcmp has introduced
on some archs such as MIPS. It also removes annoying warnings that
were emitted when building with CONFIG_MODVERSIONS=y. This time I
have built for i386, x86_64 and alpha, so we should be fine.

Another relevant fix is related to the personality issue recently
discovered by Julien Tinnes and Tavis Ormandy and fixed in kernel
2.6. While performing deeper checks on 2.4 with Solar Designer, we
found that some archs such as x86_64 are similarly affected while
others like i386 and alpha are not. I would appreciate it if arch
maintainers and/or people well aware of the personality uses could
help us figuring out how this is *supposed* to work and fix the
affected code path. Right now we have applied a common preventive
fix which protects against initial NULL mapping when mmap_min_addr
is correctly set. This should be enough even on untested architectures,
but that's not a reason for not fixing them.

The rest is minor ; fix for some failures to correctly detect some USB
flash drives, and proper MTU checks on tulip to fix VLAN support (tested
and works).

The patch and changelog will appear soon at the following locations:
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/patch-2.4.37.4.bz2
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/ChangeLog-2.4.37.4

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.4.37.y.git
  http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.4.37.y.git

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.4.37.y.git

Note for those who have already upgraded to 2.4.37.3 : the security fix
is not *that* serious, as it protects against faulty setuid programs. If
you don't have any issues with 2.4.37.3, there's no emergency to upgrade.

Willy

--
Summary of changes from v2.4.37.3 to v2.4.37.4
============================================

Tomasz Lemiech (1):
      tulip: Fix for MTU problems with 802.1q tagged frames

Willy Tarreau (6):
      lib: memcmp must be exported without module versioning
      lib: fix again memcmp export issues in the arch ksyms only
      usb-storage: fix "READ CAPACITY failed" errors with USB flash drives
      md/raid5: silent out the "switching cache buffer size" messages
      personality: clear MMAP_PAGE_ZERO on exec if mmap_min_addr is set
      Change VERSION to 2.4.37.4

Zhang Rui (1):
      kernel/resource.c: fix sign extension in reserve_setup()

