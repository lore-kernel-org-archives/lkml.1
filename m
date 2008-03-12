Return-Path: <linux-kernel-owner+w=401wt.eu-S1753917AbYCLMeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbYCLMeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 08:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbYCLMeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 08:34:00 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:39759 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753822AbYCLMd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 08:33:58 -0400
Date: Wed, 12 Mar 2008 15:33:29 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] signals: document CLD_CONTINUED notification mechanics
Message-ID: <20080312123329.GA13481@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of small comments about how CLD_CONTINUED notification works.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/signal.c~2_DOC_NOTIFY	2008-03-12 13:29:42.000000000 +0300
+++ 25/kernel/signal.c	2008-03-12 15:16:52.000000000 +0300
@@ -630,6 +630,11 @@ static int prepare_signal(int sig, struc
 			why |= SIGNAL_CLD_STOPPED;
 
 		if (why) {
+			/*
+			 * The first thread which returns from finish_stop()
+			 * will take ->siglock, notice SIGNAL_CLD_MASK, and
+			 * notify its parent. See get_signal_to_deliver().
+			 */
 			signal->flags = why | SIGNAL_STOP_CONTINUED;
 			signal->group_stop_count = 0;
 			signal->group_exit_code = 0;
@@ -1652,7 +1657,7 @@ relock:
 	try_to_freeze();
 
 	spin_lock_irq(&sighand->siglock);
-
+	/* see prepare_signal(SIGCONT) */
 	if (unlikely(signal->flags & SIGNAL_CLD_MASK)) {
 		int why = (signal->flags & SIGNAL_STOP_CONTINUED)
 				? CLD_CONTINUED : CLD_STOPPED;

