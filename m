Return-Path: <linux-kernel-owner+w=401wt.eu-S1755395AbZGRJms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbZGRJms (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 05:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753868AbZGRJmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 05:42:47 -0400
Received: from www.tglx.de ([62.245.132.106]:47700 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752938AbZGRJmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 05:42:46 -0400
Date: Sat, 18 Jul 2009 11:41:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Barry Song <21cnbao@gmail.com>
cc: mingo@redhat.com, dahlmann.thomas@arcor.de,
       LKML <linux-kernel@vger.kernel.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] Delete redundant IRQ_DISABLED check in irq_thread
In-Reply-To: <3c17e3570907171626x3a319425wf0a813c079595f09@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0907181032210.11571@localhost.localdomain>
References: <1247820229-4983-1-git-send-email-21cnbao@gmail.com>  <alpine.LFD.2.00.0907171523100.11571@localhost.localdomain>  <3c17e3570907170758g337703b7l12e1c262d6f385bf@mail.gmail.com>  <alpine.LFD.2.00.0907171730070.11571@localhost.localdomain>
 <3c17e3570907171626x3a319425wf0a813c079595f09@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Jul 2009, Barry Song wrote:
> I guess people call disable_irq to disable the whole execution,
> specially to disable the hardirq(then both top and bottom are
> blocked). It's really strange the disable operation only blocks the
> bottom-half.

The disable blocks both. After the disable no hardirq comes in
anymore. 

The disabled check in the thread is just to take care of the case when
the disable comes in between the hardirq and the thread handler.

That way we avoid doing the full tracking of the hardirq / thread
chain simply because it is complex and would produce significant
overhead in the fast path for no gain. It could be done, but it's not
worth the trouble.

Thanks,

	tglx

