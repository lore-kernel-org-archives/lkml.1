Return-Path: <linux-kernel-owner+w=401wt.eu-S1751422AbXAXNRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbXAXNRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 08:17:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbXAXNRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 08:17:15 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4675 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751422AbXAXNRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 08:17:14 -0500
Date: Tue, 23 Jan 2007 19:57:12 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, rmk+lkml@arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] fix emergency reboot: call reboot notifier list if possible
Message-ID: <20070123195712.GB6596@ucw.cz>
References: <20070117091319.GA30036@elte.hu> <20070117092233.GA30197@flint.arm.linux.org.uk> <20070117093917.GA7538@elte.hu> <20070117020343.8622e44d.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070117020343.8622e44d.akpm@osdl.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > On Wed, Jan 17, 2007 at 10:13:19AM +0100, Ingo Molnar wrote:
> > > > we dont call the reboot notifiers during emergency reboot mainly because 
> > > > it could be called from atomic context and reboot notifiers are a 
> > > > blocking notifier list. But actually the kernel is often perfectly 
> > > > reschedulable in this stage, so we could as well process the 
> > > > reboot_notifier_list.
> > > 
> > > My experience has been that when there has been the need to use this
> > > facility, the kernel hasn't been reschedulable. [...]
> > 
> > this decision is totally automatic - so if your situation happens and 
> > the kernel isnt reschedulable, then the notifier chain wont be called 
> > and nothing changes from your perspective. Hm, perhaps this should be 
> > dependent on CONFIG_PREEMPT, to make sure preempt_count() is reliable?
> > 
> > but from my perspective this patch fixes a real regression.
> > 
> > updated patch attached below.
> > 
> 
> Making it dependent upon CONFIG_PREEMPT seems a bit sucky.  Perhaps pass in
> some "you were called from /proc/sysrq-trigger" notification?

What about adding 'B' with 'reboot with notifications' meaning?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
