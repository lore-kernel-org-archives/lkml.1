Return-Path: <linux-kernel-owner+w=401wt.eu-S1761338AbYBNFvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761338AbYBNFvb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 00:51:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbYBNFvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 00:51:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33322 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482AbYBNFvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 00:51:21 -0500
Date: Thu, 14 Feb 2008 06:50:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] x86: make dump_pagetable() static
Message-ID: <20080214055052.GA29509@elte.hu>
References: <20080213213131.GA3383@cs181133002.pp.htv.fi> <1202941667.18204.14.camel@brick> <20080213223621.GC12383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213223621.GC12383@cs181133002.pp.htv.fi>
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


* Adrian Bunk <bunk@kernel.org> wrote:

> On Wed, Feb 13, 2008 at 02:27:47PM -0800, Harvey Harrison wrote:
> > On Wed, 2008-02-13 at 23:31 +0200, Adrian Bunk wrote:
> > > dump_pagetable() can now become static.
> > > 
> > > Signed-off-by: Adrian Bunk <bunk@kernel.org>

thanks, applied.

> > I believe Andi Kleen wanted this kept global to make it easy to use 
> > when adding debugging code elsewhere.
> 
> That's not a reason as long as his code isn't in the tree (and he 
> anyway has to patch the kernel for using it).

correct. There's also a new CONFIG_X86_PTDUMP=y pagetable dumping debug 
feature now in x86.git#mm that produces much nicer output.

Arjan: i it might be nice to make the new pagetable dumper triggerable 
from a SysRq - could you try the kernel/time/timer_list.c's SEQ_printf() 
trick to make the dumping dual-purpose? [so that it printk()'s if it 
should dump to the console and seq_printf()'s if it should dump via 
/proc]

	Ingo
