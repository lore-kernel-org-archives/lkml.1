Return-Path: <linux-kernel-owner+w=401wt.eu-S933437AbYDPROI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933437AbYDPROI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 13:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757552AbYDPRNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 13:13:54 -0400
Received: from baikonur.stro.at ([213.239.196.228]:43696 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494AbYDPRNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 13:13:54 -0400
From: maximilian attems <max@stro.at>
To: Eric Paris <eparis@redhat.com>
Cc: James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       maximilian attems <max@stro.at>, Martin Michlmayr <tbm@cyrius.com>,
       Gordon Farquharson <gordonfarquharson@gmail.com>
Subject: [PATCH] Kconfig: enhance DEFAULT_MMAP_MIN_ADDR description
Date: Wed, 16 Apr 2008 19:13:44 +0200
Message-Id: <1208366024-20261-1-git-send-email-max@stro.at>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got burned by setting the proposed default of 65536
across all Debian archs.

Thus proposing to be more specific on which archs you may
set this. Also propose a value for arm and friends that
doesn't break sshd.

Signed-off-by: maximilian attems <max@stro.at>
Cc: Martin Michlmayr <tbm@cyrius.com>
Cc: Gordon Farquharson <gordonfarquharson@gmail.com>
---
 security/Kconfig |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/security/Kconfig b/security/Kconfig
index 5dfc206..cc1e4bd 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -113,8 +113,9 @@ config SECURITY_DEFAULT_MMAP_MIN_ADDR
 	  from userspace allocation.  Keeping a user from writing to low pages
 	  can help reduce the impact of kernel NULL pointer bugs.
 
-	  For most users with lots of address space a value of 65536 is
-	  reasonable and should cause no problems.  Programs which use vm86
+	  For most x86 users with lots of address space a value of 65536 is
+	  reasonable and should cause no problems. On arm and other archs
+	  it should not be higher than 32768. Programs which use vm86
 	  functionality would either need additional permissions from either
 	  the LSM or the capabilities module or have this protection disabled.
 
-- 
1.5.5

