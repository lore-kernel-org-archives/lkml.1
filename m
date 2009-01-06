Return-Path: <linux-kernel-owner+w=401wt.eu-S1753945AbZAFRAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbZAFRAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 12:00:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbZAFRAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 12:00:39 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33689 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751194AbZAFRAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 12:00:38 -0500
Date: Tue, 6 Jan 2009 08:59:52 -0800 (PST)
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
In-Reply-To: <20090106165409.GA32608@elte.hu>
Message-ID: <alpine.LFD.2.00.0901060857360.3057@localhost.localdomain>
References: <1230765549.7538.8.camel@think.oraclecorp.com> <87r63ljzox.fsf@basil.nowhere.org> <20090103191706.GA2002@parisc-linux.org> <1231093310.27690.5.camel@twins> <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins>
 <20090106121052.GA27232@elte.hu> <alpine.LFD.2.00.0901060750410.3057@localhost.localdomain> <alpine.LFD.2.00.0901060808260.3057@localhost.localdomain> <alpine.LFD.2.00.0901060833060.3057@localhost.localdomain> <20090106165409.GA32608@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Jan 2009, Ingo Molnar wrote:
> 
> So instead of the BUG_ON() we could emit a WARN_ONCE() perhaps, plus not 
> do any spinning and just block - resulting in an uninterruptible task 
> (that the user will probably notice) and a scary message in the syslog? 
> [all in the slowpath]

Sure. You could put it in the adaptive function thing, with something like

	if (WARN_ONCE(waiter == owner))
		return 1;

which should fall back on the old behavior and do the one-time warning.

			Linus
