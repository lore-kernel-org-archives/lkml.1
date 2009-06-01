Return-Path: <linux-kernel-owner+w=401wt.eu-S1755714AbZFAXUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714AbZFAXUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 19:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbZFAXUC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 19:20:02 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131AbZFAXUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 19:20:01 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: PATCH? tracehook_report_clone: fix false positives
In-Reply-To: Oleg Nesterov's message of  Monday, 1 June 2009 23:34:43 +0200 <20090601213443.GA26291@redhat.com>
References: <20090528113601.GA18725@redhat.com>
	<20090528114100.GA18744@redhat.com>
	<20090528212418.2F605FC2BD@magilla.sf.frob.com>
	<20090529122411.GC19812@redhat.com>
	<20090530185212.GA10677@redhat.com>
	<20090601002226.480CEFC3C7@magilla.sf.frob.com>
	<20090601200723.GA22204@redhat.com>
	<20090601205056.16307FC3C7@magilla.sf.frob.com>
	<20090601213443.GA26291@redhat.com>
X-Zippy-Says: HUMAN REPLICAS are inserted into VATS of NUTRITIONAL YEAST...
Message-Id: <20090601231939.223CEFC3C7@magilla.sf.frob.com>
Date: Mon,  1 Jun 2009 16:19:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I suspect you misread my previous question.

Apparently so.

> I didn't mean PTRACE_ATTACH should use ptrace_init_task). I just meant that
> perhaps it makes sense to move sigaddset() from tracehook_finish_clone()
> to tracehook_finish_clone()->ptrace_init_task().

You mean from tracehook_report_clone to ptrace_init_task.  Perhaps.
tracehook_finish_clone->ptrace_init_task is inside write_lock_irq,
so it should really be kept to the minimum of what has to be inside there.

But the real reason is just that tracehook_report_clone() is called at the
place in do_fork() where the ptrace SIGSTOP code was originally before the
introduction of tracehook.h.  

This is where the utrace attachment point has to be (i.e. outside all the
locking).  So I don't see any benefit to changing the ptrace status quo now
for its own sake.


Thanks,
Roland
