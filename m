Return-Path: <linux-kernel-owner+w=401wt.eu-S1754339AbYKZDU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbYKZDU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 22:20:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190AbYKZDUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 22:20:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49291 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532AbYKZDUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 22:20:48 -0500
Date: Tue, 25 Nov 2008 22:20:45 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Paul Mundt <lethal@linux-sh.org>
cc: Liming Wang <liming.wang@windriver.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ftrace: adding other non-leaving .text sections
In-Reply-To: <20081126030446.GA14685@linux-sh.org>
Message-ID: <alpine.DEB.1.10.0811252220230.26424@gandalf.stny.rr.com>
References: <1227666566-9044-1-git-send-email-liming.wang@windriver.com> <alpine.DEB.1.10.0811252201270.26424@gandalf.stny.rr.com> <20081126030446.GA14685@linux-sh.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 26 Nov 2008, Paul Mundt wrote:

> On Tue, Nov 25, 2008 at 10:03:35PM -0500, Steven Rostedt wrote:
> > 
> > On Wed, 26 Nov 2008, Liming Wang wrote:
> > 
> > > Please review this patch, and I don't know whether new sections will conflict 
> > > with sched tracer or others. 
> > > This patch is against Steven tree's tip/devel latest commit.
> > > 
> > > Impact: improve recordmcount.pl
> > > 
> > > Besides .text section, there are three .text sections that won't
> > > be freed after kernel booting. They are: .sched.text, .spinlock.text
> > > and .kprobes.text, which contain functions we can trace. But the last
> > > section ".kprobes.text" is particular, which has been marked as "notrace",
> > > we ignore it. Thus we add other two sections.
> > 
> > Yep, only those sections that we know will not disappear are OK. I was
> > conservative with only using ".text" but I knew there were other sections 
> > that were OK, so I used the hash array to make it easy to add others.
> > 
> Does your .text cover .text.head by the way?

No, you can add it if it is safe to trace, and it will not ever disappear.

-- Steve

