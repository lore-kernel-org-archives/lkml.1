Return-Path: <linux-kernel-owner+w=401wt.eu-S1752217AbZIQT5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbZIQT5u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 15:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbZIQT5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 15:57:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:56998 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbZIQT5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 15:57:43 -0400
Message-Id: <20090917195745.998349026@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 17 Sep 2009 15:55:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 3/5] [PATCH 3/5] oprofile: fix oprofile regression: select RING_BUFFER_ALLOW_SWAP
References: <20090917195508.189551309@goodmis.org>
Content-Disposition: inline; filename=0003-oprofile-fix-oprofile-regression-select-RING_BUFFER_.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

commit 85bac32c4a52c592b857f2c360cc5ec93a097d70
    ring-buffer: only enable ring_buffer_swap_cpu when needed
broke oprofile (at least on s390, but likely on all platforms).

this patch lets oprofile select RING_BUFER_ALLOW_SWAP to make
ring_buffer_swap_cpu usable for oprofile.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
LKML-Reference: <200909162156.49239.borntraeger@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Robert Richter <robert.richter@amd.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index beea3cc..7f418bb 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -9,6 +9,7 @@ config OPROFILE
 	depends on TRACING_SUPPORT
 	select TRACING
 	select RING_BUFFER
+	select RING_BUFFER_ALLOW_SWAP
 	help
 	  OProfile is a profiling system capable of profiling the
 	  whole system, include the kernel, kernel modules, libraries,
-- 
1.6.3.3


