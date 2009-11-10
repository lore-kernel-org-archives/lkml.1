Return-Path: <linux-kernel-owner+w=401wt.eu-S1755903AbZKJEwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbZKJEwN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 23:52:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755002AbZKJEwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 23:52:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:38719 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940AbZKJEwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 23:52:11 -0500
Date: Tue, 10 Nov 2009 04:51:39 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andreas.herrmann3@amd.com, tglx@linutronix.de, mingo@elte.hu,
       borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andreas.herrmann3@amd.com, tglx@linutronix.de, borislav.petkov@amd.com,
       mingo@elte.hu
In-Reply-To: <20091029134552.GC30802@alberich.amd.com>
References: <20091029134552.GC30802@alberich.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, amd-ucode: Check UCODE_MAGIC before loading the container file
Message-ID: <tip-506f90eeae682dc96c11c7aefac0262b3a560b49@git.kernel.org>
Git-Commit-ID: 506f90eeae682dc96c11c7aefac0262b3a560b49
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  506f90eeae682dc96c11c7aefac0262b3a560b49
Gitweb:     http://git.kernel.org/tip/506f90eeae682dc96c11c7aefac0262b3a560b49
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Thu, 29 Oct 2009 14:45:52 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Nov 2009 05:46:09 +0100

x86, amd-ucode: Check UCODE_MAGIC before loading the container file

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
LKML-Reference: <20091029134552.GC30802@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/microcode_amd.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 366baa1..f4c538b 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -317,6 +317,12 @@ static enum ucode_state request_microcode_fw(int cpu, struct device *device)
 		return UCODE_NFOUND;
 	}
 
+	if (*(u32 *)firmware->data != UCODE_MAGIC) {
+		printk(KERN_ERR "microcode: invalid UCODE_MAGIC (0x%08x)\n",
+		       *(u32 *)firmware->data);
+		return UCODE_ERROR;
+	}
+
 	ret = generic_load_microcode(cpu, firmware->data, firmware->size);
 
 	release_firmware(firmware);
