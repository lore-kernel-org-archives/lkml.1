Return-Path: <linux-kernel-owner+w=401wt.eu-S1754512AbXJVPgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbXJVPgy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 11:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbXJVPgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 11:36:47 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:55214 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbXJVPgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 11:36:47 -0400
Subject: Re: [RFC/PATCH 2/3] rt: PI-workqueue support
From: Daniel Walker <dwalker@mvista.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>, Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <1193055303.27435.176.camel@twins>
References: <20071022095054.393085000@chello.nl>
	 <20071022095658.745030000@chello.nl>
	 <Pine.LNX.4.58.0710220754440.10836@gandalf.stny.rr.com>
	 <1193055303.27435.176.camel@twins>
Content-Type: text/plain
Date: Mon, 22 Oct 2007 08:33:31 -0700
Message-Id: <1193067211.5028.55.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-22 at 14:15 +0200, Peter Zijlstra wrote:

> Daniel wrote this bit, but I tend to agree with him, but can't give his
> rationale. Mine is that worklets are typically asynchonous and thus its
> prio should not depend on temporal things like boosting.
> 
> OTOH it would probably make sense to allow it to depend on it through
> the barrier constructs, but for that I have to hook the completions into
> the PI chain. Something that needs more thought.

Yeah, I think Peter summarized it .. Since the task isn't waiting on
work when it's inserted it didn't seem right to use a priority that may
be boosted, since the work isn't preventing completion .. I think the
only time you would want to transfer the boosted priority is when a task
gets blocked, which does happen when you flush the workqueue.

Although, If there is one area of this code that needs attention I think
it's the PI stuff, it wasn't my first priority at the time .. I also
recall Oleg find some issue with it ..

Daniel

