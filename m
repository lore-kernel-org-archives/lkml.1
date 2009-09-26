Return-Path: <linux-kernel-owner+w=401wt.eu-S1752118AbZIZKLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbZIZKLR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 06:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbZIZKLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 06:11:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33941 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbZIZKLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 06:11:15 -0400
Subject: Re: [tip:tracing/core] tracing/filters: Provide basic regex support
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       tzanussi@gmail.com, lizf@cn.fujitsu.com, fweisbec@gmail.com,
       tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-1889d20922d14a97b2099fa4d47587217c0ba48b@git.kernel.org>
References: <tip-1889d20922d14a97b2099fa4d47587217c0ba48b@git.kernel.org>
Content-Type: text/plain
Date: Sat, 26 Sep 2009 06:10:05 -0400
Message-Id: <1253959805.12145.95.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-25 at 06:19 +0000, tip-bot for Frederic Weisbecker
wrote:
> Commit-ID:  1889d20922d14a97b2099fa4d47587217c0ba48b
> Gitweb:     http://git.kernel.org/tip/1889d20922d14a97b2099fa4d47587217c0ba48b
> Author:     Frederic Weisbecker <fweisbec@gmail.com>
> AuthorDate: Thu, 24 Sep 2009 21:10:44 +0200
> Committer:  Frederic Weisbecker <fweisbec@gmail.com>
> CommitDate: Thu, 24 Sep 2009 21:39:27 +0200
> 
> tracing/filters: Provide basic regex support
> 
> This patch provides basic support for regular expressions in filters.
> 
> It supports the following types of regexp:
> 
> - *match_beginning
> - *match_middle*
> - match_end*
> - !don't match
> 
> Example:
> 	cd /debug/tracing/events/bkl/lock_kernel
> 	echo 'file == "*reiserfs*"' > filter
> 	echo 1 > enable

Darn! I need to keep up with my email more. Someone asked me at my
ftrace tutorial if the filters can take regex's.  I told them that I
don't think so. Of course, my tutorial was on 2.6.31 so I was still
correct. But it would have been nice if I told them that it will in
2.6.32 or 33.

-- Steve

> 
>            gedit-4941  [000]   457.735437: lock_kernel: depth: 0, fs/reiserfs/namei.c:334 reiserfs_lookup()
>      sync_supers-227   [001]   461.379985: lock_kernel: depth: 0, fs/reiserfs/super.c:69 reiserfs_sync_fs()
>      sync_supers-227   [000]   461.383096: lock_kernel: depth: 0, fs/reiserfs/journal.c:1069 flush_commit_list()
>       reiserfs/1-1369  [001]   461.479885: lock_kernel: depth: 0, fs/reiserfs/journal.c:3509 flush_async_commits()
> 
> Every string is now handled as a regexp in the filter framework, which
> helps to factorize the code for handling both simple strings and
> regexp comparisons.
> 
> (The regexp parsing code has been wildly cherry picked from ftrace.c
> written by Steve.)
> 
> v2: Simplify the whole and drop the filter_regex file


