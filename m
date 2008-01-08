Return-Path: <linux-kernel-owner+w=401wt.eu-S1756723AbYAHQaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbYAHQaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 11:30:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbYAHQ3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 11:29:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59741 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbYAHQ3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 11:29:49 -0500
Date: Tue, 8 Jan 2008 17:16:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       dmitry.adamushko@gmail.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Paul Mackerras <paulus@samba.org>, Linas Vepstas <linas@austin.ibm.com>,
       Kumar Gala <galak@kernel.crashing.org>
Subject: [powerpc crash] Re: Linux 2.6.24-rc7  kernel BUG at
	kernel/sched.c:5156!
Message-ID: <20080108161617.GC32273@elte.hu>
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <47821774.8010701@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47821774.8010701@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> Hi,
> 
> When booting the 2.6.24-rc7 kernel on the powerpc, kernel bug at
> kernel.sched.c is triggered
> 
> [    0.000000] Kernel command line: ro console=hvc0 rhgb quiet root=LABEL=/ 
> [    0.149567] BUG: scheduling while atomic: kthreadd/2/0x0006f34c
> [    0.149655] BUG: scheduling while atomic: kthreadd/3/0xbe0d8168
> [    0.149714] ------------[ cut here ]------------
> [    0.149722] kernel BUG at kernel/sched.c:5156!

hm, that looks pretty nasty. Wondering why the atomic check did not 
produce a stacktrace. By the time we get to the migration thread's code 
it's probably late and we just get to see the effects of data 
corruption.

	Ingo
