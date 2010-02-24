Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab0BXIHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 03:07:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:58598 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132Ab0BXIHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 03:07:15 -0500
Date: Wed, 24 Feb 2010 08:06:45 GMT
From: tip-bot for Jacob Pan <jacob.jun.pan@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jacob.jun.pan@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jacob.jun.pan@intel.com, tglx@linutronix.de
In-Reply-To: <43F901BD926A4E43B106BF17856F0755A318D3AA@orsmsx508.amr.corp.intel.com>
References: <43F901BD926A4E43B106BF17856F0755A318D3AA@orsmsx508.amr.corp.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mrst] x86, pic: Fix section mismatch in legacy pic
Message-ID: <tip-28a3c93d11212655ce0a9be977c405c703844164@git.kernel.org>
Git-Commit-ID: 28a3c93d11212655ce0a9be977c405c703844164
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 24 Feb 2010 08:06:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  28a3c93d11212655ce0a9be977c405c703844164
Gitweb:     http://git.kernel.org/tip/28a3c93d11212655ce0a9be977c405c703844164
Author:     Jacob Pan <jacob.jun.pan@intel.com>
AuthorDate: Tue, 23 Feb 2010 02:03:31 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 23 Feb 2010 23:13:19 -0800

x86, pic: Fix section mismatch in legacy pic

Move legacy_pic chip dummy functions out of init section as they might
be referenced at run time.

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
LKML-Reference: <43F901BD926A4E43B106BF17856F0755A318D3AA@orsmsx508.amr.corp.intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/i8259.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/i8259.c b/arch/x86/kernel/i8259.c
index 9bac681..fb725ee 100644
--- a/arch/x86/kernel/i8259.c
+++ b/arch/x86/kernel/i8259.c
@@ -371,9 +371,9 @@ static void init_8259A(int auto_eoi)
  * platforms, such as x86 MID.
  */
 
-static void __init legacy_pic_noop(void) { };
-static void __init legacy_pic_uint_noop(unsigned int unused) { };
-static void __init legacy_pic_int_noop(int unused) { };
+static void legacy_pic_noop(void) { };
+static void legacy_pic_uint_noop(unsigned int unused) { };
+static void legacy_pic_int_noop(int unused) { };
 
 static struct irq_chip dummy_pic_chip  = {
 	.name = "dummy pic",
