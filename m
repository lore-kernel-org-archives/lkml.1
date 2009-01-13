Return-Path: <linux-kernel-owner+w=401wt.eu-S1758007AbZAMKnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007AbZAMKnh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 05:43:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbZAMKjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 05:39:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:51188 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053AbZAMKj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 05:39:29 -0500
From: Tejun Heo <tj@kernel.org>
To: ebiederm@xmission.com, cl@linux-foundation.org, rusty@rustcorp.com.au,
       mingo@elte.hu, travis@sgi.com, linux-kernel@vger.kernel.org,
       hpa@zytor.com, akpm@linux-foundation.org, steiner@sgi.com,
       hugh@veritas.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/13] x86_64: fix pda_to_op()
Date: Tue, 13 Jan 2009 19:38:05 +0900
Message-Id: <1231843097-18003-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1231843097-18003-1-git-send-email-tj@kernel.org>
References: <1231843097-18003-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 13 Jan 2009 10:38:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no instruction to move a 64bit immediate into memory location.
Drop "i".

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/pda.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/pda.h b/arch/x86/include/asm/pda.h
index 2fbfff8..cbd3f48 100644
--- a/arch/x86/include/asm/pda.h
+++ b/arch/x86/include/asm/pda.h
@@ -78,7 +78,7 @@ do {									\
 	case 8:								\
 		asm(op "q %1,%%gs:%c2":					\
 		    "+m" (_proxy_pda.field) :				\
-		    "ri" ((T__)val),					\
+		    "r" ((T__)val),					\
 		    "i"(pda_offset(field)));				\
 		break;							\
 	default:							\
-- 
1.5.6

