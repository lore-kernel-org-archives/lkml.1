Return-Path: <linux-kernel-owner+w=401wt.eu-S1756248AbZCTUEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbZCTUEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 16:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752803AbZCTUEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 16:04:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:53572 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560AbZCTUEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 16:04:06 -0400
Date: Fri, 20 Mar 2009 20:03:26 GMT
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       ajb.stxsl@googlemail.com, bzolnier@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       ajb.stxsl@googlemail.com, bzolnier@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <200903202100.30789.bzolnier@gmail.com>
References: <200903202100.30789.bzolnier@gmail.com>
Subject: [tip:x86/apic] x86: fix IO APIC resource allocation error message
Message-ID: <tip-04c93ce4991fce731dab346d03964504339347db@git.kernel.org>
Git-Commit-ID: 04c93ce4991fce731dab346d03964504339347db
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 20 Mar 2009 20:03:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  04c93ce4991fce731dab346d03964504339347db
Gitweb:     http://git.kernel.org/tip/04c93ce4991fce731dab346d03964504339347db
Author:     Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
AuthorDate: Fri, 20 Mar 2009 21:02:55 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 Mar 2009 21:02:55 +0100

x86: fix IO APIC resource allocation error message

Impact: fix incorrect error message

- IO APIC resource allocation error message contains one too many "be".

- Print the error message iff there are IO APICs in the system.

I've seen this error message for some time on my x86-32 laptop...

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Bartlett <ajb.stxsl@googlemail.com>
LKML-Reference: <200903202100.30789.bzolnier@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/io_apic.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 42cdc78..d882c03 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -4130,9 +4130,12 @@ static int __init ioapic_insert_resources(void)
 	struct resource *r = ioapic_resources;
 
 	if (!r) {
-		printk(KERN_ERR
-		       "IO APIC resources could be not be allocated.\n");
-		return -1;
+		if (nr_ioapics > 0) {
+			printk(KERN_ERR
+				"IO APIC resources couldn't be allocated.\n");
+			return -1;
+		}
+		return 0;
 	}
 
 	for (i = 0; i < nr_ioapics; i++) {
