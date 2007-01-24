Return-Path: <linux-kernel-owner+w=401wt.eu-S965120AbXAXCZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965120AbXAXCZF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 21:25:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965622AbXAXCZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 21:25:05 -0500
Received: from smtp.osdl.org ([65.172.181.24]:48265 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965120AbXAXCZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 21:25:03 -0500
Date: Tue, 23 Jan 2007 18:23:06 -0800
From: Andrew Morton <akpm@osdl.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [patch 00/46] High resolution timer / dynamic tick update
Message-Id: <20070123182306.34e90711.akpm@osdl.org>
In-Reply-To: <1169604991.19471.95.camel@imap.mvista.com>
References: <20070123211159.178138000@localhost.localdomain>
	<1169604991.19471.95.camel@imap.mvista.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jan 2007 18:16:31 -0800
Daniel Walker <dwalker@mvista.com> wrote:

> On Tue, 2007-01-23 at 22:00 +0000, Thomas Gleixner wrote:
> >  - Provide a generic way to verify clocksources. TSC needs
> >    verification due to broken hardware and BIOS implementations. The
> >    previous attempt to allow TSC usage for high resolution and/or
> >    dynamic ticks only in combination with the PM-Timer made hardwired
> >    assumptions, which are ugly to maintain. The new verification code
> >    solves this by chosing the best available clocksource for
> >    verification and handles the usability check for highres / dynamic
> >    ticks. This makes TSC code agnostic of other hardware available in
> >    the system.
> 
> 
> There appears to be some fairly clear duplication between my clocksource
> tree and this release of high resolution timers. Not to mention that we
> both submitted our tree's to Andrew within days . 
> 
> To lessen Andrews burden it would be wise to integrate the two trees
> prior to anything going into -mm .. It makes sense to eliminate this
> kind of duplication since it just results in wasted effort. With the
> benefit that the merge would likely result in a stronger patch set over
> all.
> 

There's also the question of testing status.  We know that the dynticks
patches in -mm mostly work.  Now that they appear to have been largely respun,
we don't know that any more.  Then if we go adding more stuff on top, problem
identification becomes harder.

I thought that dynticks/hrtimers was a done thing: in fact $certain_people wanted
them in 2.6.20.  The late-breaking rip-up-and-rewrite was rather unwelcome.  But
I haven't got onto reading the patchset yet.

