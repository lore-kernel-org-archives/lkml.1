Return-Path: <linux-kernel-owner+w=401wt.eu-S1755167AbZEKPhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbZEKPhc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 11:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753702AbZEKPhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 11:37:13 -0400
Received: from krynn.se.axis.com ([193.13.178.10]:52061 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937AbZEKPhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 11:37:12 -0400
Date: Mon, 11 May 2009 17:35:47 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>
Subject: [git pull] CRIS updates
Message-ID: <20090511153547.GT21811@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Four small fixes, although the merge of the boot files looks
larger than it is.

The following changes since commit a939b96cccdb65df80a52447ec8e4a6d79c56dbb:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../rafael/suspend-2.6

are available in the git repository at:

  git://repo.or.cz/cris-mirror.git for-linus

Jesper Nilsson (4):
      CRIS: Merge machine dependent boot/compressed and boot/rescue
      CRISv32: Remove obsolete vcs_hook.o from Makefile
      CRIS: Wire up syscalls signalfd4 to writev.
      CRISv32: Fix typo compile error in ARTPEC-3 gpio driver.

 arch/cris/Makefile                                 |   14 +-
 arch/cris/arch-v10/boot/compressed/Makefile        |   27 ---
 arch/cris/arch-v10/boot/compressed/README          |   25 --
 arch/cris/arch-v10/boot/compressed/misc.c          |  246 --------------------
 arch/cris/arch-v10/kernel/entry.S                  |   14 +-
 arch/cris/arch-v32/boot/Makefile                   |   20 --
 arch/cris/arch-v32/boot/compressed/Makefile        |   26 --
 arch/cris/arch-v32/boot/rescue/Makefile            |   26 --
 arch/cris/arch-v32/drivers/mach-a3/gpio.c          |    4 +-
 arch/cris/arch-v32/kernel/Makefile                 |    2 -
 arch/cris/arch-v32/kernel/entry.S                  |    8 +
 arch/cris/{arch-v10 => }/boot/.gitignore           |    0
 arch/cris/{arch-v10 => }/boot/Makefile             |    8 +-
 arch/cris/boot/compressed/Makefile                 |   38 +++
 arch/cris/{arch-v32 => }/boot/compressed/README    |    0
 .../compressed/decompress_v10.lds}                 |    0
 .../compressed/decompress_v32.lds}                 |    0
 .../head.S => boot/compressed/head_v10.S}          |    4 +-
 .../head.S => boot/compressed/head_v32.S}          |   10 +-
 arch/cris/{arch-v32 => }/boot/compressed/misc.c    |  193 +++++++++++-----
 arch/cris/{arch-v10 => }/boot/rescue/Makefile      |   22 ++-
 .../boot/rescue/head.S => boot/rescue/head_v10.S}  |    2 +-
 .../boot/rescue/head.S => boot/rescue/head_v32.S}  |    0
 .../cris/{arch-v10 => }/boot/rescue/kimagerescue.S |    0
 .../rescue.lds => boot/rescue/rescue_v10.lds}      |    0
 .../rescue.lds => boot/rescue/rescue_v32.lds}      |    0
 arch/cris/{arch-v10 => }/boot/rescue/testrescue.S  |    0
 arch/cris/{arch-v10 => }/boot/tools/build.c        |    0
 arch/cris/include/asm/unistd.h                     |   12 +-
 29 files changed, 240 insertions(+), 461 deletions(-)
 delete mode 100644 arch/cris/arch-v10/boot/compressed/Makefile
 delete mode 100644 arch/cris/arch-v10/boot/compressed/README
 delete mode 100644 arch/cris/arch-v10/boot/compressed/misc.c
 delete mode 100644 arch/cris/arch-v32/boot/Makefile
 delete mode 100644 arch/cris/arch-v32/boot/compressed/Makefile
 delete mode 100644 arch/cris/arch-v32/boot/rescue/Makefile
 rename arch/cris/{arch-v10 => }/boot/.gitignore (100%)
 rename arch/cris/{arch-v10 => }/boot/Makefile (65%)
 create mode 100644 arch/cris/boot/compressed/Makefile
 rename arch/cris/{arch-v32 => }/boot/compressed/README (100%)
 rename arch/cris/{arch-v10/boot/compressed/decompress.lds => boot/compressed/decompress_v10.lds} (100%)
 rename arch/cris/{arch-v32/boot/compressed/decompress.lds => boot/compressed/decompress_v32.lds} (100%)
 rename arch/cris/{arch-v10/boot/compressed/head.S => boot/compressed/head_v10.S} (97%)
 rename arch/cris/{arch-v32/boot/compressed/head.S => boot/compressed/head_v32.S} (94%)
 rename arch/cris/{arch-v32 => }/boot/compressed/misc.c (65%)
 rename arch/cris/{arch-v10 => }/boot/rescue/Makefile (63%)
 rename arch/cris/{arch-v10/boot/rescue/head.S => boot/rescue/head_v10.S} (99%)
 rename arch/cris/{arch-v32/boot/rescue/head.S => boot/rescue/head_v32.S} (100%)
 rename arch/cris/{arch-v10 => }/boot/rescue/kimagerescue.S (100%)
 rename arch/cris/{arch-v10/boot/rescue/rescue.lds => boot/rescue/rescue_v10.lds} (100%)
 rename arch/cris/{arch-v32/boot/rescue/rescue.lds => boot/rescue/rescue_v32.lds} (100%)
 rename arch/cris/{arch-v10 => }/boot/rescue/testrescue.S (100%)
 rename arch/cris/{arch-v10 => }/boot/tools/build.c (100%)


Thanks!

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
