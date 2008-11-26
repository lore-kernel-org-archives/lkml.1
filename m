Return-Path: <linux-kernel-owner+w=401wt.eu-S1753664AbYKZDGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbYKZDGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 22:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbYKZDGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 22:06:10 -0500
Received: from mta23.gyao.ne.jp ([125.63.38.249]:8340 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751668AbYKZDGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 22:06:09 -0500
Date: Wed, 26 Nov 2008 12:04:46 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Liming Wang <liming.wang@windriver.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ftrace: adding other non-leaving .text sections
Message-ID: <20081126030446.GA14685@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Liming Wang <liming.wang@windriver.com>,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
References: <1227666566-9044-1-git-send-email-liming.wang@windriver.com> <alpine.DEB.1.10.0811252201270.26424@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811252201270.26424@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 10:03:35PM -0500, Steven Rostedt wrote:
> 
> On Wed, 26 Nov 2008, Liming Wang wrote:
> 
> > Please review this patch, and I don't know whether new sections will conflict 
> > with sched tracer or others. 
> > This patch is against Steven tree's tip/devel latest commit.
> > 
> > Impact: improve recordmcount.pl
> > 
> > Besides .text section, there are three .text sections that won't
> > be freed after kernel booting. They are: .sched.text, .spinlock.text
> > and .kprobes.text, which contain functions we can trace. But the last
> > section ".kprobes.text" is particular, which has been marked as "notrace",
> > we ignore it. Thus we add other two sections.
> 
> Yep, only those sections that we know will not disappear are OK. I was
> conservative with only using ".text" but I knew there were other sections 
> that were OK, so I used the hash array to make it easy to add others.
> 
Does your .text cover .text.head by the way?
