Return-Path: <linux-kernel-owner+w=401wt.eu-S932403AbXCPIwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403AbXCPIwL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 04:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932382AbXCPIvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 04:51:46 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:34584 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932451AbXCPIvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 04:51:12 -0400
Message-ID: <374035058.29167@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070316084856.687942000@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Fri, 16 Mar 2007 16:48:56 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/14] Adaptive readahead update
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Here is one more adaptive readahead update.

It fixes:
                - state based readahead
                - thrashing recovery readahead
and cleanups:
                - call scheme
                - events/accounting
		- rescue_pages()

Still in the todo list are:
                - convert to Martin's statistic infrastructure
                - a replacement of the stock readahead
                  to be simple, reliable and fast

Regards,
Fengguang Wu
---

Recommended patch ordering:

--- broken-out/series	2007-03-08 11:45:54.000000000 +0800
+++ patches/series	2007-03-16 12:08:17.000000000 +0800
@@ -993,6 +993,9 @@ readahead-min-max-sizes.patch
 readahead-state-based-method-aging-accounting.patch
 readahead-state-based-method-routines.patch
 readahead-state-based-method.patch
+readahead-state-based-method-check-node-id.patch
+readahead-state-based-method-decouple-readahead_ratio-from-growth_limit.patch
+readahead-state-based-method-cancel-lookahead-gracefully.patch
 readahead-context-based-method.patch
 readahead-initial-method-guiding-sizes.patch
 readahead-initial-method-thrashing-guard-size.patch
@@ -1000,10 +1003,21 @@ readahead-initial-method-user-recommende
 readahead-initial-method.patch
 readahead-backward-prefetching-method.patch
 readahead-thrashing-recovery-method.patch
+readahead-thrashing-recovery-method-check-unbalanced-aging.patch
+readahead-thrashing-recovery-method-refill-holes.patch
 readahead-call-scheme.patch
+readahead-call-scheme-cleanup.patch
+readahead-call-scheme-catch-thrashing-on-lookahead-time.patch
 readahead-laptop-mode.patch
 readahead-loop-case.patch
 readahead-nfsd-case.patch
+readahead-remove-parameter-ra_max-from-thrashing_recovery_readahead.patch
+readahead-remove-parameter-ra_max-from-adjust_rala.patch
+readahead-state-based-method-protect-against-tiny-size.patch
+readahead-rename-state_based_readahead-to-clock_based_readahead.patch
+readahead-account-io-block-times-for-stock-readahead.patch
+readahead-rescue_pages-updates.patch
+readahead-remove-noaction-shrink-events.patch
 readahead-remove-size-limit-on-read_ahead_kb.patch
 readahead-remove-size-limit-of-max_sectors_kb-on-read_ahead_kb.patch
 readahead-partial-sendfile-fix.patch
