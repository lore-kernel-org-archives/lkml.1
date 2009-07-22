Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbZGVKK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbZGVKK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 06:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578AbZGVKK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 06:10:57 -0400
Received: from smtp161.dfw.emailsrvr.com ([67.192.241.161]:40236 "EHLO
	smtp161.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282AbZGVKKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 06:10:52 -0400
From: Oren Laadan <orenl@librato.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@osdl.org>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-api@vger.kernel.org, Serge Hallyn <serue@us.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Pavel Emelyanov <xemul@openvz.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, Oren Laadan <orenl@librato.com>,
       Dan Smith <danms@us.ibm.com>
Subject: [RFC v17][PATCH 53/60] c/r: (s390): expose a constant for the number of words (CRs)
Date: Wed, 22 Jul 2009 06:00:15 -0400
Message-Id: <1248256822-23416-54-git-send-email-orenl@librato.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1248256822-23416-1-git-send-email-orenl@librato.com>
References: <1248256822-23416-1-git-send-email-orenl@librato.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to use this value in the checkpoint/restart code and would like to
have a constant instead of a magic '3'.

Changelog:
    Mar 30:
            . Add CHECKPOINT_SUPPORT in Kconfig (Nathan Lynch)
    Mar 03:
            . Picked up additional use of magic '3' in ptrace.h

Signed-off-by: Dan Smith <danms@us.ibm.com>
---
 arch/s390/Kconfig |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 2ae5d72..6f143ab 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -49,6 +49,10 @@ config GENERIC_TIME_VSYSCALL
 config GENERIC_CLOCKEVENTS
 	def_bool y
 
+config CHECKPOINT_SUPPORT
+	bool
+	default y if 64BIT
+
 config GENERIC_BUG
 	bool
 	depends on BUG
-- 
1.6.0.4

