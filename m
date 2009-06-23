Return-Path: <linux-kernel-owner+w=401wt.eu-S1757684AbZFWAdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684AbZFWAdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 20:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbZFWAdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 20:33:10 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:52936 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542AbZFWAdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 20:33:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19008.8898.461780.370964@cargo.ozlabs.ibm.com>
Date: Tue, 23 Jun 2009 10:33:06 +1000
From: Paul Mackerras <paulus@samba.org>
To: eranian@gmail.com
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andi Kleen <andi@firstfloor.org>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <cel@us.ibm.com>, Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: I.5 - Mmaped count
In-Reply-To: <7c86c4470906220525x409bedadj29be01236e42ea1@mail.gmail.com>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
	<20090622115239.GF24366@elte.hu>
	<7c86c4470906220525x409bedadj29be01236e42ea1@mail.gmail.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stephane eranian writes:

> Unless you tell me that pc->index is marked invalid (0) when the
> event is not scheduled. I don't see how you can avoid reading
> the wrong value. I am assuming that is the event is not scheduled
> lock remains constant.

That's what happens; when pc->index == 0, the event is not scheduled
and the current count is in pc->offset.

> Assuming the event is active when you enter the loop and you
> read a value. How to get the timing information to scale the
> count?

At present you'd have to do a read().  It wouldn't be hard to add
fields to mmapped page to enable the user program to compute
up-to-date timing information from the TSC (x86) or timebase (powerpc)
value.  We'll do that.

Paul.
