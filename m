Return-Path: <linux-kernel-owner+w=401wt.eu-S1762589AbYBLKXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762589AbYBLKXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 05:23:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762457AbYBLKW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 05:22:27 -0500
Received: from sacred.ru ([62.205.161.221]:43661 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762432AbYBLKWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 05:22:25 -0500
Message-ID: <47B172B2.30507@openvz.org>
Date: Tue, 12 Feb 2008 13:19:30 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: [PATCH 1/3] Remove unused variable from send_signal()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 12 Feb 2008 13:19:24 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function doesn't change the ret's value and thus always
returns 0, with a single exception of returning -EAGAIN
explicitly.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---
 kernel/signal.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index cc45a6b..21d4751 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -661,7 +661,6 @@ static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
 			struct sigpending *signals)
 {
 	struct sigqueue * q = NULL;
-	int ret = 0;
 
 	/*
 	 * Deliver the signal to listening signalfds. This must be called
@@ -719,7 +718,7 @@ static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
 
 out_set:
 	sigaddset(&signals->signal, sig);
-	return ret;
+	return 0;
 }
 
 #define LEGACY_QUEUE(sigptr, sig) \
-- 
1.5.3.4

