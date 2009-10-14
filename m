Return-Path: <linux-kernel-owner+w=401wt.eu-S1762054AbZJNWNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762054AbZJNWNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 18:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762071AbZJNWNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 18:13:44 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:46093 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762060AbZJNWNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 18:13:43 -0400
Date: Wed, 14 Oct 2009 15:10:03 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Jes Sorensen <jes@sgi.com>,
       linux-ia64@vger.kernel.org, Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] ia64/sn: fix percpu warnings
Message-Id: <20091014151003.0ef42973.randy.dunlap@oracle.com>
In-Reply-To: <20091014163445.f0441473.sfr@canb.auug.org.au>
References: <20091014163445.f0441473.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4AD64C87.01DD:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix percpu types warning in ia64/sn:

arch/ia64/sn/kernel/setup.c:74: error: conflicting types for '__pcpu_scope___sn_cnodeid_to_nasid'
arch/ia64/include/asm/sn/arch.h:74: error: previous declaration of '__pcpu_scope___sn_cnodeid_to_nasid' was here

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jes Sorensen <jes@sgi.com>
---
 arch/ia64/include/asm/sn/arch.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20091014.orig/arch/ia64/include/asm/sn/arch.h
+++ linux-next-20091014/arch/ia64/include/asm/sn/arch.h
@@ -71,7 +71,7 @@ DECLARE_PER_CPU(struct sn_hub_info_s, __
  * Compact node ID to nasid mappings kept in the per-cpu data areas of each
  * cpu.
  */
-DECLARE_PER_CPU(short, __sn_cnodeid_to_nasid[MAX_COMPACT_NODES]);
+DECLARE_PER_CPU(short [MAX_COMPACT_NODES], __sn_cnodeid_to_nasid);
 #define sn_cnodeid_to_nasid	(&__get_cpu_var(__sn_cnodeid_to_nasid[0]))
 
 
