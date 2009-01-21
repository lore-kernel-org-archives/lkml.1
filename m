Return-Path: <linux-kernel-owner+w=401wt.eu-S1760100AbZAUB1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760100AbZAUB1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 20:27:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755682AbZAUB1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 20:27:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56956 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508AbZAUB1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 20:27:03 -0500
Message-ID: <497678CC.5060703@zytor.com>
Date: Tue, 20 Jan 2009 17:22:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Bernd Schmidt <bernds_cb1@t-online.de>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>, jh@suse.cz
Subject: Re: gcc inlining heuristics was Re: [PATCH -v7][RFC]: mutex:	implement
 adaptive spinning
References: <alpine.LFD.2.00.0901121128080.6528@localhost.localdomain> <496BBE27.2020206@t-online.de> <20090119001345.GA9880@elte.hu> <20090119062212.GC22584@wotan.suse.de> <alpine.LFD.2.00.0901200754100.2974@localhost.localdomain> <20090120005124.GD16304@wotan.suse.de> <20090120123824.GD7790@elte.hu> <1232480940.22233.1435.camel@macbook.infradead.org> <20090120210515.GC19710@elte.hu> <alpine.LFD.2.00.0901210814130.2892@localhost.localdomain> <20090120220516.GA10483@elte.hu>
In-Reply-To: <20090120220516.GA10483@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> Hm, GCC uses __restrict__, right?
> 
> I'm wondering whether there's any internal tie-up between alias analysis 
> and the __restrict__ keyword - so if we turn off aliasing optimizations 
> the __restrict__ keyword's optimizations are turned off as well.
> 

Actually I suspect that "restrict" makes little difference for inlines 
or even statics, since gcc generally can do alias analysis fine there. 
However, in the presence of an intermodule function call, all alias 
analysis is off.  This is presumably why type-based analysis is used at 
all ... to at least be able to a modicum of, say, loop invariant removal 
in the presence of a library call.  This is also where "restrict" comes 
into play.

	-hpa

