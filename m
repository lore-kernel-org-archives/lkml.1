Return-Path: <linux-kernel-owner+w=401wt.eu-S932185AbXDEAVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185AbXDEAVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 20:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932267AbXDEAVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 20:21:10 -0400
Received: from gw.goop.org ([64.81.55.164]:34531 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932078AbXDEAUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 20:20:53 -0400
Message-ID: <461440C9.8040902@goop.org>
Date: Wed, 04 Apr 2007 17:20:25 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Daniel Walker <dwalker@mvista.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       tglx@linutronix.de, johnstul@us.ibm.com,
       LKML <linux-kernel@vger.kernel.org>, heiko.carstens@de.ibm.com
Subject: Re: + clocksource-driver-initialize-list-value.patch added to -mm
 tree
References: <200704010523.l315NXJP004063@shell0.pdx.osdl.net>	 <1175417035.28263.42.camel@localhost.localdomain>	 <1175704712.15973.35.camel@imap.mvista.com>	 <20070404125853.1cf9b7b7.akpm@linux-foundation.org>	 <1175717425.15973.61.camel@imap.mvista.com>	 <20070404203647.GA12563@elte.hu>	 <1175719489.15973.66.camel@imap.mvista.com>	 <20070404211514.GA18600@elte.hu>	 <1175722246.15973.78.camel@imap.mvista.com>	 <20070404213404.GA21742@elte.hu>	 <1175723954.15973.96.camel@imap.mvista.com>  <46143941.7050702@goop.org> <1175731253.15973.106.camel@imap.mvista.com>
In-Reply-To: <1175731253.15973.106.camel@imap.mvista.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:
> Setting CLOCK_SOURCE_IS_CONTINUOUS is largely administration , do you
> know what that flag means?
>   

Sure, but at least it has something to do with clocks and time.

> list values and list initialization are hardly internal details , they
> are commonly used all over the kernel.
>   

The fact that a list is used to string together clocksource structures
is an internal detail of the clock subsystem.  It's annoying that there
has to be a list head in the clocksource structure, but at least as a
clocksource implementer I can ignore it, and if it ever gets changed to
something else I can keep ignoring it.  Your change makes it something
that gets pointlessly replicated all over the kernel.

The real point is that it seems this change just adds work and cruft,
but for no benefit.  Your comment is that it "simplifies the
registration process".  Why does it need to be simpler?  How is it
simpler?  From a clocksource implementers perspective, the registration
is already pretty simple; how does it get simpler?  It looks less simple
to me, because now there's another failure-mode (a BUG if I forget to
initialize the list).

    J
