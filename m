Return-Path: <linux-kernel-owner+w=401wt.eu-S1756504AbZE1Oew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbZE1Oew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 10:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752578AbZE1Oep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 10:34:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56697 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbZE1Oeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 10:34:44 -0400
Subject: Re: [PATCH] tracing/lockdep: report the time waited for a lock
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.0905281032010.27708@gandalf.stny.rr.com>
References: <1238975373-15739-1-git-send-email-fweisbec@gmail.com>
	 <alpine.DEB.2.00.0905281032010.27708@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Thu, 28 May 2009 16:34:43 +0200
Message-Id: <1243521283.6645.0.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-28 at 10:32 -0400, Steven Rostedt wrote:

> > +	TP_STRUCT__entry(
> > +		__field(const char *, name)
> > +		__field(unsigned long, wait_usec)
> > +		__field(unsigned long, wait_nsec_rem)
> > +	),
> > +	TP_fast_assign(
> > +		__entry->name = lock->name;
> > +		__entry->wait_nsec_rem = do_div(waittime, NSEC_PER_USEC);
> 
> I know this is already accepted, but can you move the do_div into the 
> print section.

please do. Just fold those wait_* fields into a single u64 nsec one.

