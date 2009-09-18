Return-Path: <linux-kernel-owner+w=401wt.eu-S1756629AbZIRMHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbZIRMHM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 08:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486AbZIRMHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 08:07:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:55433 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589AbZIRMHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 08:07:09 -0400
Date: Fri, 18 Sep 2009 12:06:40 GMT
From: tip-bot for Jack Steiner <steiner@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       steiner@sgi.com, stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       steiner@sgi.com, stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090909154104.GA25083@sgi.com>
References: <20090909154104.GA25083@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: SGI UV: Fix IPI macros
Message-ID: <tip-d2374aecda3f6c9b0d13287027132a37311da300@git.kernel.org>
Git-Commit-ID: d2374aecda3f6c9b0d13287027132a37311da300
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 18 Sep 2009 12:06:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d2374aecda3f6c9b0d13287027132a37311da300
Gitweb:     http://git.kernel.org/tip/d2374aecda3f6c9b0d13287027132a37311da300
Author:     Jack Steiner <steiner@sgi.com>
AuthorDate: Wed, 9 Sep 2009 10:41:05 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 18 Sep 2009 14:04:25 +0200

x86: SGI UV: Fix IPI macros

The UV BIOS has changed the way interrupt remapping is being done.
This affects the id used for sending IPIs. The upper id bits no
longer need to be masked off.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Cc: <stable@kernel.org>
LKML-Reference: <20090909154104.GA25083@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/uv/uv_hub.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_hub.h b/arch/x86/include/asm/uv/uv_hub.h
index 77a6850..03a0cbd 100644
--- a/arch/x86/include/asm/uv/uv_hub.h
+++ b/arch/x86/include/asm/uv/uv_hub.h
@@ -422,7 +422,7 @@ static inline void uv_hub_send_ipi(int pnode, int apicid, int vector)
 	unsigned long val;
 
 	val = (1UL << UVH_IPI_INT_SEND_SHFT) |
-			((apicid & 0x3f) << UVH_IPI_INT_APIC_ID_SHFT) |
+			((apicid) << UVH_IPI_INT_APIC_ID_SHFT) |
 			(vector << UVH_IPI_INT_VECTOR_SHFT);
 	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
 }
