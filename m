Return-Path: <linux-kernel-owner+w=401wt.eu-S1758370AbZE0CLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758370AbZE0CLu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 22:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754846AbZE0CLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 22:11:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754577AbZE0CLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 22:11:43 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 7/X] ptrace: mv task->parent ptrace_task->pt_tracer
In-Reply-To: Oleg Nesterov's message of  Monday, 25 May 2009 23:59:03 +0200 <20090525215903.GA9113@redhat.com>
References: <20090525000016.GA2239@redhat.com>
	<20090525215903.GA9113@redhat.com>
X-Shopping-List: (1) Transparent prescriptions
   (2) Pyrotechnical erosion defusers
   (3) Geriatric fruit
   (4) Resurgent prestigious eruptions
Message-Id: <20090527021131.4778BFC36B@magilla.sf.frob.com>
Date: Tue, 26 May 2009 19:11:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But is the current code correct? If we are not traced any longer
> si_pid/si_uid are not necessary right either, we should calculate them
> before ptrace_stop(), no?

Yes, though nothing really cares about these values for such cases.
(It's really only there for dealing with debuggers that were written
before PTRACE_SETSIGINFO was invented.)

It's probably best now to clean this up so that this logic is
applied in the tracer causing the resumption rather than in the
tracee.  i.e. do it in ptrace_resume() and ptrace_detach().  It's
only now with your exhaustive clean-up of ptrace that we will get
really confident that we are covering all the possible paths that
can change ->exit_code and then resume it.  (I think those two are
it, but you should check my logic.)


Thanks,
Roland
