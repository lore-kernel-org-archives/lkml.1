Return-Path: <linux-kernel-owner+w=401wt.eu-S1752158AbZL3JXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbZL3JXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 04:23:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbZL3JXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 04:23:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58716 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbZL3JXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 04:23:53 -0500
Date: Wed, 30 Dec 2009 10:23:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Liming Wang <liming.wang@windriver.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] perf tools: remove pid option from stat
Message-ID: <20091230092327.GA10486@elte.hu>
References: <1262075829-16257-1-git-send-email-liming.wang@windriver.com>
 <1262075829-16257-2-git-send-email-liming.wang@windriver.com>
 <1262088251.7135.131.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262088251.7135.131.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2009-12-29 at 16:37 +0800, Liming Wang wrote:
> > pid option is useless for stat, so remove it.
> 
> Hmm, it shouldn't be.. and instead of removing it I would suggesting fixing 
> this.

Yes. For exampe something like:

  perf stat --repeat 10 --pid $(pidof firefox) sleep 1

Should show firefox's resource usage sampled over 10 seconds.

If this doesnt work it should be fixed. Plus i suspect we should allow:

  perf stat --pid $(pidof firefox)

to run until Ctrl-C - like perf record allows.

	Ingo
