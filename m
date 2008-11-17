Return-Path: <linux-kernel-owner+w=401wt.eu-S1753468AbYKQXW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbYKQXW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 18:22:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbYKQXWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 18:22:19 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:55270 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbYKQXWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 18:22:18 -0500
Date: Mon, 17 Nov 2008 18:22:04 -0500
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Large stack usage in fs code (especially for PPC64)
Message-ID: <20081117182204.0940d3a8@zod.rchland.ibm.com>
In-Reply-To: <1226963596.7178.254.camel@pasglop>
References: <alpine.DEB.1.10.0811171508300.8722@gandalf.stny.rr.com>
	<alpine.LFD.2.00.0811171300410.18283@nehalem.linux-foundation.org>
	<1226963596.7178.254.camel@pasglop>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2008 10:13:16 +1100
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> 
> > Well, it's not unacceptable on good CPU's with 4kB blocks (just an 8-entry 
> > array), but as you say:
> > 
> > > On PPC64 I'm told that the page size is 64K, which makes the above equal 
> > > to: 64K / 512 = 128  multiply that by 8 byte words, we have 1024 bytes.
> > 
> > Yeah. Not good. I think 64kB pages are insane. In fact, I think 32kB 
> > pages are insane, and 16kB pages are borderline. I've told people so.
> > 
> > The ppc people run databases, and they don't care about sane people 
> > telling them the big pages suck.
> 
> Hehe :-)
> 
> Guess who is pushing for larger page sizes nowadays ? Embedded
> people :-) In fact, we have patches submited on the list to offer the
> option for ... 256K pages on some 44x embedded CPUs :-)

For clarification, that workload is very precise.  Namely embedded 44x
CPUs used in RAID cards.  I'm not entirely convinced bringing 256K
pages into mainline is a good thing yet anyway.

64K pages, while seemingly insane for embedded boards that typically
have less than 512 MiB of DRAM, help for a bit larger set of
workloads.  As a KVM host is the primary winner at the moment.  But
given the small number of TLB entries on these CPUs, it can pay off
elsewhere as well.

josh
