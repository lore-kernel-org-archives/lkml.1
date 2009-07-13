Return-Path: <linux-kernel-owner+w=401wt.eu-S1756588AbZGMQ6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588AbZGMQ6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 12:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756558AbZGMQ6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 12:58:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:36626 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756537AbZGMQ6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 12:58:20 -0400
Date: Mon, 13 Jul 2009 16:57:53 GMT
From: tip-bot for Rakib Mullick <rakib.mullick@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rakib.mullick@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rakib.mullick@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <b9df5fa10907120407p6b4f67dtf4d563155488188a@mail.gmail.com>
References: <b9df5fa10907120407p6b4f67dtf4d563155488188a@mail.gmail.com>
Subject: [tip:x86/urgent] x86, apic: Fix false positive section mismatch in numaq_32.c
Message-ID: <tip-7473727be884293c8171775a148e1d174d1606e6@git.kernel.org>
Git-Commit-ID: 7473727be884293c8171775a148e1d174d1606e6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 13 Jul 2009 16:57:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7473727be884293c8171775a148e1d174d1606e6
Gitweb:     http://git.kernel.org/tip/7473727be884293c8171775a148e1d174d1606e6
Author:     Rakib Mullick <rakib.mullick@gmail.com>
AuthorDate: Sun, 12 Jul 2009 17:07:19 +0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 13 Jul 2009 11:03:27 +0200

x86, apic: Fix false positive section mismatch in numaq_32.c

The variable apic_numaq placed in noninit section references the
function wakeup_secondary_cpu_via_nmi(), which is in __cpuinit
section. Thus causes a section mismatch warning. To avoid such
mismatch we mark apic_numaq as __refdata.

We were warned by the following warning:

  WARNING: arch/x86/kernel/built-in.o(.data+0x932c): Section mismatch in
  reference from the variable apic_numaq to the function
  .cpuinit.text:wakeup_secondary_cpu_via_nmi()

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
LKML-Reference: <b9df5fa10907120407p6b4f67dtf4d563155488188a@mail.gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/numaq_32.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index 533e59c..ca96e68 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -493,7 +493,8 @@ static void numaq_setup_portio_remap(void)
 		(u_long) xquad_portio, (u_long) num_quads*XQUAD_PORTIO_QUAD);
 }
 
-struct apic apic_numaq = {
+/* Use __refdata to keep false positive warning calm.	*/
+struct apic __refdata apic_numaq = {
 
 	.name				= "NUMAQ",
 	.probe				= probe_numaq,
