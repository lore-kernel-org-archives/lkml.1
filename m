Return-Path: <linux-kernel-owner+w=401wt.eu-S1756172AbXLJOCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbXLJOCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 09:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbXLJOCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 09:02:11 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:60096 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbXLJOCK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 09:02:10 -0500
Date: Mon, 10 Dec 2007 09:00:56 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: Major regression on hackbench with SLUB
In-Reply-To: <20071210073808.GA32112@atjola.homenet>
Message-ID: <Pine.LNX.4.58.0712100858480.3498@gandalf.stny.rr.com>
References: <1197049846.1645.68.camel@localhost.localdomain>
 <alpine.LFD.0.9999.0712070957070.7274@woody.linux-foundation.org>
 <alpine.LFD.0.9999.0712071021510.12046@woody.linux-foundation.org>
 <Pine.LNX.4.58.0712081702450.23837@gandalf.stny.rr.com>
 <20071210073808.GA32112@atjola.homenet>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 10 Dec 2007, Björn Steinbrink wrote:
> >
> > The results are here:
> >
> > http://people.redhat.com/srostedt/slub/results/slab.op
> > http://people.redhat.com/srostedt/slub/results/slub.op
>
> Hm, you seem to be hitting the "another_slab" stuff in __slab_alloc
> alot. I wonder if !node_match triggers too often. We always start with
> the per cpu slab, if that one is on the wrong node, you'll always hit
> that "another_slab" path.

Well, I commented out the node_match part and it got 100% worse. It took
30 seconds to complete.

>
> After searching for way too long (given that I have no clue about that
> stuff anyway and just read the code out of curiousness), I noticed that
> the the cpu_to_node stuff on x86_64 seems to be initialized to 0xff
> (arch/x86/mm/numa_64.c), and Google brought me this dmesg output [1],
> which, AFAICT, shows that the per cpu slab setup is done _before_
> cpu_to_node is correctly setup. That would lead to the per cpu slabs all
> having node == 0xff, which looks pretty bad.

I didn't check to see if the internal set up of the node is correct
though.  I can put in some debug to see what I get.

>
> Disclaimer: I read the slub/numa/$WHATEVER_I_SAW_THERE for the first
> time, so this might be total bull ;-)

Well I'm a newbie on NUMA stuff too. I just got lucky enough to be able to
reserve this box ;-)

-- Steve

