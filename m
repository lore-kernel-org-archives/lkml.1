Return-Path: <linux-kernel-owner+w=401wt.eu-S1761905AbYB1Wl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761905AbYB1Wl5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 17:41:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755472AbYB1Wlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 17:41:49 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755890AbYB1Wls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 17:41:48 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Pavel Emelyanov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] Consolidate send_sigqueue and send_group_sigqueue
In-Reply-To: Thomas Gleixner's message of  Thursday, 28 February 2008 23:32:05 +0100 <alpine.LFD.1.00.0802282326560.3111@apollo.tec.linutronix.de>
References: <47BEC663.7050904@openvz.org>
	<20080222144155.GA4349@tv-sign.ru>
	<alpine.LFD.1.00.0802280546360.7583@apollo.tec.linutronix.de>
	<20080228061723.GB108@tv-sign.ru>
	<20080228113633.7431C2700FD@magilla.localdomain>
	<alpine.LFD.1.00.0802282326560.3111@apollo.tec.linutronix.de>
X-Windows: a terminal disease.
Message-Id: <20080228224141.A47B12700FD@magilla.localdomain>
Date: Thu, 28 Feb 2008 14:41:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Right. I was working on a fix for that for a different reason. What we
> really want is a check for such a timer on a transition from SIGIGN to
> another state.  This would allow us to drop the ugly auto rearm code
> for ignored timers completely. I had some working proof of concept
> code, but got distracted. Need to find it again and dust if off.

That is certainly what came first to mind.  (Note that it's not strictly
SIG_IGN alone, but sigaction_says_ignore.)  We'll have to contemplate a lot
of corners to be sure we get it right.  It's not real clear to me how you
go about finding all the affected timers sanely from sigaction.


Thanks,
Roland
