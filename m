Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbYGVJ2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbYGVJ2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 05:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbYGVJ2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 05:28:40 -0400
Received: from ozlabs.org ([203.10.76.45]:47330 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821AbYGVJ2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 05:28:39 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] module and kmod patches
Date: Tue, 22 Jul 2008 19:28:06 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
       Richard Kennedy <richard@rsk.demon.co.uk>,
       Denys Vlasenko <vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807221928.06660.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 93ded9b8fd42abe2c3607097963d8de6ad9117eb:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../gregkh/usb-2.6

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Denys Vlasenko (2):
      Shrink struct module: CONFIG_UNUSED_SYMBOLS ifdefs
      module: turn longs into ints for module sizes

Johannes Berg (6):
      make CONFIG_KMOD invisible
      remove mention of CONFIG_KMOD from documentation
      rework try_then_request_module to do less in non-modular kernels
      remove CONFIG_KMOD from sparc64
      remove CONFIG_KMOD from lib
      remove CONFIG_KMOD from core kernel code

Richard Kennedy (1):
      module: reorder struct module to save space on 64 bit builds

Rusty Russell (3):
      module: don't use stop_machine for waiting rmmod
      module: generic each_symbol iterator function
      modules: Take a shortcut for checking if an address is in a module

 Documentation/filesystems/bfs.txt                  |   10 +-
 .../sound/alsa/DocBook/alsa-driver-api.tmpl        |    2 +-
 Documentation/telephony/ixj.txt                    |   13 +-
 Documentation/video4linux/w9968cf.txt              |    3 -
 arch/blackfin/Kconfig                              |    4 +-
 arch/sparc64/kernel/process.c                      |    6 +-
 arch/sparc64/kernel/traps.c                        |    3 -
 arch/xtensa/Kconfig                                |    4 +-
 include/linux/kmod.h                               |    5 +-
 include/linux/module.h                             |   50 ++--
 init/Kconfig                                       |   15 +-
 kernel/exec_domain.c                               |    2 +-
 kernel/kmod.c                                      |    2 +-
 kernel/module.c                                    |  336 ++++++++++++--------
 kernel/sysctl.c                                    |    4 +-
 lib/textsearch.c                                   |    2 +-
 16 files changed, 259 insertions(+), 202 deletions(-)
