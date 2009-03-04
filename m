Return-Path: <linux-kernel-owner+w=401wt.eu-S1758243AbZCDUDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243AbZCDUDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 15:03:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757878AbZCDUCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 15:02:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:33025 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757867AbZCDUCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 15:02:23 -0500
Date: Wed, 4 Mar 2009 20:01:00 GMT
From: Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <49AE4922.605@kernel.org>
References: <49AE4922.605@kernel.org>
Subject: [tip:x86/mm] x86: reserve exact size of mptable
Message-ID: <tip-f62432395ec54e93f113091bcb2e2017eeed7683@git.kernel.org>
Git-Commit-ID: f62432395ec54e93f113091bcb2e2017eeed7683
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 04 Mar 2009 20:01:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f62432395ec54e93f113091bcb2e2017eeed7683
Gitweb:     http://git.kernel.org/tip/f62432395ec54e93f113091bcb2e2017eeed7683
Author:     "Yinghai Lu" <yinghai@kernel.org>
AuthorDate: Wed, 4 Mar 2009 01:25:54 -0800
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 Mar 2009 20:55:04 +0100

x86: reserve exact size of mptable

Impact: save a bit of RAM

Get the exact size for the reserve_bootmem() call.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <49AE4922.605@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/mpparse.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index ae9060c..e819240 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -716,10 +716,10 @@ static int __init smp_scan_config(unsigned long base, unsigned long length,
 
 			if (!reserve)
 				return 1;
-			reserve_bootmem_generic(virt_to_phys(mpf), PAGE_SIZE,
+			reserve_bootmem_generic(virt_to_phys(mpf), sizeof(*mpf),
 					BOOTMEM_DEFAULT);
 			if (mpf->physptr) {
-				unsigned long size = PAGE_SIZE;
+				unsigned long size = get_mpc_size(mpf->physptr);
 #ifdef CONFIG_X86_32
 				/*
 				 * We cannot access to MPC table to compute
