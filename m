Return-Path: <linux-kernel-owner+w=401wt.eu-S1751836AbYLWOPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836AbYLWOPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 09:15:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751106AbYLWOP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 09:15:29 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60646 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbYLWOP3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 09:15:29 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: TSC not updating after resume: Bug or Feature?
Date: Tue, 23 Dec 2008 15:15:14 +0100
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>, dsaxena@plexity.net,
       linux-kernel@vger.kernel.org, Dave Kleikamp <shaggy@linux.vnet.ibm.com>
References: <20081217172758.GA6010@trantor.hsd1.or.comcast.net> <200812230147.32340.rjw@sisk.pl> <alpine.LFD.2.00.0812230801440.3723@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0812230801440.3723@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200812231515.14979.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 23 of December 2008, Thomas Gleixner wrote:
> On Tue, 23 Dec 2008, Rafael J. Wysocki wrote:
> > > Care to explain ?
> > 
> > Well, the fact that in the resume code path the clocksource is only updated as
> > a result of executing pci_set_power_state() is worrisome.  I would be more
> > reliable to update it directly at one point.
> 
> Hmm. We reactivate the clock sources from timekeeping resume():
> 
>      clocksource_resume();
> 
> How is this related to pci_set_power_state() ?

>From the original report:

"I am using ftrace to get a detailed timing analysis of the resume process 
on the OLPC XO laptop and am seeing that when we start running again, the
system timestamep is not being updated for several (hundreds of) thousands 
of cycles (~2000 ftrace entries). From following the ftrace, what is 
happening is that the clocksource is not updated until we run the cpu_idle() 
thread due to an explicit scheduling operation in the resume path that occurs 
via call to msleep from pci_set_power_state()."

That's what I was referring to.

Thanks,
Rafael
