Return-Path: <linux-kernel-owner+w=401wt.eu-S935960AbYEBSes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935960AbYEBSes (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 14:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933736AbYEBSeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 14:34:20 -0400
Received: from rn-out-0910.google.com ([64.233.170.185]:25020 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762956AbYEBSeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 14:34:19 -0400
Subject: Re: Preempt-RT patch for 2.6.25
From: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
To: Remy Bohmer <linux@bohmer.net>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>
In-Reply-To: <3efb10970805021102n4d87f55eue723786281b06fcb@mail.gmail.com>
References: <3efb10970805021102n4d87f55eue723786281b06fcb@mail.gmail.com>
Content-Type: text/plain
Organization: The Big Corporation
Date: Fri, 02 May 2008 11:34:10 -0700
Message-Id: <1209753250.25628.34.camel@dd.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-05-02 at 20:02 +0200, Remy Bohmer wrote:
> Hello Steven,
> 
> I was wondering: Is there a preempt-RT-patch planned for 2.6.25?
> I haven't seen one either for any of the 2.6.25-rc kernels at the
> usual place (http://www.kernel.org/pub/linux/kernel/projects/rt/),
> first time in history...
> Am I missing something?


Daniel has done a port, but I think it dropped some archs so its not
complete.


ftp://source.mvista.com/pub/dwalker/rt/patch-2.6.25-rc9-dw1-broken-out.tar.bz2

and updates, possibly:

ftp://source.mvista.com/pub/dwalker/rt/


His bi-sectability changes are pretty key, and I would like to see those
reviewed and incorporated, even if they apply only to x86.

The RT patch queue generally is a mess today. 
Lots of stuff needs to be folded down into the core patches.

The ins and outs of the softirq code need major clean-up.

There are big issues around apic / hardirq threads that we need to
tackle at multiple levels.

(we are seeing the semis acknowledge the IRQ thread model, where IRQs
may stay masked longer than usual)

per-device irq threads, as Jon Masters has mentioned in his blog, may be
one work-around to get past the legacy stuff in x86.

and with the x86 merge, all this should become easier, so that hopefully
we can extricate the IRQ threads changes in a bisectable way, so we can
address the technical issues that stand in the way of upstream, apart
from PREEMPT_RT.

Sven



