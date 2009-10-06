Return-Path: <linux-kernel-owner+w=401wt.eu-S1757340AbZJFN2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbZJFN2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 09:28:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757299AbZJFN2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 09:28:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33285 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756141AbZJFN2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 09:28:08 -0400
Date: Tue, 6 Oct 2009 09:27:32 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       rostedt@goodmis.org, lizf@cn.fujitsu.com
Subject: Re: [PATCH 2/3] perf trace: Update eval_flag() flags array to
	match interrupt.h
Message-ID: <20091006132732.GA14978@infradead.org>
References: <1254808849-7829-1-git-send-email-tzanussi@gmail.com> <1254808849-7829-3-git-send-email-tzanussi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254808849-7829-3-git-send-email-tzanussi@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 01:00:48AM -0500, Tom Zanussi wrote:
> Add missing BLOCK_IOPOLL_SOFTIRQ entry.

Nothing against your patch which is good for the short term, but the
existance of this code is a major design flaw.  The trace events are
supposed to be self describing and having them duplicated in the trace
tool means either we're not using that self-description or it's not
good enough to be used.

We'll soon add a lot more flags (e.g. my xfs tracing patch if I can ever
get the formal maintainer to review it will add various), and it was
also made pretty clear that perf while packaged with the kernel should
work independent of the actual kernel version, e.g. one perf binary
should work with older host kernels too which might have very different
flag values.

