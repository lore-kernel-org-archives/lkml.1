Return-Path: <linux-kernel-owner+w=401wt.eu-S1755519AbZF3TXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbZF3TXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 15:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbZF3TXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 15:23:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbZF3TXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 15:23:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ratan Nalumasu <rnalumasu@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 2/2] change __wake_up_parent() to use filtered
	wakeup
In-Reply-To: Oleg Nesterov's message of  Monday, 29 June 2009 05:38:52 +0200 <20090629033852.GA14404@redhat.com>
References: <20090622170437.GA4906@redhat.com>
	<20090624091316.73D0F4059B@magilla.sf.frob.com>
	<20090624152143.GB23848@redhat.com>
	<20090624185701.AA74C4059B@magilla.sf.frob.com>
	<20090624161111.GA27890@redhat.com>
	<20090624194239.A29174059B@magilla.sf.frob.com>
	<20090624171357.GA30435@redhat.com>
	<20090624205112.3EA944059B@magilla.sf.frob.com>
	<93ad5f3f0906252111n48742b9ax8dc2ad35b30f4292@mail.gmail.com>
	<20090629033852.GA14404@redhat.com>
X-Zippy-Says: Look into my eyes and try to forget that you have a Macy's charge card!
Message-Id: <20090630192235.90AFB1C4@magilla.sf.frob.com>
Date: Tue, 30 Jun 2009 12:22:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >        if ((wo->wo_flags & __WNOTHREAD) && wo->child_wait.private !=
> > p->parent)
> >                return 0;
> > ===
> >
> > I will run it on my test machines and see if everything looks good.
> 
> OK, thanks.
> 
> The only problem it uses ->parent, this conflicts with other out-of-tree
> ptrace changes...
> 
> Roland, do you think we should do this change now or later?

I think it makes most sense to put that in right after the initial
wait_child_callback patch (if not rolled into it).  In fact, the original
approach was to do just this "simplest" __WNOTHREAD-checking callback
first, and add the eligible_child() hacking second (not that I think that
order matters).


Thanks,
Roland
