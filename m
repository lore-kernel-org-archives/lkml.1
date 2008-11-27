Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbYK0OvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbYK0OvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 09:51:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbYK0OvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 09:51:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35810 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbYK0OvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 09:51:16 -0500
Date: Thu, 27 Nov 2008 15:51:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, srostedt@redhat.com,
       sandmann@daimi.au.dk, linux-kernel@vger.kernel.org,
       viro@ZenIV.linux.org.uk
Subject: Re: [PATCH 2/2] tracing: identify which executable object the
	userspace address belongs to
Message-ID: <20081127145102.GC4672@elte.hu>
References: <1227353328-16104-1-git-send-email-edwintorok@gmail.com> <1227353328-16104-3-git-send-email-edwintorok@gmail.com> <y0my6z798de.fsf@ton.toronto.redhat.com> <1227782505.4454.1393.camel@twins> <20081127124851.GC23480@redhat.com> <492E9AB2.9030202@gmail.com> <20081127141054.GB25657@elte.hu> <492EAE65.1040903@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <492EAE65.1040903@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Török Edwin <edwintorok@gmail.com> wrote:

> Thanks. I can move on to the lock latency tracing ;)

that's a bit more contentious ...

> I'll send out a draft of tracepoints that I would need to trace lock 
> latency. I'll try to put them in same place as lockstat (but not 
> necesarely depending on lockstat being enabled).

> Or I could add the tracepoints inside lockstat (now that it has 
> contend with points feature), and use the information already 
> gathered by lockstat, but augment it with finer grained counts per 
> kernel/user stacktrace. (again there would be an ftrace plugin that 
> would register with the tracepoints, and show the per stacktrace 
> statistic in /sys/kernel/debug/tracing/trace).

yes. The less intrusive your patch is, the more you utilize and 
generalize existing facilities, the better. You could split the 
Kconfig of LOCKSTAT into two bits: LOCKSTAT (core) and LOCKSTAT_PROC, 
where the proc bits are enabled separately.

Your tracing approach could then reuse much of core LOCKSTAT (without 
even touching the code) and just plain "select LOCKSTAT" - without 
creating /proc/lockdep_stats.

Peter, what do you think?

	Ingo
