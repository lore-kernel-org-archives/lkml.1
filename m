Return-Path: <linux-kernel-owner+w=401wt.eu-S1763994AbXHFQ7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763994AbXHFQ7B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 12:59:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756172AbXHFQ6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 12:58:53 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:35973 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753433AbXHFQ6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 12:58:52 -0400
Subject: Re: [PATCH] RT: Add priority-queuing and priority-inheritance to
	workqueue infrastructure
From: Gregory Haskins <ghaskins@novell.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Daniel Walker <dwalker@mvista.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070806165007.GB4021@tv-sign.ru>
References: <20070801213422.GA280@tv-sign.ru>
	 <1186005598.9513.261.camel@ghaskins-t60p.haskins.net>
	 <20070801222201.GA316@tv-sign.ru>
	 <1186012439.9513.321.camel@ghaskins-t60p.haskins.net>
	 <20070802195049.GA361@tv-sign.ru>
	 <1186400154.21381.40.camel@ghaskins-t60p.haskins.net>
	 <20070806142616.GA210@tv-sign.ru>
	 <1186412235.21381.82.camel@ghaskins-t60p.haskins.net>
	 <20070806153655.GA245@tv-sign.ru>
	 <1186415403.21381.100.camel@ghaskins-t60p.haskins.net>
	 <20070806165007.GB4021@tv-sign.ru>
Content-Type: text/plain
Date: Mon, 06 Aug 2007 12:57:07 -0400
Message-Id: <1186419427.21381.123.camel@ghaskins-t60p.haskins.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-06 at 20:50 +0400, Oleg Nesterov wrote:
> Yes.
> 
> > Do you agree that if the context was the same there is a bug?  Or did I
> > miss something else?
> 
> Yes sure. We can't expect we can "flush" work_struct with flush_workqueue()
> unless we know it doesn't re-schedule itself.

Agreed.

> 
> OTOH, it is not the bug to call flush_workqueue() even if that work was
> queued by us, it should complete.

Well, I guess it depends on the application but that would be highly
unusual unless the flush was already superfluous to begin with.
Typically you only call flush to ensure a strongly ordered operation.
The reschedule defeats the strong ordering and thus would break anything
that was dependent on it.

But we are splitting hairs at this point since we both agree that the
API as put forth in the PI patch was deficient ;)

-Greg

