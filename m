Return-Path: <linux-kernel-owner+w=401wt.eu-S1757708AbZE1Djh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708AbZE1Djh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 23:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbZE1Dja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 23:39:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41068 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946AbZE1Dj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 23:39:29 -0400
Date: Thu, 28 May 2009 05:35:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 7/X] ptrace: mv task->parent ptrace_task->pt_tracer
Message-ID: <20090528033500.GA24347@redhat.com>
References: <20090525000016.GA2239@redhat.com> <20090525215903.GA9113@redhat.com> <20090527021131.4778BFC36B@magilla.sf.frob.com> <20090527224140.GC6770@redhat.com> <20090527230700.11F2DFC2BD@magilla.sf.frob.com> <20090527235936.GB12216@redhat.com> <20090528003256.86E4EFC2BD@magilla.sf.frob.com> <20090528025407.GA22182@redhat.com> <20090528031907.E179FFC2BD@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090528031907.E179FFC2BD@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27, Roland McGrath wrote:
>
> If you're going to zero out fields in a corner case, I think you should
> zero si_code too

Well, SI_USER == 0, so si_code is zero. And SI_USER looks more
consistent to me, because

> so it's consistent with what collect_signal() produces
> when a signal is posted with OOM for the sigq allocation.

perhaps it is better to change collect_signal() to set SI_USER ?
Note that __send_signal() user SI_USER, not zero in is_si_special()
case.

> (It is likely nobody will ever see this path anyway,
> since we'll probably merge the clean-up that replaces it before any release
> that uses this series at all.)

Yes!

But without some fix, I was really puzzled how I can make any
progress now.

You never know which change will take most time...

Oleg.

