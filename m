Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbZAIRlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbZAIRlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 12:41:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbZAIRl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 12:41:26 -0500
Received: from twin.jikos.cz ([213.151.79.26]:34805 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900AbZAIRlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 12:41:25 -0500
Date: Fri, 9 Jan 2009 18:40:31 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Peter Zijlstra <peterz@infradead.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Mason <chris.mason@oracle.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
       Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
In-Reply-To: <1231442609.27687.1.camel@twins>
Message-ID: <alpine.LRH.1.10.0901091815140.24105@twin.jikos.cz>
References: <1231441350.14304.48.camel@think.oraclecorp.com>  <alpine.LFD.2.00.0901081109300.3283@localhost.localdomain> <1231442609.27687.1.camel@twins>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jan 2009, Peter Zijlstra wrote:

> > Well, at least we do unless you enable that broken paravirt support. 
> > I'm not at all clear on why CONFIG_PARAVIRT wants to use inferior 
> > locks, but I don't much care.
> Because the virtual cpu that has the ticket might not get scheduled for
> a while, even though another vcpu with a spinner is scheduled.
> The whole (para)virt is a nightmare in that respect.

Hmm, are we in fact really using byte locks in CONFIG_PARAVIRT situation? 
Where are we actually setting pv_lock_ops.spin_lock pointer to point to 
__byte_spin_lock?

Such initialization seems to happen only in paravirt_use_bytelocks() 
function, but my blind eyes prevent me from finding a callsite from which 
this function would eventually get called.

-- 
Jiri Kosina
SUSE Labs

