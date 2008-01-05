Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbYAEAum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbYAEAum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 19:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbYAEAuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 19:50:35 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41529 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753332AbYAEAue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 19:50:34 -0500
Date: Fri, 4 Jan 2008 16:49:06 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, Theodore Tso <tytso@mit.edu>,
       Andi Kleen <andi@firstfloor.org>, Christoph Lameter <clameter@sgi.com>,
       Willy Tarreau <w@1wt.eu>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch] slub: provide /proc/slabinfo
In-Reply-To: <20080104162705.44b61e9a@laptopd505.fenrus.org>
Message-ID: <alpine.LFD.1.00.0801041648470.2811@woody.linux-foundation.org>
References: <alpine.LFD.0.9999.0712221251110.21557@woody.linux-foundation.org> <20071222221050.GA20753@1wt.eu> <Pine.LNX.4.58.0712221954530.19187@gandalf.stny.rr.com> <20071223051241.GA4449@1wt.eu> <20071223141500.GB6430@one.firstfloor.org>
 <20071224034530.GB16658@thunk.org> <Pine.LNX.4.64.0712241120230.8849@schroedinger.engr.sgi.com> <20071224233701.GB9784@kernel.org> <20071225033418.GA29199@one.firstfloor.org> <20080101124741.GH11776@mit.edu> <20080101162328.GC20426@elte.hu>
 <20080104162705.44b61e9a@laptopd505.fenrus.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 4 Jan 2008, Arjan van de Ven wrote:
> 
> this is the part I'm not very thrilled about... at least on first sight 
> it looks like a user can now hold the read sem over system calls, and 
> for as long as it wants.

No, you misunderstand how seq-files work.

The start/stop sequence is done only overone single kernel buffer 
instance, not over the whole open/close (or even the copy to user space).

It's expressly designed so that you can hold locks (including spinlocks 
etc), and will not do any blocking ops (well - your *callbacks* can you 
blocking ops, but the seq_file stuff itself won't) between start/stop.

		Linus
