Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbYLWHDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbYLWHDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 02:03:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbYLWHDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 02:03:43 -0500
Received: from www.tglx.de ([62.245.132.106]:32925 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037AbYLWHDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 02:03:43 -0500
Date: Tue, 23 Dec 2008 08:03:06 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>, dsaxena@plexity.net,
       linux-kernel@vger.kernel.org, Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: TSC not updating after resume: Bug or Feature?
In-Reply-To: <200812230147.32340.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0812230801440.3723@localhost.localdomain>
References: <20081217172758.GA6010@trantor.hsd1.or.comcast.net> <200812182319.57235.rjw@sisk.pl> <alpine.LFD.2.00.0812211639210.3376@localhost.localdomain> <200812230147.32340.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Dec 2008, Rafael J. Wysocki wrote:
> > Care to explain ?
> 
> Well, the fact that in the resume code path the clocksource is only updated as
> a result of executing pci_set_power_state() is worrisome.  I would be more
> reliable to update it directly at one point.

Hmm. We reactivate the clock sources from timekeeping resume():

     clocksource_resume();

How is this related to pci_set_power_state() ?

Thanks,

	tglx
