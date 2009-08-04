Return-Path: <linux-kernel-owner+w=401wt.eu-S932858AbZHDPcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932858AbZHDPcL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 11:32:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932839AbZHDPcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 11:32:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:39775 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932832AbZHDPcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 11:32:06 -0400
Date: Tue, 4 Aug 2009 15:31:36 GMT
From: tip-bot for Jack Steiner <steiner@sgi.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090727143808.GA8076@sgi.com>
References: <20090727143808.GA8076@sgi.com>
Subject: [tip:x86/urgent] x86, UV: Fix macros for accessing large node numbers
Message-ID: <tip-67e83f309ed0baaf01a2c956b5174905bcdc1242@git.kernel.org>
Git-Commit-ID: 67e83f309ed0baaf01a2c956b5174905bcdc1242
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 04 Aug 2009 15:31:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  67e83f309ed0baaf01a2c956b5174905bcdc1242
Gitweb:     http://git.kernel.org/tip/67e83f309ed0baaf01a2c956b5174905bcdc1242
Author:     Jack Steiner <steiner@sgi.com>
AuthorDate: Mon, 27 Jul 2009 09:38:08 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 4 Aug 2009 16:19:14 +0200

x86, UV: Fix macros for accessing large node numbers

The UV chipset automatically supplies the upper bits on nodes
being referenced by MMR accesses. These bit can be deleted from
the hub addressing macros.

Signed-off-by: Jack Steiner <steiner@sgi.com>
LKML-Reference: <20090727143808.GA8076@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/uv/uv_hub.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_hub.h b/arch/x86/include/asm/uv/uv_hub.h
index a6dde05..77a6850 100644
--- a/arch/x86/include/asm/uv/uv_hub.h
+++ b/arch/x86/include/asm/uv/uv_hub.h
@@ -175,7 +175,7 @@ DECLARE_PER_CPU(struct uv_hub_info_s, __uv_hub_info);
 #define UV_GLOBAL_MMR32_PNODE_BITS(p)	((p) << (UV_GLOBAL_MMR32_PNODE_SHIFT))
 
 #define UV_GLOBAL_MMR64_PNODE_BITS(p)					\
-	((unsigned long)(UV_PNODE_TO_GNODE(p)) << UV_GLOBAL_MMR64_PNODE_SHIFT)
+	(((unsigned long)(p)) << UV_GLOBAL_MMR64_PNODE_SHIFT)
 
 #define UV_APIC_PNODE_SHIFT	6
 
