Return-Path: <linux-kernel-owner+w=401wt.eu-S1756153AbZE0A4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbZE0A4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 20:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754906AbZE0A4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 20:56:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754454AbZE0A4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 20:56:11 -0400
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
In-Reply-To: Oleg Nesterov's message of  Tuesday, 26 May 2009 23:33:47 +0200 <20090526213346.GA7073@redhat.com>
References: <20090525185502.GA20781@redhat.com>
	<20090526210514.C1C91FC2BD@magilla.sf.frob.com>
	<20090526213346.GA7073@redhat.com>
X-Windows: the first fully modular software disaster.
Message-Id: <20090527005527.B50B7FC36B@magilla.sf.frob.com>
Date: Tue, 26 May 2009 17:55:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes. Perhaps it would be nice to add a helper,

I agree.

> > sys_kill, do_tkill all look wrong to me.
> 
> They should be fine, note the
> 
> 	if (from_ancestor_ns)
> 		q->info.si_pid = 0;
> 
> in __send_signal(). If we send the signal "down" to the sub-namespace,
> si_pid == 0 is correct. And, unlike do_notify_parent/ptrace_notify/etc
> kill/tkill can't send the signal "up".

Ah, right.  I knew there was something around this I was forgetting.


Thanks,
Roland
