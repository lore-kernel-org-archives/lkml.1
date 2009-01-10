Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782AbZAJX70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbZAJX70 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 18:59:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753916AbZAJX7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 18:59:16 -0500
Received: from gw.goop.org ([64.81.55.164]:47685 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176AbZAJX7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 18:59:14 -0500
Message-ID: <49693649.1020406@goop.org>
Date: Sun, 11 Jan 2009 10:59:05 +1100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Chris Mason <chris.mason@oracle.com>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
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
References: <1231441350.14304.48.camel@think.oraclecorp.com> <alpine.LFD.2.00.0901081109300.3283@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0901081109300.3283@localhost.localdomain>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Actually, the real spin locks are now fair. We use ticket locks on x86.
>
> Well, at least we do unless you enable that broken paravirt support. I'm 
> not at all clear on why CONFIG_PARAVIRT wants to use inferior locks, but I 
> don't much care.
>   

No, it will continue to use ticket locks, but there's the option to 
switch to byte locks or something else.  Ticket locks are awesomely bad 
when the VCPU scheduler fights with the run-order required by the ticket 
order.

    J
