Return-Path: <linux-kernel-owner+w=401wt.eu-S1757263AbZINV4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263AbZINV4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 17:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932353AbZINV4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 17:56:12 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:9429 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932312AbZINV4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 17:56:05 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       David Daney <ddaney@caviumnetworks.com>,
       David Howells <dhowells@redhat.com>,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
       linux-am33-list@redhat.com
Subject: [PATCH 05/11] mn10300: Convert BUG() to use unreachable()
Date: Mon, 14 Sep 2009 14:55:34 -0700
Message-Id: <1252965340-31735-5-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <4AAEBAC2.1050905@caviumnetworks.com>
References: <4AAEBAC2.1050905@caviumnetworks.com>
X-OriginalArrivalTime: 14 Sep 2009 21:55:58.0887 (UTC) FILETIME=[24914370:01CA3586]
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

