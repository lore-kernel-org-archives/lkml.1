Return-Path: <linux-kernel-owner+w=401wt.eu-S1752990AbYIILdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990AbYIILdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 07:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919AbYIILdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 07:33:47 -0400
Received: from ns.miraclelinux.com ([219.118.163.66]:23834 "EHLO
	mail.miraclelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbYIILdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 07:33:46 -0400
Message-ID: <48C65F19.1080105@miraclelinux.com>
Date: Tue, 09 Sep 2008 20:33:45 +0900
From: Naohiro Ooiwa <nooiwa@miraclelinux.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] sysrq: Add enable_mask in sysrq_moom_op
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.1.294258, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2008.9.9.111018
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

I found a little mistake.

It is written in the Documentation/sysrq.txt that oom-killer is enable
when we set "64" in /proc/sys/kernel/sysrq.
The following is it.

<Documentation/sysrq.txt>

    Here is the list of possible values in /proc/sys/kernel/sysrq:
         64 - enable signalling of processes (term, kill, oom-kill)
                                                          ^^^^^^^^

but enable_mask is not in sysrq_moom_op.
Could you please check the following patch ?



Signed-off-by: Naohiro Ooiwa <nooiwa@miraclelinux.com>
---
 drivers/char/sysrq.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
index 8fdfe9c..2aa79ab 100644
--- a/drivers/char/sysrq.c
+++ b/drivers/char/sysrq.c
@@ -326,6 +326,7 @@ static struct sysrq_key_op sysrq_moom_op = {
 	.handler	= sysrq_handle_moom,
 	.help_msg	= "Full",
 	.action_msg	= "Manual OOM execution",
+	.enable_mask	= SYSRQ_ENABLE_SIGNAL,
 };

 static void sysrq_handle_kill(int key, struct tty_struct *tty)
-- 
1.5.4.1

