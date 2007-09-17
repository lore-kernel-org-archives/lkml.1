Return-Path: <linux-kernel-owner+w=401wt.eu-S932910AbXIQVTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932910AbXIQVTQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 17:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760208AbXIQVS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 17:18:56 -0400
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:33255 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758147AbXIQVSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 17:18:54 -0400
Date: Mon, 17 Sep 2007 23:20:17 +0200
From: Andreas Herrmann <aherrman@arcor.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] mac_hid: fix build error if MAC_EMUMOUSEBTN && !INPUT
Message-ID: <20070917212017.GB22458@devil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With current git an invalid kernel configuration is
selectable which leads to kernel build errors for mac_hid.
To prevent this selection I suggest follwoing patch.

Regards,

Andreas
-- 
Build error if MAC_EMUMOUSEBTN && !INPUT:

  LD      .tmp_vmlinux1
drivers/built-in.o: In function `input_report_key':
include/linux/input.h:1158: undefined reference to `input_event'
    ...

Auto-select INPUT for MAC_EMUMOUSEBTN option.

Signed-off-by: Andreas Herrmann <aherrman@arcor.de>
---
 drivers/macintosh/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/macintosh/Kconfig b/drivers/macintosh/Kconfig
index 56cd899..77f50b6 100644
--- a/drivers/macintosh/Kconfig
+++ b/drivers/macintosh/Kconfig
@@ -172,6 +172,7 @@ config INPUT_ADBHID
 
 config MAC_EMUMOUSEBTN
 	bool "Support for mouse button 2+3 emulation"
+	select INPUT
 	help
 	  This provides generic support for emulating the 2nd and 3rd mouse
 	  button with keypresses.  If you say Y here, the emulation is still
-- 
1.5.3


