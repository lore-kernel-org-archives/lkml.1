Return-Path: <linux-kernel-owner+w=401wt.eu-S1756023AbZBTSiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023AbZBTSiV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 13:38:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbZBTSiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 13:38:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51446 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbZBTSiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 13:38:11 -0500
Message-ID: <499EF77E.8060901@zytor.com>
Date: Fri, 20 Feb 2009 10:33:34 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Huang Ying <ying.huang@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH] x86: use the right protections for split-up pagetables
References: <20090220011316.379904625@goodmis.org> <alpine.LFD.2.00.0902191753240.21686@localhost.localdomain> <alpine.DEB.1.10.0902192107230.31658@gandalf.stny.rr.com> <alpine.LFD.2.00.0902191923300.21686@localhost.localdomain> <20090220072915.GB28085@elte.hu> <alpine.LFD.2.00.0902200728520.21686@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902200728520.21686@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> The confusion? When it moves the 'ref_prot' bits from the upper level, it 
> doesn't do the right thing for the PAT bit. That bit is special, and moves 
> around depending on level. In the upper levels, it's bit#12, and in the 
> final 4k pte level it's bit#7.
> 

... and in the second level of two-level page tables, it doesn't exist
at all.

Worse, there are errata on some processors (not sure if there are any we
currently don't blacklist) where the PATx bit logic basically gets fed
random data.  Setting up the PAT so that the lower and upper half alias
works around this.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

