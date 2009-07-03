Return-Path: <linux-kernel-owner+w=401wt.eu-S1754406AbZGCMsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406AbZGCMsB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 08:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758010AbZGCMq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 08:46:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:59994 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757785AbZGCMqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 08:46:25 -0400
Date: Fri, 3 Jul 2009 12:45:08 GMT
From: tip-bot for Rakib Mullick <rakib.mullick@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rakib.mullick@gmail.com, akpm@linux-foundation.org, tglx@linutronix.de,
       avi@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rakib.mullick@gmail.com, akpm@linux-foundation.org, tglx@linutronix.de,
       avi@redhat.com, mingo@elte.hu
In-Reply-To: <b9df5fa10907012240y356427b8ta4bd07f0efc6a049@mail.gmail.com>
References: <b9df5fa10907012240y356427b8ta4bd07f0efc6a049@mail.gmail.com>
Subject: [tip:x86/urgent] x86, kvm: Fix section mismatches in kvm.c
Message-ID: <tip-d3ac88157c1e9153f37cd2b9313117ae11735063@git.kernel.org>
Git-Commit-ID: d3ac88157c1e9153f37cd2b9313117ae11735063
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Jul 2009 12:45:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d3ac88157c1e9153f37cd2b9313117ae11735063
Gitweb:     http://git.kernel.org/tip/d3ac88157c1e9153f37cd2b9313117ae11735063
Author:     Rakib Mullick <rakib.mullick@gmail.com>
AuthorDate: Thu, 2 Jul 2009 11:40:36 +0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Jul 2009 14:34:22 +0200

x86, kvm: Fix section mismatches in kvm.c

The function paravirt_ops_setup() has been refering the
variable no_timer_check, which is a __initdata. Thus generates
the following warning. paravirt_ops_setup() function is called
from kvm_guest_init() which is a __init function. So to fix
this we mark paravirt_ops_setup as __init.

The sections-check output that warned us about this was:

   LD      arch/x86/built-in.o
  WARNING: arch/x86/built-in.o(.text+0x166ce): Section mismatch in
  reference from the function paravirt_ops_setup() to the variable
  .init.data:no_timer_check
  The function paravirt_ops_setup() references
  the variable __initdata no_timer_check.
  This is often because paravirt_ops_setup lacks a __initdata
  annotation or the annotation of no_timer_check is wrong.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Acked-by: Avi Kivity <avi@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <b9df5fa10907012240y356427b8ta4bd07f0efc6a049@mail.gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/kvm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index a78ecad..c664d51 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -200,7 +200,7 @@ static void kvm_leave_lazy_mmu(void)
 	state->mode = paravirt_get_lazy_mode();
 }
 
-static void paravirt_ops_setup(void)
+static void __init paravirt_ops_setup(void)
 {
 	pv_info.name = "KVM";
 	pv_info.paravirt_enabled = 1;
