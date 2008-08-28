Return-Path: <linux-kernel-owner+w=401wt.eu-S1755302AbYH1BDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302AbYH1BDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 21:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbYH1BDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 21:03:03 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:36879 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752806AbYH1BDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 21:03:01 -0400
Date: Thu, 28 Aug 2008 10:02:26 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: David Miller <davem@davemloft.net>
Cc: bunk@kernel.org, torvalds@linux-foundation.org, rusty@rustcorp.com.au,
       Alan.Brunelle@hp.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, akpm@linux-foundation.org,
       arjan@linux.intel.com, mingo@elte.hu, linux-embedded@vger.kernel.org
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
Message-ID: <20080828010226.GB18893@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	David Miller <davem@davemloft.net>, bunk@kernel.org,
	torvalds@linux-foundation.org, rusty@rustcorp.com.au,
	Alan.Brunelle@hp.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
	kernel-testers@vger.kernel.org, akpm@linux-foundation.org,
	arjan@linux.intel.com, mingo@elte.hu,
	linux-embedded@vger.kernel.org
References: <20080827160052.GA15968@linux-sh.org> <20080827173544.GH11734@cs181140183.pp.htv.fi> <20080828003211.GA18893@linux-sh.org> <20080827.174605.85608276.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080827.174605.85608276.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 05:46:05PM -0700, David Miller wrote:
> From: Paul Mundt <lethal@linux-sh.org>
> Date: Thu, 28 Aug 2008 09:32:13 +0900
> 
> > On Wed, Aug 27, 2008 at 08:35:44PM +0300, Adrian Bunk wrote:
> > > CONFIG_DEBUG_STACKOVERFLOW should give you the same information, and if
> > > wanted with an arbitrary limit.
> >
> > In some cases, yes. In the CONFIG_DEBUG_STACKOVERFLOW case the check is
> > only performed from do_IRQ(), which is sporadic at best, especially on
> > tickless. While it catches some things, it's not a complete solution in
> > and of iteslf.
> 
> BTW, on sparc64 we have a stack overflow checker that runs via
> the profiling _mcount hook.  So every function call we check
> if the stack is getting overused.
> 
> If so, we jump onto a special static debugging stack and print
> the stack overflow message.
> 
> And yes it works with IRQ stacks which is all that sparc64 uses
> nowadays.
> 
> Perhaps this is useful enough to make generic.

Thanks for the pointer, I'll take a look at it!
