Return-Path: <linux-kernel-owner+w=401wt.eu-S1756754AbZCBWZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbZCBWZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 17:25:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbZCBWZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 17:25:47 -0500
Received: from casper.infradead.org ([85.118.1.10]:55413 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbZCBWZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 17:25:46 -0500
Subject: Re: lockdep and threaded IRQs (was: ...)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com,
       tglx@linutronix.de
In-Reply-To: <200903021410.25889.david-b@pacbell.net>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com>
	 <200902271518.58246.david-b@pacbell.net> <1235999770.5330.367.camel@laptop>
	 <200903021410.25889.david-b@pacbell.net>
Content-Type: text/plain
Date: Mon, 02 Mar 2009 23:25:22 +0100
Message-Id: <1236032722.5330.1675.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-02 at 14:10 -0800, David Brownell wrote:

> What's unfortunate is that you prefer not to fix that
> IRQF_DISABLED bug in lockdep, which you co-"maintain".
> When running with lockdep, that bug (a) introduces bugs
> in some drivers and (b) hides bugs in others.  You've
> rejected even a minimal warning fix, to help minimize
> the amount of time developers waste on (a) and (b).

I've come to the conclusion that the only technically sound solution is
to do as I proposed today, utterly eliminate !IRQF_DISABLED handlers.

Apparently you had enough time to come up with the creative genirq abuse
of twl4030, I think that with a similar effort you could have
implemented generic threaded irq stuff like proposed by Thomas.

> Attacking folk for having to cope with such bugs escalates
> things beyond "unfortunate".  If lockdep is "maintained",
> your response should be fixing that lockdep bug.  Once
> that's done, all workarounds for that bug can be removed.

I state there is no lockdep bug in this respect. The bug is trying to
enable interrupts from hardirq context and running code that assumes
hardirq context from task context.

