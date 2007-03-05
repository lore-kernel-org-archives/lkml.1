Return-Path: <linux-kernel-owner+w=401wt.eu-S1752781AbXCEQM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbXCEQM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 11:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbXCEQMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 11:12:55 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:21343 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778AbXCEQMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 11:12:55 -0500
Subject: (trivia) remove useless typecast around `jif' variable
From: Michael Tokarev <mjt@tls.msk.ru>
Message-Id: <20070305161251.AE2C97FAA@paltus.tls.msk.ru>
Date: Mon,  5 Mar 2007 19:12:51 +0300 (MSK)
To: undisclosed-recipients:;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

in fs/proc/proc_misc.c:show_stat() routine (which handles /proc/stat
file), there's a local variable named 'jif' of type unsigned long,
declared as following:

static int show_stat(struct seq_file *p, void *v)
{
        unsigned long jif;

But later on, it's explicitly casted to (unsigned long) in printf().
Remove the useless cast, to let the compiler to do the work for us
in case we'll want to use different type here (say, u64 or something).

Signed-Off-By: Michael Tokarev <mjt@tls.msk.ru>

--- linux-2.6.20/fs/proc/proc_misc.c.orig	2007-02-04 21:44:54.000000000 +0300
+++ linux-2.6.20/fs/proc/proc_misc.c	2007-03-05 19:06:09.000000000 +0300
@@ -521,15 +521,15 @@ static int show_stat(struct seq_file *p,
 	seq_printf(p,
 		"\nctxt %llu\n"
 		"btime %lu\n"
 		"processes %lu\n"
 		"procs_running %lu\n"
 		"procs_blocked %lu\n",
 		nr_context_switches(),
-		(unsigned long)jif,
+		jif,
 		total_forks,
 		nr_running(),
 		nr_iowait());
 
 	return 0;
 }
 
