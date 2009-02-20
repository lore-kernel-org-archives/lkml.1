Return-Path: <linux-kernel-owner+w=401wt.eu-S1758014AbZBTCBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014AbZBTCBx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 21:01:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbZBTCBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 21:01:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56949 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751340AbZBTCBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 21:01:44 -0500
Date: Thu, 19 Feb 2009 18:00:48 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Steven Rostedt <rostedt@goodmis.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] changes for tip, and a nasty x86 page table bug 
In-Reply-To: <20090220011316.379904625@goodmis.org>
Message-ID: <alpine.LFD.2.00.0902191753240.21686@localhost.localdomain>
References: <20090220011316.379904625@goodmis.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 19 Feb 2009, Steven Rostedt wrote:
> 
> In doing this change, I stumbled upon a nasty bug in the page handling
> of the x86 code, where we can fall into a state where the PTE
> has the RW bit set, but the PMD does not.

How do we ever have a PMD that is read-only? That sounds like a bug to 
begin with. There's no reason to ever do that.

In fact, it should trigger the pmd_bad() tests if it ever happens, 
wouldn't it? We want all the _KERNPG_TABLE bits to always be set, no?

		Linus
