Return-Path: <linux-kernel-owner+w=401wt.eu-S964821AbXC0FHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964821AbXC0FHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 01:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964873AbXC0FHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 01:07:52 -0400
Received: from gate.crashing.org ([63.228.1.57]:45949 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964821AbXC0FHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 01:07:52 -0400
Subject: Re: [PATCH] genirq: do not mask interrupts by default
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@osdl.org>, Thomas Gleixner <tglx@linutronix.de>,
       Paul Mackerras <paulus@samba.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>
In-Reply-To: <200702161759.l1GHxsO8010669@hera.kernel.org>
References: <200702161759.l1GHxsO8010669@hera.kernel.org>
Content-Type: text/plain
Date: Tue, 27 Mar 2007 15:07:17 +1000
Message-Id: <1174972037.5329.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-16 at 17:59 +0000, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=76d2160147f43f982dfe881404cfde9fd0a9da21
> Commit:     76d2160147f43f982dfe881404cfde9fd0a9da21
> Parent:     1f2ea0837dbc263ce2a2512c4e73c83df68a6a55
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Fri Feb 16 01:28:24 2007 -0800
> Committer:  Linus Torvalds <torvalds@woody.linux-foundation.org>
> CommitDate: Fri Feb 16 08:14:00 2007 -0800
> 
>     [PATCH] genirq: do not mask interrupts by default
>     
>     Never mask interrupts immediately upon request.  Disabling interrupts in
>     high-performance codepaths is rare, and on the other hand this change could
>     recover lost edges (or even other types of lost interrupts) by conservatively
>     only masking interrupts after they happen.  (NOTE: with this change the
>     highlevel irq-disable code still soft-disables this IRQ line - and if such an
>     interrupt happens then the IRQ flow handler keeps the IRQ masked.)
>     
>     Mark i8529A controllers as 'never loses an edge'.

I missed that one ... thanks for not telling/CC'ing me and not fixing
powerpc :-( (I know, everybody is supposed to have the bandwidth to read
all of lkml... I don't).

We need to audit all of our PICs to make sure they can deal with
disabling an already ack'ed interrupt, which isn't clear.. in fact, that
might cause some to lose it when re-enabling later on. This is a major
semantic change and now I just discover it while we are at -rc5 !

I'm concerned that quite a few PICs will not re-emit the interrupt once
re-enabled.

Ben.


