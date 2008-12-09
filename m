Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbYLIRwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbYLIRwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 12:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754562AbYLIRwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 12:52:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60613 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371AbYLIRwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 12:52:16 -0500
Date: Tue, 9 Dec 2008 12:52:13 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <clark.williams@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Gregory Haskins <ghaskins@novell.com>, Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [ANNOUNCE] The -rt git tree
In-Reply-To: <c62985530812090908i38c5a7bflcbbcce6c8b9cd2f9@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0812091248020.19115@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0812090946210.16798@gandalf.stny.rr.com> <c62985530812090908i38c5a7bflcbbcce6c8b9cd2f9@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 9 Dec 2008, Fr?d?ric Weisbecker wrote:
> 
> Hi Steve.
> 
> That's a good news.
> 
> But after converting these spinlocks into lock_t, how will you synchronize with
> the mainline on each release? You will have a huge amount of conflicts
> at every merges...

This is why master is separate from rt-master. The rt-master will grow 
like tip/master does. But the master will be recreated each time. 
Basically, the creation of master is this:


git checkout master
git reset --hard rt-master
./scripts/convert-spinlocks
git commit -a -m 'Convert all spinlocks to lock_t'
./scripts/convert-locks
git commit -a -m 'Convert some locks back to spinlock_t'

Thus we do not need to worry about the conflicts caused by the lock 
conversion. That will be done automatically each time we create a new 
master.

-- Steve

