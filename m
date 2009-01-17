Return-Path: <linux-kernel-owner+w=401wt.eu-S1761095AbZAQGcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761095AbZAQGcu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 01:32:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754422AbZAQGcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 01:32:41 -0500
Received: from ti-out-0910.google.com ([209.85.142.187]:17325 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbZAQGck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 01:32:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=WK3pI1H8JOx0iVzKdT1VP3/WKvWfIE54T7MtRBXFKDV1BjMbhZu10PoHV2YPK9M27j
         VuBe+4zPjAmC4pHJq5gUMvLDiuEQO5P99CTz7ll+VXoUI3lSPJfnBzjk2tUqdfDD9QB2
         gWep9HW+8/0c/KkJtItb7zSMgy+Xu7kx0k2ag=
Message-ID: <49717B86.30408@gmail.com>
Date: Sat, 17 Jan 2009 15:32:38 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: roel kluin <roel.kluin@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Brian Gerst <brgerst@gmail.com>, Eric Biederman <ebiederm@xmission.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, travis@sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, steiner@sgi.com,
       Hugh Dickins <hugh@veritas.com>
Subject: [PATCH] linker script: add missing .data.percpu.page_aligned
References: <20090115122222.GI22850@elte.hu> <496F3577.4020303@kernel.org> <20090115133206.GA31416@elte.hu> <20090115133916.GA3417@elte.hu> <496FB09A.8020808@kernel.org> <496FE2B3.3060706@gmail.com> <496FFE45.1070802@gmail.com> <20090116131601.GA20593@elte.hu> <49708FEA.9000508@gmail.com> <20090116221651.GA32736@elte.hu> <20090116223828.GA9294@elte.hu> <49716F0E.7060605@gmail.com> <49716FBF.7080203@kernel.org> <49717AE6.9060207@kernel.org>
In-Reply-To: <49717AE6.9060207@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arm, arm/mach-integrator and powerpc were missing
.data.percpu.page_aligned in their percpu output section definitions.
Add it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
This and the previous patch is available in the following git branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu

The tree is on top of the rebased tip/core/percpu (cd3adf52).

Thanks.

 arch/arm/kernel/vmlinux.lds.S     |    1 +
 arch/ia64/kernel/vmlinux.lds.S    |    1 +
 arch/powerpc/kernel/vmlinux.lds.S |    1 +
 3 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index 0021607..85598f7 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -65,6 +65,7 @@ SECTIONS
 #endif
 		. = ALIGN(4096);
 		__per_cpu_start = .;
+			*(.data.percpu.page_aligned)
 			*(.data.percpu)
 			*(.data.percpu.shared_aligned)
 		__per_cpu_end = .;
diff --git a/arch/ia64/kernel/vmlinux.lds.S b/arch/ia64/kernel/vmlinux.lds.S
index 10a7d47..f45e4e5 100644
--- a/arch/ia64/kernel/vmlinux.lds.S
+++ b/arch/ia64/kernel/vmlinux.lds.S
@@ -219,6 +219,7 @@ SECTIONS
   .data.percpu PERCPU_ADDR : AT(__phys_per_cpu_start - LOAD_OFFSET)
 	{
 		__per_cpu_start = .;
+		*(.data.percpu.page_aligned)
 		*(.data.percpu)
 		*(.data.percpu.shared_aligned)
 		__per_cpu_end = .;
diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 47bf15c..04e8ece 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -182,6 +182,7 @@ SECTIONS
 	. = ALIGN(PAGE_SIZE);
 	.data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {
 		__per_cpu_start = .;
+		*(.data.percpu.page_aligned)
 		*(.data.percpu)
 		*(.data.percpu.shared_aligned)
 		__per_cpu_end = .;
-- 
1.6.0.2

