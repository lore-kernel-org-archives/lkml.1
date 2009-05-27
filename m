Return-Path: <linux-kernel-owner+w=401wt.eu-S932752AbZE0RyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932752AbZE0RyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 13:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932109AbZE0Rqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 13:46:52 -0400
Received: from jalapeno.cc.columbia.edu ([128.59.29.5]:54965 "EHLO
	jalapeno.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102AbZE0Rqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 13:46:50 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@osdl.org>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-api@vger.kernel.org, Serge Hallyn <serue@us.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Pavel Emelyanov <xemul@openvz.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Oren Laadan <orenl@cs.columbia.edu>, Dan Smith <danms@us.ibm.com>
Subject: [RFC v16][PATCH 41/43] c/r: (s390): expose a constant for the number of words (CRs)
Date: Wed, 27 May 2009 13:33:07 -0400
Message-Id: <1243445589-32388-42-git-send-email-orenl@cs.columbia.edu>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1243445589-32388-1-git-send-email-orenl@cs.columbia.edu>
References: <1243445589-32388-1-git-send-email-orenl@cs.columbia.edu>
X-No-Spam-Score: Local
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
index 2eca5fe..bf62cad 100644
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

