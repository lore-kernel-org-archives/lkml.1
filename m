Return-Path: <linux-kernel-owner+w=401wt.eu-S1751746AbXCDNki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746AbXCDNki (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 08:40:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbXCDNki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 08:40:38 -0500
Received: from www.osadl.org ([213.239.205.134]:38038 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751746AbXCDNkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 08:40:37 -0500
Subject: Re: [PATCH] highres: Do not run the TIMER_SOFTIRQ after switching
	to	highres mode
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Andres Salomon <dilinger@debian.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <45EAC5B1.2060306@debian.org>
References: <45E8E2F8.1030102@debian.org>
	 <1172912540.24738.108.camel@localhost.localdomain>
	 <45EAAA21.4040803@debian.org>
	 <1173013794.24738.130.camel@localhost.localdomain>
	 <45EAC5B1.2060306@debian.org>
Content-Type: text/plain
Date: Sun, 04 Mar 2007 14:23:50 +0100
Message-Id: <1173014630.24738.132.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-03-04 at 08:12 -0500, Andres Salomon wrote:
> Thomas Gleixner wrote:
> >>> The question is, how the tick timer gets enqueued in the softirq queue.
> >>> Can you isolate the codepath, where this happens ?
> > 
> > The TIMER_SOFTIRQ runs the hrtimers during bootup until a usable
> > clocksource and clock event sources are registered. The switch to high
> > resolution mode happens inside of the TIMER_SOFTIRQ, but runs the
> > softirq afterwards. That way the tick emulation timer, which was set up
> > in the switch to highres might be executed in the softirq context, which
> > is a BUG. The rbtree has not to be touched by the softirq after the
> > highres switch.
> > 
> 
> And an additional request, just to make it explicit that we should not
> have any NO_SOFTIRQ callbacks in the tree; BUG out if we encounter such
> a thing.
> 
> Signed-off-by: Andres Salomon <dilinger@debian.org>

Acked-by: Thomas Gleixner <tglx@linutronix.de>


