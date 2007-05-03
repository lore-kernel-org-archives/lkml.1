Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbXECLMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbXECLMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 07:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbXECLMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 07:12:53 -0400
Received: from [212.12.190.22] ([212.12.190.22]:33102 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753317AbXECLMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 07:12:52 -0400
From: Al Boldi <a1426z@gawab.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v7
Date: Thu, 3 May 2007 14:16:50 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
References: <200704300820.49078.a1426z@gawab.com> <20070503074552.GA14960@elte.hu> <20070503080706.GA18427@elte.hu>
In-Reply-To: <20070503080706.GA18427@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705031416.50928.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> > > [...] but there are still some nice issues.
> > >
> > > Try running 3 chew.c's, then renicing one to -10, starves others for
> > > some seconds while switching prio-level.  Now renice it back to 10,
> > > it starves for up to 45sec.
> >
> > ok - to make sure i understood you correctly: does this starvation
> > only occur right when you renice it (when switching prio levels), and
> > it gets rectified quickly once they get over a few reschedules?
>
> meanwhile i managed to reproduce it by following the exact steps you
> described, and i've fixed the bug in my tree. Can you confirm that the
> patch below fixes it for you too?

Seems like this fixed it.  But I can still see these awful latency blips in 
the presence of negatively niced chew.c at -10 and two chew.c's at nice 0.  
This gets really bad when sched_granularity_ns >= 5,000,000.


Thanks!

--
Al

