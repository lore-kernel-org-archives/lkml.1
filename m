Return-Path: <linux-kernel-owner+w=401wt.eu-S1758706AbYDMLyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706AbYDMLyi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 07:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbYDMLya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 07:54:30 -0400
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:35978 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1752461AbYDMLya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 07:54:30 -0400
X-Spam-Check-By: mail.local.tull.net
From: Nick Andrew <nick@nick-andrew.net>
Subject: [PATCH 2/2] printk: Remember the message level for multi-line output
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       joe@perches.com
Date: Sun, 13 Apr 2008 21:54:20 +1000
Message-ID: <20080413115351.29086.40504.stgit@marcab.local.tull.net>
In-Reply-To: <20080413115152.29086.37845.stgit@marcab.local.tull.net>
References: <20080413115152.29086.37845.stgit@marcab.local.tull.net>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk: Remember the message level for multi-line output

    printk(KERN_ALERT "Danger Will Robinson!\nAlien Approaching!\n");

At present this will result in one message at ALERT level and one
at the current default message loglevel (e.g. WARNING). This is
non-intuitive.

Modify vprintk() to remember the message loglevel each time it
is specified and use it for subsequent lines of output which do
not specify one, within the same call to printk.

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 kernel/printk.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)


diff --git a/kernel/printk.c b/kernel/printk.c
index bca9359..5c97eb1 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -716,8 +716,6 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 				current_log_level = p[1] - '0';
 				p += 3;
 				printed_len -= 3;
-			} else {
-				current_log_level = default_message_loglevel;
 			}
 
 			/* Always output the token */

