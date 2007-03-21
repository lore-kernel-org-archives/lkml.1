Return-Path: <linux-kernel-owner+w=401wt.eu-S932065AbXCUPZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065AbXCUPZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 11:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932241AbXCUPZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 11:25:30 -0400
Received: from mail.screens.ru ([213.234.233.54]:44450 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932065AbXCUPZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 11:25:29 -0400
Date: Wed, 21 Mar 2007 18:29:35 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Neil Brown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Folkert van Heusden <folkert@vanheusden.com>,
       linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Re: [2.6.20] BUG: workqueue leaked lock
Message-ID: <20070321152935.GA215@tv-sign.ru>
References: <17918.11420.155569.991473@notabene.brown> <20070320093753.GA1751@ff.dom.local> <20070320160759.GA107@tv-sign.ru> <20070321080510.GA1939@ff.dom.local> <20070321144620.GC78@tv-sign.ru> <20070321151651.GA4547@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070321151651.GA4547@ff.dom.local>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21, Jarek Poplawski wrote:
>
> > Sorry, I can't understand you. lockdep_depth is counted within a process,
> > which starts before f(), yes. This process is cwq->thread, it was forked
> > during create_workqueue(). It does not take any locks directly, only by
> > calling work->func(). laundry_wq doesn't differ from keventd_wq or any other
> > wq in this sense. nfsd does not "runs kthread by itself", it inserts the
> > work and wakes up cwq->thread.
> 
> I think we know how it all should start and go. If only analyzing
> the code could be enough, this current check of lockdep_depth()
> is unnecessary too, because laundromat_code code looks as good
> as run_workqueue code. I send it for testing and I mean it -
> something strange is going here, so some checks should be added
> - I didn't say mine is the right and will certainly help.

Ah, sorry, I misunderstood you. I had (my fault) a false impression
that you propose this patch as a "fix", while we seem to agree that
the real source of this problem remains unknown.

> So, if
> you have another idea for looking after it, let us know.

No, I don't.

Oleg.

