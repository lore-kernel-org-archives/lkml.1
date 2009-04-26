Return-Path: <linux-kernel-owner+w=401wt.eu-S1754685AbZDZQnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbZDZQnZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 12:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753485AbZDZQnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 12:43:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:43956 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994AbZDZQnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 12:43:13 -0400
Date: Sun, 26 Apr 2009 16:42:32 GMT
From: tip-bot for Ming Lei <tom.leiming@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, tom.leiming@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, tom.leiming@gmail.com, mingo@elte.hu
In-Reply-To: <1240585806-5744-1-git-send-email-tom.leiming@gmail.com>
References: <1240585806-5744-1-git-send-email-tom.leiming@gmail.com>
Subject: [tip:core/urgent] locking: Documentation: lockdep-design.txt, fix note of state bits
Message-ID: <tip-992d7ced75322307035a0e94074eb7188612a680@git.kernel.org>
Git-Commit-ID: 992d7ced75322307035a0e94074eb7188612a680
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 26 Apr 2009 16:42:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  992d7ced75322307035a0e94074eb7188612a680
Gitweb:     http://git.kernel.org/tip/992d7ced75322307035a0e94074eb7188612a680
Author:     Ming Lei <tom.leiming@gmail.com>
AuthorDate: Fri, 24 Apr 2009 23:10:06 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 26 Apr 2009 18:21:24 +0200

locking: Documentation: lockdep-design.txt, fix note of state bits

>From source code of get_usage_char(), the previous note is not correct,
so fix it.

static char get_usage_char(struct lock_class *class, enum lock_usage_bit bit)
{
	char c = '.';

	if (class->usage_mask & lock_flag(bit + 2))/*LOCK_ENABLED_##STATE*/
		c = '+';
	if (class->usage_mask & lock_flag(bit)) {/*LOCK_USED_IN_##STATE*/
		c = '-';
		if (class->usage_mask & lock_flag(bit + 2))
			c = '?';
	}

	return c;
}

note:

1) The 'bit' parameter always is passed as  LOCK_USED_IN_##STATE
   or LOCK_USED_IN_##STATE_READ , from get_usage_chars().

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
LKML-Reference: <1240585806-5744-1-git-send-email-tom.leiming@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/lockdep-design.txt |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/lockdep-design.txt b/Documentation/lockdep-design.txt
index 938ea22..e20d913 100644
--- a/Documentation/lockdep-design.txt
+++ b/Documentation/lockdep-design.txt
@@ -54,9 +54,9 @@ locking error messages, inside curlies. A contrived example:
 The bit position indicates STATE, STATE-read, for each of the states listed
 above, and the character displayed in each indicates:
 
-   '.'  acquired while irqs disabled
-   '+'  acquired in irq context
-   '-'  acquired with irqs enabled
+   '.'  acquired while irqs disabled and not in irq context
+   '-'  acquired in irq context
+   '+'  acquired with irqs enabled
    '?'  acquired in irq context with irqs enabled.
 
 Unused mutexes cannot be part of the cause of an error.
