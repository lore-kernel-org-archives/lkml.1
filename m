Return-Path: <linux-kernel-owner+w=401wt.eu-S1753774AbXKRMfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774AbXKRMfX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 07:35:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbXKRMfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 07:35:10 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:50196 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbXKRMfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 07:35:08 -0500
Subject: Re: [BUG on PREEMPT_RT, 2.6.23.1-rt5] in rt-mutex code and signals
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: Ingo Molnar <mingo@elte.hu>, Remy Bohmer <linux@bohmer.net>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Dave Chinner <dgc@sgi.com>
In-Reply-To: <1195323177.25393.56.camel@imap.mvista.com>
References: <3efb10970711160751l279fe99dl9f3a130a4373a449@mail.gmail.com>
	 <Pine.LNX.4.58.0711161516580.25989@gandalf.stny.rr.com>
	 <3efb10970711161502m6216bf5rc19a34184b4f3a2b@mail.gmail.com>
	 <Pine.LNX.4.58.0711161830570.28002@gandalf.stny.rr.com>
	 <3efb10970711170344n670d8b69w6679d494922c5bb@mail.gmail.com>
	 <1195316550.25393.21.camel@imap.mvista.com>
	 <3efb10970711170909n3acca605j70525e36faf8da7f@mail.gmail.com>
	 <1195320569.25393.38.camel@imap.mvista.com>
	 <20071117174608.GA30641@elte.hu>
	 <1195322141.25393.41.camel@imap.mvista.com>
	 <20071117180430.GA10768@elte.hu>
	 <1195323177.25393.56.camel@imap.mvista.com>
Content-Type: text/plain
Date: Sun, 18 Nov 2007 13:33:50 +0100
Message-Id: <1195389230.6747.5.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-11-17 at 10:12 -0800, Daniel Walker wrote:

> What specifically is wrong with dev->sem ?

Nothing really, other than that they use semaphores to avoid lockdep :-/

I think I know how to annotate this, after Alan Stern explained all the
use cases, but I haven't come around to implementing it. Hope to do that
soonish.

Another real semaphore user is XFS, they really use the down/up
asymmetry that semaphores allow, last time I spoke with Dave Chinner he
didn't know a way around this.

