Return-Path: <linux-kernel-owner+w=401wt.eu-S1764983AbYF0Vsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764983AbYF0Vsn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764151AbYF0ViY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:38:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764199AbYF0ViU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:38:20 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: [PATCH 28/39] use k modifier for 4-byte access.
Date: Fri, 27 Jun 2008 18:34:35 -0300
Message-Id: <1214602486-17080-29-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214602486-17080-28-git-send-email-gcosta@redhat.com>
References: <1214602486-17080-1-git-send-email-gcosta@redhat.com>
 <1214602486-17080-2-git-send-email-gcosta@redhat.com>
 <1214602486-17080-3-git-send-email-gcosta@redhat.com>
 <1214602486-17080-4-git-send-email-gcosta@redhat.com>
 <1214602486-17080-5-git-send-email-gcosta@redhat.com>
 <1214602486-17080-6-git-send-email-gcosta@redhat.com>
 <1214602486-17080-7-git-send-email-gcosta@redhat.com>
 <1214602486-17080-8-git-send-email-gcosta@redhat.com>
 <1214602486-17080-9-git-send-email-gcosta@redhat.com>
 <1214602486-17080-10-git-send-email-gcosta@redhat.com>
 <1214602486-17080-11-git-send-email-gcosta@redhat.com>
 <1214602486-17080-12-git-send-email-gcosta@redhat.com>
 <1214602486-17080-13-git-send-email-gcosta@redhat.com>
 <1214602486-17080-14-git-send-email-gcosta@redhat.com>
 <1214602486-17080-15-git-send-email-gcosta@redhat.com>
 <1214602486-17080-16-git-send-email-gcosta@redhat.com>
 <1214602486-17080-17-git-send-email-gcosta@redhat.com>
 <1214602486-17080-18-git-send-email-gcosta@redhat.com>
 <1214602486-17080-19-git-send-email-gcosta@redhat.com>
 <1214602486-17080-20-git-send-email-gcosta@redhat.com>
 <1214602486-17080-21-git-send-email-gcosta@redhat.com>
 <1214602486-17080-22-git-send-email-gcosta@redhat.com>
 <1214602486-17080-23-git-send-email-gcosta@redhat.com>
 <1214602486-17080-24-git-send-email-gcosta@redhat.com>
 <1214602486-17080-25-git-send-email-gcosta@redhat.com>
 <1214602486-17080-26-git-send-email-gcosta@redhat.com>
 <1214602486-17080-27-git-send-email-gcosta@redhat.com>
 <1214602486-17080-28-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do it in a separate patch for bisectability.
Goal is to have put_user_size integrated.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/uaccess_32.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/uaccess_32.h b/include/asm-x86/uaccess_32.h
index 87b1aed..4c47a5b 100644
--- a/include/asm-x86/uaccess_32.h
+++ b/include/asm-x86/uaccess_32.h
@@ -180,7 +180,7 @@ do {									\
 		__put_user_asm(x, ptr, retval, "w", "w", "ir", errret);	\
 		break;							\
 	case 4:								\
-		__put_user_asm(x, ptr, retval, "l", "",  "ir", errret);	\
+		__put_user_asm(x, ptr, retval, "l", "k",  "ir", errret);\
 		break;							\
 	case 8:								\
 		__put_user_u64((__typeof__(*ptr))(x), ptr, retval);	\
-- 
1.5.5.1

