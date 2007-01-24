Return-Path: <linux-kernel-owner+w=401wt.eu-S1752001AbXAXQfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbXAXQfI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 11:35:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbXAXQfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 11:35:08 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:38845 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbXAXQfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 11:35:06 -0500
Date: Wed, 24 Jan 2007 08:30:47 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       rmk+lkml@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [patch] fix emergency reboot: call reboot notifier list if
 possible
Message-Id: <20070124083047.37b09f2c.randy.dunlap@oracle.com>
In-Reply-To: <20070123195712.GB6596@ucw.cz>
References: <20070117091319.GA30036@elte.hu>
	<20070117092233.GA30197@flint.arm.linux.org.uk>
	<20070117093917.GA7538@elte.hu>
	<20070117020343.8622e44d.akpm@osdl.org>
	<20070123195712.GB6596@ucw.cz>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jan 2007 19:57:12 +0000 Pavel Machek wrote:

> Hi!
> 
> > > > On Wed, Jan 17, 2007 at 10:13:19AM +0100, Ingo Molnar wrote:
> > > > > we dont call the reboot notifiers during emergency reboot mainly because 
> > > > > it could be called from atomic context and reboot notifiers are a 
> > > > > blocking notifier list. But actually the kernel is often perfectly 
> > > > > reschedulable in this stage, so we could as well process the 
> > > > > reboot_notifier_list.
> > > > 
> > > > My experience has been that when there has been the need to use this
> > > > facility, the kernel hasn't been reschedulable. [...]
> > > 
> > > this decision is totally automatic - so if your situation happens and 
> > > the kernel isnt reschedulable, then the notifier chain wont be called 
> > > and nothing changes from your perspective. Hm, perhaps this should be 
> > > dependent on CONFIG_PREEMPT, to make sure preempt_count() is reliable?
> > > 
> > > but from my perspective this patch fixes a real regression.
> > > 
> > > updated patch attached below.
> > > 
> > 
> > Making it dependent upon CONFIG_PREEMPT seems a bit sucky.  Perhaps pass in
> > some "you were called from /proc/sysrq-trigger" notification?
> 
> What about adding 'B' with 'reboot with notifications' meaning?

if I am reading 'B' vs. 'b' correctly:

sysrq key codes are currently all lower case only.
Of course, that could be changed to support upper case.
That would require sysrq help messages in a different format
(currently the keycode for the action is Capitalized, e.g.,
b => reBoot).  And I suspect that it would allow some users to
enter b vs. B or B vs. b etc. unintentionally.
In any case, the sysrq_key_table could easily fill up soon,
so we may be force to support UpperCase codes.

---
~Randy
