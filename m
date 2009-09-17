Return-Path: <linux-kernel-owner+w=401wt.eu-S1753612AbZIQUQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbZIQUQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 16:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751085AbZIQUQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 16:16:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:47787 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753534AbZIQUQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 16:16:43 -0400
Date: Thu, 17 Sep 2009 20:16:06 GMT
From: tip-bot for Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       robert.richter@amd.com, rostedt@goodmis.org, tglx@linutronix.de,
       borntraeger@de.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       robert.richter@amd.com, rostedt@goodmis.org, tglx@linutronix.de,
       borntraeger@de.ibm.com, mingo@elte.hu
In-Reply-To: <200909162156.49239.borntraeger@de.ibm.com>
References: <200909162156.49239.borntraeger@de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] oprofile: fix oprofile regression: select RING_BUFFER_ALLOW_SWAP
Message-ID: <tip-9a5963eb494c8a7be65199e15854551df7d2d939@git.kernel.org>
Git-Commit-ID: 9a5963eb494c8a7be65199e15854551df7d2d939
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 17 Sep 2009 20:16:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9a5963eb494c8a7be65199e15854551df7d2d939
Gitweb:     http://git.kernel.org/tip/9a5963eb494c8a7be65199e15854551df7d2d939
Author:     Christian Borntraeger <borntraeger@de.ibm.com>
AuthorDate: Wed, 16 Sep 2009 21:56:49 +0200
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 17 Sep 2009 15:53:42 -0400

oprofile: fix oprofile regression: select RING_BUFFER_ALLOW_SWAP

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
