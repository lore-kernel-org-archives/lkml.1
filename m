Return-Path: <linux-kernel-owner+w=401wt.eu-S1759690AbYHTQlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759690AbYHTQlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 12:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbYHTQkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 12:40:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42547 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbYHTQkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 12:40:39 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: robert.richter@amd.com, oprofile-list@lists.sourceforge.net,
       Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] oprofile: Don't report Nehalem as core_2
Date: Wed, 20 Aug 2008 18:40:32 +0200
Message-Id: <1219250433-25516-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1219250433-25516-3-git-send-email-andi@firstfloor.org>
References: <1219250433-25516-1-git-send-email-andi@firstfloor.org>
 <1219250433-25516-2-git-send-email-andi@firstfloor.org>
 <1219250433-25516-3-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

This essentially reverts Linus' earlier 4b9f12a3779c548b68bc9af7d94030868ad3aa1b
commit. Nehalem is not core_2, so it shouldn't be reported as such.
However with the earlier arch perfmon patch it will fall back to
arch perfmon mode now, so there is no need to fake it as core_2.
The only drawback is that Linus will need to patch the arch perfmon
support into his oprofile binary now, but I think he can do that.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/oprofile/nmi_int.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 6438c32..669a713 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -418,9 +418,6 @@ static int __init ppro_init(char **cpu_type)
 	case 15: case 23:
 		*cpu_type = "i386/core_2";
 		break;
-	case 26:
-		*cpu_type = "i386/core_2";
-		break;
 	default:
 		/* Unknown */
 		return 0;
-- 
1.5.6

