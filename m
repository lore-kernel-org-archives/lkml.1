Return-Path: <linux-kernel-owner+w=401wt.eu-S1759097AbZBLOmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759097AbZBLOmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 09:42:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756744AbZBLOlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 09:41:55 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58725 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756806AbZBLOly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 09:41:54 -0500
Subject: Re: [patch] rt: res_counter fix, v2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@tglx.de>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>
In-Reply-To: <20090212142806.GA5865@nowhere>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <20090212005032.GA4788@nowhere> <20090212021257.GB4697@nowhere>
	 <20090212101650.GA1096@elte.hu> <20090212102113.GA10031@elte.hu>
	 <20090212142806.GA5865@nowhere>
Content-Type: text/plain
Date: Thu, 12 Feb 2009 15:41:41 +0100
Message-Id: <1234449701.10603.10.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-12 at 15:28 +0100, Frederic Weisbecker wrote:
> > [   45.228589] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
> > [   45.228602] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
> 
> 
> The reason for which I wanted to send an irqsoff trace is that the above lines are false.

copy_process() has:

#endif
	p->hardirq_enable_ip = 0;
	p->hardirq_enable_event = 0;
	p->hardirq_disable_ip = _THIS_IP_;
	p->hardirq_disable_event = 0;
	p->softirqs_enabled = 1;
	p->softirq_enable_ip = _THIS_IP_;
	p->softirq_enable_event = 0;
	p->softirq_disable_ip = 0;
	p->softirq_disable_event = 0;
	p->hardirq_context = 0;
	p->softirq_context = 0;
#endif

the sequence count of 0 basically tells you it hasn't been set yet.

