Return-Path: <linux-kernel-owner+w=401wt.eu-S1759478AbZBLOwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759478AbZBLOwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 09:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbZBLOwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 09:52:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:50183 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756610AbZBLOv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 09:51:59 -0500
Subject: Re: [patch] rt: res_counter fix, v2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@tglx.de>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>
In-Reply-To: <20090212144624.GB14616@elte.hu>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <20090212005032.GA4788@nowhere> <20090212021257.GB4697@nowhere>
	 <20090212101650.GA1096@elte.hu> <20090212102113.GA10031@elte.hu>
	 <20090212142806.GA5865@nowhere> <1234449701.10603.10.camel@laptop>
	 <20090212144624.GB14616@elte.hu>
Content-Type: text/plain
Date: Thu, 12 Feb 2009 15:51:46 +0100
Message-Id: <1234450306.10603.12.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-12 at 15:46 +0100, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Thu, 2009-02-12 at 15:28 +0100, Frederic Weisbecker wrote:
> > > > [   45.228589] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
> > > > [   45.228602] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
> > > 
> > > 
> > > The reason for which I wanted to send an irqsoff trace is that the above lines are false.
> > 
> > copy_process() has:
> > 
> > #endif
> > 	p->hardirq_enable_ip = 0;
> > 	p->hardirq_enable_event = 0;
> > 	p->hardirq_disable_ip = _THIS_IP_;
> > 	p->hardirq_disable_event = 0;
> > 	p->softirqs_enabled = 1;
> > 	p->softirq_enable_ip = _THIS_IP_;
> > 	p->softirq_enable_event = 0;
> > 	p->softirq_disable_ip = 0;
> > 	p->softirq_disable_event = 0;
> > 	p->hardirq_context = 0;
> > 	p->softirq_context = 0;
> > #endif
> > 
> > the sequence count of 0 basically tells you it hasn't been set yet.
> 
> maybe we should initialize it to -1 to make this more apparent?

I think the current state makes sense, it reflects the actual state of
copy_process.

