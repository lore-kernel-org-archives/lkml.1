Return-Path: <linux-kernel-owner+w=401wt.eu-S1752171AbXA0IY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbXA0IY6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 03:24:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbXA0IYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 03:24:35 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:34822 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752177AbXA0IY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 03:24:27 -0500
Message-ID: <369886263.20106@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070127080219.161473179@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Sat, 27 Jan 2007 16:02:19 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Martin Peschke <mp3@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] readahead updates
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Here are more updates for adaptive readahead.

It's not likely to have more big changes, so the next plan is to convert some
accounting items to the statistics infrastructure by Martin Peschke.
[Martin: Sorry for the long delay.]

I'm also playing with the current readahead code, trying to make it more clean
and reliable. I guess it would also be a long journey. It may be better to
wait and confirm if the adaptive readahead works in the wild, before touching
the stock readahead.

Regards,
Fengguang Wu
---

--- broken-out/series	2007-01-12 13:19:44.000000000 +0800
+++ patches/series	2007-01-27 14:53:27.000000000 +0800
@@ -1089,9 +1089,13 @@
 readahead-sysctl-parameters-set-readahead_hit_rate=1.patch
 readahead-min-max-sizes.patch
 readahead-min-max-sizes-remove-get_readahead_bounds.patch
+readahead-min-max-sizes-increase-VM_MIN_READAHEAD-to-32KB.patch
 readahead-state-based-method-aging-accounting.patch
 readahead-state-based-method-routines.patch
+readahead-state-based-method-routines-explicitly-embed-class_new-class_old-inside-flags.patch
 readahead-state-based-method.patch
+readahead-state-based-method-prevent-tiny-size.patch
+readahead-state-based-method-move-readahead_ratio-out-of-compute_thrashing_threshold.patch
 readahead-context-based-method.patch
 readahead-context-based-method-locking-fix.patch
 readahead-context-based-method-locking-fix-2.patch
@@ -1100,14 +1104,18 @@
 readahead-initial-method-guiding-sizes.patch
 readahead-initial-method-thrashing-guard-size.patch
 readahead-initial-method-user-recommended-size.patch
+readahead-initial-method-user-recommended-size-rename-to-read_ahead_initial_kb.patch
 readahead-initial-method.patch
 readahead-backward-prefetching-method.patch
 readahead-thrashing-recovery-method.patch
+readahead-thrashing-recovery-method-fix.patch
 readahead-call-scheme.patch
 readahead-call-scheme-ifdef-fix.patch
 readahead-call-scheme-build-fix.patch
 readahead-call-scheme-remove-get_readahead_bounds.patch
+readahead-call-scheme-fix-thrashed-unaligned-read.patch
 readahead-laptop-mode.patch
+readahead-laptop-mode-fix.patch
 readahead-loop-case.patch
 readahead-nfsd-case.patch
 readahead-nfsd-case-fix.patch
