Return-Path: <linux-kernel-owner+w=401wt.eu-S1763959AbZAUIsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763959AbZAUIsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 03:48:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932157AbZAUIql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 03:46:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:38080 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932139AbZAUIqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 03:46:40 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, linux-kernel@vger.kernel.org, brgerst@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/10] x86: fix percpu_write with 64-bit constants
Date: Wed, 21 Jan 2009 17:46:11 +0900
Message-Id: <1232527578-1960-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1232527578-1960-1-git-send-email-tj@kernel.org>
References: <1232527578-1960-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 21 Jan 2009 08:46:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brian Gerst <brgerst@gmail.com>

Impact: slightly better code generation for percpu_to_op()

The processor will sign-extend 32-bit immediate values in 64-bit
operations.  Use the 'e' constraint ("32-bit signed integer constant,
or a symbolic reference known to fit that range") for 64-bit constants.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/percpu.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index ce980db..0b64af4 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -75,7 +75,7 @@ do {							\
 	case 8:						\
 		asm(op "q %1,"__percpu_arg(0)		\
 		    : "+m" (var)			\
-		    : "r" ((T__)val));			\
+		    : "re" ((T__)val));			\
 		break;					\
 	default: __bad_percpu_size();			\
 	}						\
-- 
1.6.0.2

