Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbYIIOPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbYIIOPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 10:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753979AbYIIOPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 10:15:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51829 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606AbYIIOPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 10:15:39 -0400
Message-ID: <48C68507.6000609@suse.com>
Date: Tue, 09 Sep 2008 10:15:35 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] firmware: Allow release-specific firmware dir
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Every kernel package trying to provide files under /lib/firmware runs
 into problems really quickly with multiple kernels installed, especially
 with respect to distribution package tracking of the files.

 This patch moves them to /lib/firmware/$KERNELRELEASE. udev v127's
 firmware.sh looks there first before falling back to /lib/firmware.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Makefile
+++ b/Makefile
@@ -1025,7 +1025,7 @@ depend dep:
 
 # ---------------------------------------------------------------------------
 # Firmware install
-INSTALL_FW_PATH=$(INSTALL_MOD_PATH)/lib/firmware
+INSTALL_FW_PATH=$(INSTALL_MOD_PATH)/lib/firmware/$(KERNELRELEASE)
 export INSTALL_FW_PATH
 
 PHONY += firmware_install

-- 
Jeff Mahoney
SUSE Labs
