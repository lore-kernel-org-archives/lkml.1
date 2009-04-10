Return-Path: <linux-kernel-owner+w=401wt.eu-S1761695AbZDJJ6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761695AbZDJJ6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 05:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbZDJJ6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 05:58:33 -0400
Received: from www.tglx.de ([62.245.132.106]:35986 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbZDJJ6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 05:58:32 -0400
Date: Fri, 10 Apr 2009 11:57:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Eric Miao <eric.y.miao@gmail.com>
cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, akpm@linux-foundation.org, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/genirq] genirq: assert that irq handlers are indeed
 running in hardirq context
In-Reply-To: <f17812d70904100011g65c582bcg32a530afd8e9a82d@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0904101156360.21577@localhost.localdomain>
References: <1236006812.5330.632.camel@laptop>  <tip-044d408409cc4e1bc75c886e27ca85c270db104c@git.kernel.org> <f17812d70904100011g65c582bcg32a530afd8e9a82d@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1115216407-1239357447=:21577"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1115216407-1239357447=:21577
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 10 Apr 2009, Eric Miao wrote:
> On Tue, Mar 3, 2009 at 7:15 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > Commit-ID:  044d408409cc4e1bc75c886e27ca85c270db104c
> > Gitweb:     http://git.kernel.org/tip/044d408409cc4e1bc75c886e27ca85c270db104c
> > Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> > AuthorDate: Mon, 2 Mar 2009 16:13:32 +0100
> > Commit:     Ingo Molnar <mingo@elte.hu>
> > CommitDate: Tue, 3 Mar 2009 00:05:45 +0100
> >
> > genirq: assert that irq handlers are indeed running in hardirq context
> >
> > Make sure the genirq layer handlers are indeed running handlers
> > in hardirq context. That is the genirq expectation and doing
> > anything else is broken.
> >
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > LKML-Reference: <1236006812.5330.632.camel@laptop>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> >
> 
> OK, now this gave me the warning below and it looks resend_irqs()
> and resend_tasklet are somehow found guilty and doing wrong, as
> the comment of this commit suggested, yet I'm not sure if this makes
> sense:

No, it doesn't. We didn't think about the resend tasklet. I'm going to
fix it.

Thanks,

	tglx
--8323328-1115216407-1239357447=:21577--
