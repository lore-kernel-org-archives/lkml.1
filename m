Return-Path: <linux-kernel-owner+w=401wt.eu-S1756938AbZD0SFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938AbZD0SFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 14:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755151AbZD0SFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 14:05:38 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:62266 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754393AbZD0SFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 14:05:38 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       Tim Abbott <tabbott@MIT.EDU>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 4/8] powerpc: Use TEXT_TEXT macro in linker script.
Date: Mon, 27 Apr 2009 14:02:23 -0400
Message-Id: <1240855347-19316-5-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1240855347-19316-4-git-send-email-tabbott@mit.edu>
References: <1240855347-19316-1-git-send-email-tabbott@mit.edu>
 <1240855347-19316-2-git-send-email-tabbott@mit.edu>
 <1240855347-19316-3-git-send-email-tabbott@mit.edu>
 <1240855347-19316-4-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than adding .ref.text to the powerpc linker script so that we
can use __REF on the powerpc architecture, it seems simpler to switch
to using the generic TEXT_TEXT macro.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/kernel/vmlinux.lds.S |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index d7425ff..433ae11 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -54,7 +54,8 @@ SECTIONS
 		ALIGN_FUNCTION();
 		HEAD_TEXT
 		_text = .;
-		*(.text .fixup .text.init.refok .exit.text.refok __ftr_alt_*)
+		TEXT_TEXT
+		*(.fixup __ftr_alt_*)
 		SCHED_TEXT
 		LOCK_TEXT
 		KPROBES_TEXT
-- 
1.6.2.1

