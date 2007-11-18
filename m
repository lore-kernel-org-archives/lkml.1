Return-Path: <linux-kernel-owner+w=401wt.eu-S1757299AbXKRA5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299AbXKRA5w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 19:57:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754001AbXKRA5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 19:57:45 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49937 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753624AbXKRA5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 19:57:45 -0500
Date: Sat, 17 Nov 2007 16:57:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       tglx@tglx.de
Subject: Re: [patch] Printk kernel version in WARN_ON
Message-Id: <20071117165719.c8d7bb48.akpm@linux-foundation.org>
In-Reply-To: <20071118004218.GA26865@elte.hu>
References: <20071117101552.2a7f34cb@laptopd505.fenrus.org>
	<20071117102720.251107d7.akpm@linux-foundation.org>
	<20071117103947.5b2052f8@laptopd505.fenrus.org>
	<20071117104652.8240af62.akpm@linux-foundation.org>
	<20071117113501.5e3e0d43@laptopd505.fenrus.org>
	<20071118004218.GA26865@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Nov 2007 01:42:18 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Arjan van de Ven <arjan@infradead.org> wrote:
> 
> > ok so how about putting the same into dump_stack() instead? (see 
> > below) added bonus is that it's now present for all dumps that use 
> > dump_stack(), not just WARN_ON() (the format I copied from the exact 
> > line used by oopses)
> 
> nice! I did things like this in -rt because it really helps to know 
> which process does a WARN_ON() or raw dump_stack().
> 
> > Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> 
> Acked-by: Ingo Molnar <mingo@elte.hu>
> 
> unless objections we'll put this into the x86 git tree.
> 

Should be done for all architectures, methinks.

If so, an appropriate way to do that would be to do
s/dump_stack/arch_dump_stack/ and do a single all-arch implementation of
dump_stack().  (Where we might add new goodies in the future).

Problem is that this will add a new an pointless entry to all the stack
dumps, unless the arch_dump_stack() implementation is smart enough to skip the
innermost frame.

