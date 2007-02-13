Return-Path: <linux-kernel-owner+w=401wt.eu-S1750841AbXBMQxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750841AbXBMQxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 11:53:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750843AbXBMQxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 11:53:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50238 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbXBMQxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 11:53:09 -0500
Date: Tue, 13 Feb 2007 17:49:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/11] ANNOUNCE: "Syslets", generic asynchronous system call support
Message-ID: <20070213164939.GA16394@elte.hu>
References: <20060529212109.GA2058@elte.hu> <20070213142010.GA638@elte.hu> <20070213150019.4b4d4827@localhost.localdomain> <p73hctqggfz.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73hctqggfz.fsf@bingen.suse.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.1.7
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > 	sys_exec and other security boundaries must be synchronous 
> > only and not allow async "spill over" (consider setuid async binary 
> > patching)
> 
> He probably would need some generalization of Andrea's seccomp work. 
> Perhaps using bitmaps? For paranoia I would suggest to white list, not 
> black list calls.

what i've implemented in my tree is sys_async_call_table[] which is a 
copy of sys_call_table[] with certain entries modified (by architecture 
level code, not by kernel/async.c) to sys_ni_syscall(). It's up to the 
architecture to decide which syscalls are allowed.

but i could use a bitmap too - whatever linear construct. [ I'm not sure 
there's much connection to seccomp - seccomp uses a NULL terminated 
whitelist - while syslets would use most of the entries (and would not 
want to have the overhead of checking a blacklist). ]

	Ingo
