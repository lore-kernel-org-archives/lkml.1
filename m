Return-Path: <linux-kernel-owner+w=401wt.eu-S1758337AbZCMCho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758337AbZCMCho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 22:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757651AbZCMCgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 22:36:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:52533 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757493AbZCMCgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 22:36:03 -0400
Date: Fri, 13 Mar 2009 02:34:44 GMT
From: Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49B87C0A.4010105@kernel.org>
References: <49B87C0A.4010105@kernel.org>
Subject: [tip:x86/mtrr] x86: print out mtrr_range_state when user specify size
Message-ID: <tip-c1ab7e93c6ddf8a068719b97b7e26c3d8eba7c32@git.kernel.org>
Git-Commit-ID: c1ab7e93c6ddf8a068719b97b7e26c3d8eba7c32
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 02:34:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c1ab7e93c6ddf8a068719b97b7e26c3d8eba7c32
Gitweb:     http://git.kernel.org/tip/c1ab7e93c6ddf8a068719b97b7e26c3d8eba7c32
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Wed, 11 Mar 2009 20:05:46 -0700
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 02:52:18 +0100

x86: print out mtrr_range_state when user specify size

Impact: print more debug info

Keep it consistent with autodetect version.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <49B87C0A.4010105@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/mtrr/main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 236a401..311a473 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -1424,6 +1424,8 @@ static int __init mtrr_cleanup(unsigned address_bits)
 
 		if (!result[i].bad) {
 			set_var_mtrr_all(address_bits);
+			printk(KERN_DEBUG "New variable MTRRs\n");
+			print_out_mtrr_range_state();
 			return 1;
 		}
 		printk(KERN_INFO "invalid mtrr_gran_size or mtrr_chunk_size, "
