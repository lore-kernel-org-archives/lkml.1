Return-Path: <linux-kernel-owner+w=401wt.eu-S1757962AbZADLr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962AbZADLr0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 06:47:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbZADLrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 06:47:09 -0500
Received: from edna.telenet-ops.be ([195.130.132.58]:46501 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbZADLrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 06:47:07 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>,
       linux-fbdev-devel@lists.sourceforge.net
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH/v2] Atari frame buffer fixes
Date: Sun,  4 Jan 2009 12:46:57 +0100
Message-Id: <1231069624-13362-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchsets contains several fixes for the Atari frame buffer device, and
includes a refactoring of the c2p (Chunky-to-Planar) code:
  [1] fbdev: atafb - Fix line length handling
  [2] fbdev: atafb - Fix 16 bpp console
  [3] fbdev: c2p - Correct indentation
  [4] fbdev: c2p - Cleanups
  [5] fbdev: c2p - Extract common c2p core to c2p_core.h
  [6] fbdev: c2p/atafb - Add support for Atari interleaved bitplanes
  [7] fbdev: c2p - Rename c2p to c2p_planar

Changes since previous submission:
  - Convert macros to static inline functions
  - Make sure we get a build-time error (undefined reference to
    'c2p_unsupported') in case of future misuse
  - Replace `unsigned long' by `u32' in comp(), as that's what all callers use
  - Use {get,put}_unaligned_be32() in store_{iplan2,planar}{,_masked}()

If nobody objects, I'd like to push this to Linus via the m68k tree, as the
c2p code is used by m68k drivers (atafb and amifb) only.

 drivers/video/Makefile     |    4 +-
 drivers/video/amifb.c      |    6 +-
 drivers/video/atafb.c      |  101 ++++++++-----------
 drivers/video/c2p.c        |  232 --------------------------------------------
 drivers/video/c2p.h        |   11 ++-
 drivers/video/c2p_core.h   |  153 +++++++++++++++++++++++++++++
 drivers/video/c2p_iplan2.c |  153 +++++++++++++++++++++++++++++
 drivers/video/c2p_planar.c |  156 +++++++++++++++++++++++++++++
 8 files changed, 515 insertions(+), 301 deletions(-)


