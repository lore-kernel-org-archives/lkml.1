Return-Path: <linux-kernel-owner+w=401wt.eu-S1754829Ab0AIWlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab0AIWlF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 17:41:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746Ab0AIWk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 17:40:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:40151 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189Ab0AIWk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 17:40:57 -0500
Date: Thu, 7 Jan 2010 23:57:40 GMT
From: tip-bot for Jack Steiner <steiner@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       steiner@sgi.com, stable@kernel.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       steiner@sgi.com, stable@kernel.org, tglx@linutronix.de
In-Reply-To: <20100107161240.GA2610@sgi.com>
References: <20100107161240.GA2610@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86, uv: uv_global_gru_mmr_address() macro fix
Message-ID: <tip-e1e0138d7d10fd447c71cc70f367eac514bd3ce4@git.kernel.org>
Git-Commit-ID: e1e0138d7d10fd447c71cc70f367eac514bd3ce4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e1e0138d7d10fd447c71cc70f367eac514bd3ce4
Gitweb:     http://git.kernel.org/tip/e1e0138d7d10fd447c71cc70f367eac514bd3ce4
Author:     Jack Steiner <steiner@sgi.com>
AuthorDate: Thu, 7 Jan 2010 10:12:40 -0600
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 7 Jan 2010 11:49:57 -0800

x86, uv: uv_global_gru_mmr_address() macro fix

Fix bug in uv_global_gru_mmr_address macro.  Macro failed
to cast an int value to a long prior to a left shift > 32.

Signed-off-by: Jack Steiner <steiner@sgi.com>
LKML-Reference: <20100107161240.GA2610@sgi.com>
Cc: <stable@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/uv/uv_hub.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_hub.h b/arch/x86/include/asm/uv/uv_hub.h
index 811bfab..7a81d9d 100644
--- a/arch/x86/include/asm/uv/uv_hub.h
+++ b/arch/x86/include/asm/uv/uv_hub.h
@@ -335,7 +335,8 @@ static inline unsigned long uv_read_global_mmr64(int pnode,
  */
 static inline unsigned long uv_global_gru_mmr_address(int pnode, unsigned long offset)
 {
-	return UV_GLOBAL_GRU_MMR_BASE | offset | (pnode << uv_hub_info->m_val);
+	return UV_GLOBAL_GRU_MMR_BASE | offset |
+		((unsigned long)pnode << uv_hub_info->m_val);
 }
 
 /*
