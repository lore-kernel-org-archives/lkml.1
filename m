Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab0BXIIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 03:08:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:58645 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763Ab0BXIIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 03:08:23 -0500
Date: Wed, 24 Feb 2010 08:07:57 GMT
From: tip-bot for Jacob Pan <jacob.jun.pan@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jacob.jun.pan@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jacob.jun.pan@intel.com, tglx@linutronix.de
In-Reply-To: <43F901BD926A4E43B106BF17856F07559FB80D09@orsmsx508.amr.corp.intel.com>
References: <43F901BD926A4E43B106BF17856F07559FB80D09@orsmsx508.amr.corp.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mrst] x86, mrst: Add dummy legacy pic to platform setup
Message-ID: <tip-5b78b6724a405d4b649db53f7aac28c930c89640@git.kernel.org>
Git-Commit-ID: 5b78b6724a405d4b649db53f7aac28c930c89640
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 24 Feb 2010 08:08:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5b78b6724a405d4b649db53f7aac28c930c89640
Gitweb:     http://git.kernel.org/tip/5b78b6724a405d4b649db53f7aac28c930c89640
Author:     Jacob Pan <jacob.jun.pan@intel.com>
AuthorDate: Fri, 12 Feb 2010 02:29:11 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 23 Feb 2010 23:15:19 -0800

x86, mrst: Add dummy legacy pic to platform setup

Moorestown has no legacy PIC; point it to the null legacy PIC.

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
LKML-Reference: <43F901BD926A4E43B106BF17856F07559FB80D09@orsmsx508.amr.corp.intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/mrst.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/mrst.c b/arch/x86/kernel/mrst.c
index 3b7078a..bdf9b17 100644
--- a/arch/x86/kernel/mrst.c
+++ b/arch/x86/kernel/mrst.c
@@ -12,6 +12,9 @@
 #include <linux/init.h>
 
 #include <asm/setup.h>
+#include <asm/mrst.h>
+#include <asm/io.h>
+#include <asm/i8259.h>
 
 /*
  * Moorestown specific x86_init function overrides and early setup
@@ -21,4 +24,6 @@ void __init x86_mrst_early_setup(void)
 {
 	x86_init.resources.probe_roms = x86_init_noop;
 	x86_init.resources.reserve_resources = x86_init_noop;
+
+	legacy_pic = &null_legacy_pic;
 }
