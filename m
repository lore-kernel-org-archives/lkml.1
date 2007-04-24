Return-Path: <linux-kernel-owner+w=401wt.eu-S1754464AbXDXUf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbXDXUf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 16:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754516AbXDXUf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 16:35:26 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754464AbXDXUfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 16:35:06 -0400
Date: Tue, 24 Apr 2007 13:33:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Prarit Bhargava <prarit@redhat.com>, Rick Lindsley <ricklind@us.ibm.com>,
       john stultz <johnstul@us.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Eric Dumazet <dada1@cosmosbay.com>, virtualization@lists.osdl.org,
       Chris Lalancette <clalance@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 1/4] Ignore stolen time in the softlockup watchdog
Message-Id: <20070424133359.f18bce78.akpm@linux-foundation.org>
In-Reply-To: <462E6778.7070305@goop.org>
References: <20070327214919.800272641@goop.org>
	<20070327215827.871954359@goop.org>
	<20070423234910.50149faf.akpm@linux-foundation.org>
	<462E43A7.1050001@goop.org>
	<20070424105738.e0ce36a9.akpm@linux-foundation.org>
	<462E4969.6070802@goop.org>
	<20070424113222.ed2e1314.akpm@linux-foundation.org>
	<462E61F1.7060403@goop.org>
	<462E6778.7070305@goop.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007 13:24:24 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Jeremy Fitzhardinge wrote:
> > Andrew Morton wrote:
> >   
> >> Well, it _is_ mysterious.
> >>
> >> Did you try to locate the code which failed?  I got lost in macros and
> >> include files, and gave up very very easily.  Stop hiding, Ingo.
> >>   
> >>     
> >
> > OK, I've managed to reproduce it.  Removing the local_irq_save/restore
> > from sched_clock() makes it go away, as I'd expect (otherwise it would
> > really be magic).  But given that it never seems to touch the softlockup
> > during testing, I have no idea what difference it makes...
> 
> And sched_clock's use of local_irq_save/restore appears to be absolutely
> correct, so I think it must be triggering a bug in either the self-tests
> or lockdep itself.

It's weird.  And I don't think the locking selftest code calls
sched_clock() (or any other time-related thing) at all, does it?

> The only way I could actually extract the test code itself was to run
> the whole thing through cpp+indent, but it doesn't shed much light.
> 
> It's also not clear to me if there are 6 independent failures, or if
> they're a cascade.

Oh well.  I'll restore the patches and when people hit problems we can
blame Ingo!

