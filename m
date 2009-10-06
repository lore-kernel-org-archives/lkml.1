Return-Path: <linux-kernel-owner+w=401wt.eu-S1757652AbZJFPTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652AbZJFPTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 11:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757562AbZJFPTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 11:19:39 -0400
Received: from mail-ew0-f217.google.com ([209.85.219.217]:41598 "EHLO
	mail-ew0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757498AbZJFPTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 11:19:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=W7LSjVdCCPKGD6wkW2L1XMsZnYssP12mBKBK1MXDGHICQn3Dzjjc8UeHJ3iEruu/uc
         0w36WwCCtT/BZ5LjGZ79FGx9RUccnqYFWAtFLvc9Zf6Cv8ABYNMIb0ZJxAQJpIt65QlQ
         aCxDSPmMYWMPkcGcrXROiXDI76ZNNlHSivRzY=
Date: Tue, 6 Oct 2009 17:19:00 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, rostedt@goodmis.org, lizf@cn.fujitsu.com
Subject: Re: [PATCH 2/3] perf trace: Update eval_flag() flags array to
	match interrupt.h
Message-ID: <20091006151858.GB5152@nowhere>
References: <1254808849-7829-1-git-send-email-tzanussi@gmail.com> <1254808849-7829-3-git-send-email-tzanussi@gmail.com> <20091006132732.GA14978@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006132732.GA14978@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 09:27:32AM -0400, Christoph Hellwig wrote:
> On Tue, Oct 06, 2009 at 01:00:48AM -0500, Tom Zanussi wrote:
> > Add missing BLOCK_IOPOLL_SOFTIRQ entry.
> 
> Nothing against your patch which is good for the short term, but the
> existance of this code is a major design flaw.  The trace events are
> supposed to be self describing and having them duplicated in the trace
> tool means either we're not using that self-description or it's not
> good enough to be used.
> 
> We'll soon add a lot more flags (e.g. my xfs tracing patch if I can ever
> get the formal maintainer to review it will add various), and it was
> also made pretty clear that perf while packaged with the kernel should
> work independent of the actual kernel version, e.g. one perf binary
> should work with older host kernels too which might have very different
> flag values.
> 


Yeah. We may want to do that by including trace/events/irq.h
and then use the show_softirq_name() macro defined there.

The rest of the header can be wrapped through no-op macros and
stub includes.

