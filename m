Return-Path: <linux-kernel-owner+w=401wt.eu-S1760776AbYCGLGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760776AbYCGLGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 06:06:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756354AbYCGLGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 06:06:06 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:53712 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756012AbYCGLGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 06:06:06 -0500
Date: Fri, 7 Mar 2008 14:05:12 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] signals-do_tkill-dont-use-tasklist_lock-comment
Message-ID: <20080307110512.GA9526@tv-sign.ru>
References: <20080307095813.GA8894@tv-sign.ru> <20080307105025.GB20000@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080307105025.GB20000@infradead.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07, Christoph Hellwig wrote:
>
> On Fri, Mar 07, 2008 at 12:58:13PM +0300, Oleg Nesterov wrote:
> > Note that we don't return an error if lock_task_sighand() fails, we pretend the
> > task dies after receiving the signal. Otherwise, we should fight with the nasty
> > races with mt-exec without having any advantage.
> 
> This should be mentioned in a comment in the code.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/signal.c~2__COMMENT	2008-03-07 13:06:17.000000000 +0300
+++ 25/kernel/signal.c	2008-03-07 13:59:09.000000000 +0300
@@ -2201,6 +2201,10 @@ static int do_tkill(int tgid, int pid, i
 		/*
 		 * The null signal is a permissions and process existence
 		 * probe.  No signal is actually delivered.
+		 *
+		 * If lock_task_sighand() fails we pretend the task dies
+		 * after receiving the signal. The window is tiny, and the
+		 * signal is private anyway.
 		 */
 		if (!error && sig && lock_task_sighand(p, &flags)) {
 			error = specific_send_sig_info(sig, &info, p);

