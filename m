Return-Path: <linux-kernel-owner+w=401wt.eu-S1751487AbYLUTqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487AbYLUTqe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 14:46:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbYLUTqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 14:46:24 -0500
Received: from www.tglx.de ([62.245.132.106]:42686 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbYLUTqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 14:46:24 -0500
Date: Sun, 21 Dec 2008 20:43:56 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>, dsaxena@plexity.net,
       linux-kernel@vger.kernel.org, Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: TSC not updating after resume: Bug or Feature?
In-Reply-To: <alpine.LFD.2.00.0812211639210.3376@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0812212031220.4548@localhost.localdomain>
References: <20081217172758.GA6010@trantor.hsd1.or.comcast.net> <1229592279.9487.133.camel@twins> <20081218123924.GH25715@elte.hu> <200812182319.57235.rjw@sisk.pl> <alpine.LFD.2.00.0812211639210.3376@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Dec 2008, Thomas Gleixner wrote:
> On Thu, 18 Dec 2008, Rafael J. Wysocki wrote:
> > >  5b7dba4: sched_clock: prevent scd->clock from moving backwards
> > > 
> > > and the bug triggered by hibernation fixed instead.
> 
> Hmm. Depending on the hibernation sleep time we can end up with a
> pretty long delta between the pre suspend and the post resume call to
> __update_sched_clock().
> 
> I have the feeling that sched_clock looks into stale values after
> resume and the first call to __update_sched_clock() trips over the
> stale scd->clock value. Shaggy's patch brings scd->clock into the mix
> and that might cause the whole machinery to blow up on resume.
> 
> Also we need to investigate whether sched_clock is referencing gtod
> values _before_ timekeeping is resume.

I checked the two bugzillas (12149 & 12155) and both reporters have
hpet=force on the command line.

One of the reporters said: "If I de-select CONFIG_HPET_TIMER then the
issue went away ..."

It looks like this was not further investigated. Is this problem
reproducible on other systems as well ?

Thanks,

	tglx
