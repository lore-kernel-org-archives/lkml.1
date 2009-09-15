Return-Path: <linux-kernel-owner+w=401wt.eu-S1753532AbZIOXjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbZIOXjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 19:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbZIOXjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 19:39:37 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47629 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120AbZIOXjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 19:39:37 -0400
Date: Wed, 16 Sep 2009 09:39:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <borislav.petkov@amd.com>, x86@kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] edac: need to export cpu_llc_id
Message-Id: <20090916093935.6bc2c91f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's linux-next build (x86_64 allmodconfig) failed like this:

ERROR: "per_cpu__cpu_llc_id" [drivers/edac/edac_core.ko] undefined!

Caused by commit b69b29de65fe4078b125acc9dea34be82f7c362c ("EDAC, AMD:
carve out MCi_STATUS decoding").

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/x86/kernel/smpboot.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index a25eeec..04c74b4 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -100,6 +100,7 @@ EXPORT_SYMBOL(smp_num_siblings);
 
 /* Last level cache ID of each logical CPU */
 DEFINE_PER_CPU(u16, cpu_llc_id) = BAD_APICID;
+EXPORT_PER_CPU_SYMBOL(cpu_llc_id);
 
 /* representing HT siblings of each logical CPU */
 DEFINE_PER_CPU(cpumask_var_t, cpu_sibling_map);
-- 
1.6.3.3


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
