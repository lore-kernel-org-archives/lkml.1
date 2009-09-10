Return-Path: <linux-kernel-owner+w=401wt.eu-S1752549AbZIJX5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbZIJX5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 19:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbZIJX5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 19:57:34 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:16081 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbZIJX5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 19:57:33 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, David Daney <ddaney@caviumnetworks.com>,
       David Howells <dhowells@redhat.com>,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
       linux-am33-list@redhat.com
Subject: [PATCH 05/10] mn10300: Convert BUG() to use unreachable()
Date: Thu, 10 Sep 2009 16:56:46 -0700
Message-Id: <1252627011-2933-5-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <4AA991C1.1050800@caviumnetworks.com>
References: <4AA991C1.1050800@caviumnetworks.com>
X-OriginalArrivalTime: 10 Sep 2009 23:57:04.0813 (UTC) FILETIME=[65BE95D0:01CA3272]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new unreachable() macro instead of while(1).

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
CC: David Howells <dhowells@redhat.com>
CC: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
CC: linux-am33-list@redhat.com
---
 arch/mn10300/include/asm/bug.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/mn10300/include/asm/bug.h b/arch/mn10300/include/asm/bug.h
index aa6a388..447a7e6 100644
--- a/arch/mn10300/include/asm/bug.h
+++ b/arch/mn10300/include/asm/bug.h
@@ -27,7 +27,8 @@ do {								\
 		:						\
 		: "i"(__FILE__), "i"(__LINE__)			\
 		);						\
-} while (1)
+	unreachable();						\
+} while (0)
 
 #define HAVE_ARCH_BUG
 #endif /* CONFIG_BUG */
-- 
1.6.2.5

