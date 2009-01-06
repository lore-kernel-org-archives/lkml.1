Return-Path: <linux-kernel-owner+w=401wt.eu-S1753845AbZAFQn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbZAFQn7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 11:43:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750975AbZAFQns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 11:43:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52265 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750797AbZAFQnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 11:43:47 -0500
Date: Tue, 6 Jan 2009 08:42:41 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <peterz@infradead.org>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>, Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
In-Reply-To: <alpine.LFD.2.00.0901060833060.3057@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0901060841000.3057@localhost.localdomain>
References: <1230722935.4680.5.camel@think.oraclecorp.com> <20081231104533.abfb1cf9.akpm@linux-foundation.org> <1230765549.7538.8.camel@think.oraclecorp.com> <87r63ljzox.fsf@basil.nowhere.org> <20090103191706.GA2002@parisc-linux.org> <1231093310.27690.5.camel@twins>
 <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins> <20090106121052.GA27232@elte.hu> <alpine.LFD.2.00.0901060750410.3057@localhost.localdomain> <alpine.LFD.2.00.0901060808260.3057@localhost.localdomain>
 <alpine.LFD.2.00.0901060833060.3057@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Jan 2009, Linus Torvalds wrote:
> 
> Right now, if some process deadlocks on a mutex, we get hung process, but 
> with a nice backtrace and hopefully other things (that don't need that 
> lock) still continue to work.

Clarification: the "nice backtrace" we only get with something like 
sysrq-W, of course. We don't get a backtrace _automatically_, but with an 
otherwise live machine, there's a better chance that people do get wchan 
or other info. IOW, it's at least a fairly debuggable situation.

			Linus
