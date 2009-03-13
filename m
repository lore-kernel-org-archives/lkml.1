Return-Path: <linux-kernel-owner+w=401wt.eu-S1757472AbZCMLH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbZCMLH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 07:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbZCMLHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 07:07:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:58754 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbZCMLHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 07:07:16 -0400
Date: Fri, 13 Mar 2009 11:06:29 GMT
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090313104218.A30096@sedona.ch.intel.com>
References: <20090313104218.A30096@sedona.ch.intel.com>
Subject: [tip:tracing/hw-branch-tracing] x86, bts: detect size of DS fields, fix
Message-ID: <tip-79258a354e0c69be94ae2871809a195bf4a647b1@git.kernel.org>
Git-Commit-ID: 79258a354e0c69be94ae2871809a195bf4a647b1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 11:06:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  79258a354e0c69be94ae2871809a195bf4a647b1
Gitweb:     http://git.kernel.org/tip/79258a354e0c69be94ae2871809a195bf4a647b1
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 13 Mar 2009 12:02:08 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 12:02:08 +0100

x86, bts: detect size of DS fields, fix

Impact: build fix

One usage site was missed in the sizeof_field -> sizeof_ptr_field
rename.

Cc: Markus Metzger <markus.t.metzger@intel.com>
LKML-Reference: <20090313104218.A30096@sedona.ch.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/ds.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
index 7363e01..5fd5333 100644
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -983,7 +983,7 @@ ds_configure(const struct ds_configuration *cfg,
 	printk("bts/pebs record: %u/%u bytes\n",
 	       ds_cfg.sizeof_rec[ds_bts], ds_cfg.sizeof_rec[ds_pebs]);
 
-	WARN_ON_ONCE(MAX_SIZEOF_DS < (12 * ds_cfg.sizeof_field));
+	WARN_ON_ONCE(MAX_SIZEOF_DS < (12 * ds_cfg.sizeof_ptr_field));
 }
 
 void __cpuinit ds_init_intel(struct cpuinfo_x86 *c)
