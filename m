Return-Path: <linux-kernel-owner+w=401wt.eu-S1757641AbYDGWb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641AbYDGWb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 18:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbYDGWbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 18:31:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43462 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbYDGWbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 18:31:20 -0400
Date: Tue, 8 Apr 2008 00:35:40 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andi Kleen <andi@firstfloor.org>, Jiri Kosina <jkosina@suse.cz>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: BUG: using smp_processor_id() during suspend with 2.6.25-rc8
Message-ID: <20080407223540.GI16647@one.firstfloor.org>
References: <c4e36d110804070625n17eb44e1nbb5558f500f13438@mail.gmail.com> <Pine.LNX.4.64.0804080008420.3896@jikos.suse.cz> <20080407222352.GG16647@one.firstfloor.org> <200804080029.31102.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804080029.31102.rjw@sisk.pl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2008 at 12:29:30AM +0200, Rafael J. Wysocki wrote:
> On Tuesday, 8 of April 2008, Andi Kleen wrote:
> > On Tue, Apr 08, 2008 at 12:11:17AM +0200, Jiri Kosina wrote:
> > > On Tue, 8 Apr 2008, Andi Kleen wrote:
> > > 
> > > > > I know. However preempt_count is a little bit inconsistent in such cases 
> > > > > though.
> > > > And? interrupts off beats preempt count anyways. Why did you write the 
> > > > patch? Was there a (incorrect) warning triggered?
> > > 
> > > Reported at http://lkml.org/lkml/2008/4/7/130
> > > 
> > > BTW is also mce_init() (called from mce_resume()) guaranteed to run with 
> > > IRQs off?
> > 
> > [cc rafael]
> > 
> > The mce resume is a sysdev.
> > 
> > sysdevs were always supposed to run completely with interrupts off. If they 
> > don't anymore that's some kind of higher level resume code bug which you need 
> > to fix there, not hack around in the low level code.
> 
> They are executed with interrupts disabled, on one CPU.

Well then someone enables them incorrectly, see the report above.

> 
> > If it does that it likely broke more code too.
> > 
> > Obviously turning on preemption anywhere around the machine check is
> > fatal because it touches CPU state and if you reschedule you could
> > switch to another CPU and change or access the wrong CPU's state.
> 
> FWIW, at the point when sysdevs are resumed we are single-threaded.

You mean single CPUed? Even a single thread could switch to another CPU.

-Andi
