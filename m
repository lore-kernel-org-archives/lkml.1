Return-Path: <linux-kernel-owner+w=401wt.eu-S1759239AbYCZUgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239AbYCZUgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 16:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755361AbYCZUgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 16:36:13 -0400
Received: from mail.bencastricum.nl ([213.84.203.196]:57689 "EHLO
	bencastricum.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429AbYCZUgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 16:36:12 -0400
X-Greylist: delayed 804 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Mar 2008 16:36:11 EDT
Message-ID: <001701c88f7f$1e2b6c80$0602a8c0@links>
From: "Ben Castricum" <lk08@bencastricum.nl>
To: <linux-kernel@vger.kernel.org>
Subject: [TRIVIAL PATCH] Microcode: show results on success too plus fix typo 
Date: Wed, 26 Mar 2008 21:22:25 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Show a bit more info when updating microcode. It used to be there but 
no with DEBUG unset makes it very silent.

This is my first patch, please let me know if I did anything wrong.

Signed-off-by: Ben Castricum <lk08@bencastricum.nl>

diff --git a/arch/x86/kernel/microcode.c b/arch/x86/kernel/microcode.c
index f2702d0..ca1fd52 100644
--- a/arch/x86/kernel/microcode.c
+++ b/arch/x86/kernel/microcode.c
@@ -336,11 +336,11 @@ static void apply_microcode(int cpu)

  spin_unlock_irqrestore(&microcode_update_lock, flags);
  if (val[1] != uci->mc->hdr.rev) {
-  printk(KERN_ERR "microcode: CPU%d updated from revision "
+  printk(KERN_ERR "microcode: CPU%d update from revision "
    "0x%x to 0x%x failed\n", cpu_num, uci->rev, val[1]);
   return;
  }
- pr_debug("microcode: CPU%d updated from revision "
+ printk(KERN_INFO "microcode: CPU%d updated from revision "
         "0x%x to 0x%x, date = %08x \n",
         cpu_num, uci->rev, val[1], uci->mc->hdr.date);
  uci->rev = val[1];

