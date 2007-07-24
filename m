Return-Path: <linux-kernel-owner+w=401wt.eu-S935017AbXGXJxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935017AbXGXJxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 05:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758013AbXGXJxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 05:53:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:42912 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760038AbXGXJxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 05:53:04 -0400
Subject: Re: [PATCH 6/8] i386: bitops: Don't mark memory as clobbered
	unnecessarily
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707231054290.3607@woody.linux-foundation.org>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
	 <20070723160558.22137.71943.sendpatchset@cselinux1.cse.iitk.ac.in>
	 <alpine.LFD.0.999.0707231054290.3607@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 24 Jul 2007 19:52:36 +1000
Message-Id: <1185270756.5439.256.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-23 at 10:55 -0700, Linus Torvalds wrote:
> > The goal is to let gcc generate good, beautiful, optimized code.
> 
> No. The point is to let gcc generate *correct* code.
> 
> It's either "=m" together with "memory", or it's "+m".

In fact, it's more than that... the bitops that return a value are often
used to have hand-made spinlock semantics. I'm sure we would get funky
bugs if loads or stores leaked out of the locked region. I think a full
"memory" clobber should be kept around for those cases.

(That's also why on ppc, we give them a few more barriers)

Ben.

