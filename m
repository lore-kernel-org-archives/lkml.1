Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbZJBVo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbZJBVo4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 17:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbZJBVo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 17:44:56 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:59780 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447AbZJBVoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 17:44:55 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] procfs: provide stack information for threads
References: <1238511505.364.61.camel@matrix> <20090401193135.GA12316@elte.hu>
	<1244146873.20012.6.camel@wall-e> <m2eipl7axx.fsf@igel.home>
X-Yow: Well, O.K.  I'll compromise with my principles because of
 EXISTENTIAL DESPAIR!
Date: Fri, 02 Oct 2009 23:44:56 +0200
In-Reply-To: <m2eipl7axx.fsf@igel.home> (Andreas Schwab's message of "Fri, 02
	Oct 2009 23:17:14 +0200")
Message-ID: <m2ws3djwrr.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That missed compat_do_execve.

Andreas.

>From 2e81a4ab8da611f340a536aaaccbb274bfa0de5c Mon Sep 17 00:00:00 2001
From: Andreas Schwab <schwab@linux-m68k.org>
Date: Fri, 2 Oct 2009 23:43:47 +0200
Subject: [PATCH] compat_do_execve: set current->stack_start as in do_execve

---
 fs/compat.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index d576b55..6c19040 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1532,6 +1532,8 @@ int compat_do_execve(char * filename,
 	if (retval < 0)
 		goto out;
 
+	current->stack_start = current->mm->start_stack;
+
 	/* execve succeeded */
 	current->fs->in_exec = 0;
 	current->in_execve = 0;
-- 
1.6.4.4


-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
