Return-Path: <linux-kernel-owner+w=401wt.eu-S1753521AbYKDISw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbYKDISw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 03:18:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754635AbYKDISk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 03:18:40 -0500
Received: from mga05.intel.com ([192.55.52.89]:50052 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754512AbYKDISi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 03:18:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,542,1220252400"; 
   d="scan'208";a="399648256"
Subject: Re: [PATCH 3/3] ftrace: function tracer with irqs disabled
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20081104080747.GA27075@elte.hu>
References: <20081104041554.605521183@goodmis.org>
	 <20081104042203.499871423@goodmis.org>  <20081104080747.GA27075@elte.hu>
Content-Type: text/plain
Date: Tue, 04 Nov 2008 16:17:07 +0800
Message-Id: <1225786627.1685.112.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-11-04 at 09:07 +0100, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Running hackbench 3 times with the irqs disabled and 3 times with 
> > the preempt disabled function tracer yielded:
> > 
> > tracing type       times            entries recorded
> > ------------      --------          ----------------
> > irq disabled      43.393            166433066
> >                   43.282            166172618
> >                   43.298            166256704
> > 
> > preempt disabled  38.969            159871710
> >                   38.943            159972935
> >                   39.325            161056510
> 
> your numbers might be correct, but i found that hackbench is not 
> reliable boot-to-boot 
I found that, too. But if I kill most background processes before testing,
hackbench result looks quite stable.

> - it can easily produce 10% systematic noise or 
> more. (perhaps depending on how the various socket data structures 
> happen to be allocated)
> 
> the really conclusive way to test this would be to add a hack that 
> either does preempt disable or irqs disable, depending on a runtime 
> flag - and then observe how hackbench performance reacts to the value 
> of that flag.
> 
> note that preempt-disable will also produce less trace entries, 
> especially in very irq-rich workloads. Hence it will be "faster".
> 
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

