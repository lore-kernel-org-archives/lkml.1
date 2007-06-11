Return-Path: <linux-kernel-owner+w=401wt.eu-S1763525AbXFKFdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763525AbXFKFdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 01:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750741AbXFKFdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 01:33:31 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:51142 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbXFKFda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 01:33:30 -0400
Date: Mon, 11 Jun 2007 14:32:09 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Chris Wright <chrisw@sous-sol.org>, Adam Belay <abelay@novell.com>,
       Len Brown <lenb@kernel.org>, Dave Miller <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [patch-mm 01/23] NOHZ: Fix ARM,SH,SPARC64 idle nohz handling
Message-ID: <20070611053209.GA23365@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
	Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
	Arjan van de Ven <arjan@infradead.org>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	Chris Wright <chrisw@sous-sol.org>, Adam Belay <abelay@novell.com>,
	Len Brown <lenb@kernel.org>, Dave Miller <davem@davemloft.net>,
	Russell King <rmk+kernel@arm.linux.org.uk>
References: <20070610092437.118387863@inhelltoy.tec.linutronix.de> <20070610092446.402212606@inhelltoy.tec.linutronix.de> <20070611002614.GA20676@linux-sh.org> <1181539259.8176.40.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181539259.8176.40.camel@chaos>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2007 at 07:20:59AM +0200, Thomas Gleixner wrote:
> On Mon, 2007-06-11 at 09:26 +0900, Paul Mundt wrote:
> >
> > There are two paths here depending on hlt/nohlt setting, we need to have
> > tick_nohz_stop_sched_tick() for the TIF_POLLING_NRFLAG case, too.
> 
> Do you really want to run through that in every loop iteration ? If you
> have nohlt, then nohz is rather pointless.
> 
Well, nohlt is a corner case, but even so, nohz doesn't really make much
sense in the polling case. tick_nohz_restart_sched_tick() is also safe in
either path, so let's just go with your original patch. Sorry for the noise.

Acked-by: Paul Mundt <lethal@linux-sh.org>
