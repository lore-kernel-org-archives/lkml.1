Return-Path: <linux-kernel-owner+w=401wt.eu-S1759360AbZE0WZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759360AbZE0WZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 18:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757996AbZE0WZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 18:25:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755042AbZE0WZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 18:25:13 -0400
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
In-Reply-To: Oleg Nesterov's message of  Wednesday, 27 May 2009 23:32:22 +0200 <20090527213222.GA6770@redhat.com>
References: <20090525185502.GA20781@redhat.com>
	<20090526210514.C1C91FC2BD@magilla.sf.frob.com>
	<20090527213222.GA6770@redhat.com>
X-Zippy-Says: While my BRAINPAN is being refused service in BURGER KING, Jesuit
    priests are DATING CAREER DIPLOMATS!!
Message-Id: <20090527222337.0507EFC36B@magilla.sf.frob.com>
Date: Wed, 27 May 2009 15:23:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Actually, ptrace_signal() is fine wrt pid_ns. task_pid_vnr(current->parent)
> returns 0 if the tracer is not seen from the tracee's namespace, this is
> correct. So, afaics only ptrace_notify() needs the (low priority) fix.

Oh, both are correct.  Sorry.  These are signals received by tracee, which
is current, so task_pid_vnr() dtrt.


Thanks,
Roland
