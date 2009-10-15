Return-Path: <linux-kernel-owner+w=401wt.eu-S932343AbZJOKhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343AbZJOKhN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 06:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757324AbZJOKhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 06:37:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59983 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754309AbZJOKhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 06:37:11 -0400
Date: Thu, 15 Oct 2009 12:36:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
       peterz@infradead.org, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de
Subject: Re: [tip:perf/core] tracing/filters: Refactor subsystem filter code
Message-ID: <20091015103614.GA20291@elte.hu>
References: <4AD69502.8060903@cn.fujitsu.com> <tip-fce29d15b59245597f7f320db4a9f2be0f5fb512@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-fce29d15b59245597f7f320db4a9f2be0f5fb512@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Li Zefan <lizf@cn.fujitsu.com> wrote:

> Commit-ID:  fce29d15b59245597f7f320db4a9f2be0f5fb512
> Gitweb:     http://git.kernel.org/tip/fce29d15b59245597f7f320db4a9f2be0f5fb512
> Author:     Li Zefan <lizf@cn.fujitsu.com>
> AuthorDate: Thu, 15 Oct 2009 11:20:34 +0800
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu, 15 Oct 2009 11:35:22 +0200

the filter variable was not initialized here - i have applied the fix 
below.

	Ingo

Index: linux/kernel/trace/trace_events_filter.c
===================================================================
--- linux.orig/kernel/trace/trace_events_filter.c
+++ linux/kernel/trace/trace_events_filter.c
@@ -1230,8 +1230,8 @@ static int replace_system_preds(struct e
 				struct filter_parse_state *ps,
 				char *filter_string)
 {
+	struct event_filter *filter = system->filter;
 	struct ftrace_event_call *call;
-	struct event_filter *filter;
 	int err;
 	bool fail = true;
 
