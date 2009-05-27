Return-Path: <linux-kernel-owner+w=401wt.eu-S1759427AbZE0X1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427AbZE0X1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 19:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753746AbZE0X1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 19:27:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47668 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbZE0X1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 19:27:37 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ptrace: do_notify_parent_cldstop: fix the wrong
	->nsproxy usage
In-Reply-To: Oleg Nesterov's message of  Thursday, 28 May 2009 01:12:48 +0200 <20090527231248.GB10032@redhat.com>
References: <20090525185502.GA20781@redhat.com>
	<20090526210514.C1C91FC2BD@magilla.sf.frob.com>
	<20090527213222.GA6770@redhat.com>
	<20090527222337.0507EFC36B@magilla.sf.frob.com>
	<20090527231248.GB10032@redhat.com>
X-Windows: you'll envy the dead.
Message-Id: <20090527232617.2FE48FC2BD@magilla.sf.frob.com>
Date: Wed, 27 May 2009 16:26:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No, task_pid_vnr(current) in ptrace_notify() is not right. If the tracer
> does PTRACE_GETSIGINFO it gets the wrong .si_pid.

I don't follow.  PTRACE_GETSIGINFO gets the tracee's siginfo_t data--modulo
32/64 conversions it's the data structure the tracee process sees on its
stack when running a handler.  It's not like a signal sent into the
tracer's queue (like SIGCHLD in do_notify_*), where the kernel doing
translation to the tracer's context makes sense.  It's more like some
memory you read from the tracee.


Thanks,
Roland
