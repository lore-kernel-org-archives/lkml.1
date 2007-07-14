Return-Path: <linux-kernel-owner+w=401wt.eu-S1761050AbXGNSB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761050AbXGNSB2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 14:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758707AbXGNSBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 14:01:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46370 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758610AbXGNSBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 14:01:14 -0400
Subject: Re: [PATCH -rt 1/5] workqueue: queue_work_cpu
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Steven Rostedt <rostedt@goodmis.org>,
       Christoph Lameter <clameter@sgi.com>
In-Reply-To: <20070714171406.GA746@tv-sign.ru>
References: <20070714175733.194012000@chello.nl>
	 <20070714175839.377905000@chello.nl>  <20070714171406.GA746@tv-sign.ru>
Content-Type: text/plain
Date: Sat, 14 Jul 2007 20:00:46 +0200
Message-Id: <1184436047.5284.60.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-14 at 21:14 +0400, Oleg Nesterov wrote:
> On 07/14, Peter Zijlstra wrote:
> >
> > +int fastcall queue_work_cpu(struct workqueue_struct *wq, struct work_struct *work, int cpu)
> > +{
> > +	int ret = 0;
> > +
> > +	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
> > +		BUG_ON(!list_empty(&work->entry));
> > +		__queue_work(wq_per_cpu(wq, cpu), work);
> > +		ret = 1;
> > +	}
> > +	return ret;
> > +}
> 
> Minor nit, we already have queue_delayed_work_on(), perhaps it should be named
> queue_work_on().

Yes, that makes sense. Shall do.

