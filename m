Return-Path: <linux-kernel-owner+w=401wt.eu-S1759677AbXGXViV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759677AbXGXViV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 17:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753734AbXGXViF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 17:38:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:53746 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901AbXGXViE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 17:38:04 -0400
Subject: Re: [PATCH 6/8] i386: bitops: Don't mark memory as clobbered
	unnecessarily
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707241108360.3607@woody.linux-foundation.org>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
	 <20070723160558.22137.71943.sendpatchset@cselinux1.cse.iitk.ac.in>
	 <alpine.LFD.0.999.0707231054290.3607@woody.linux-foundation.org>
	 <1185270756.5439.256.camel@localhost.localdomain>
	 <alpine.LFD.0.999.0707241021210.3607@woody.linux-foundation.org>
	 <1185298932.6586.22.camel@localhost>
	 <alpine.LFD.0.999.0707241108360.3607@woody.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 25 Jul 2007 07:37:41 +1000
Message-Id: <1185313061.5439.283.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-24 at 11:13 -0700, Linus Torvalds wrote:
> 
> IOW, if you do a spinlock with the bitops, the locking side should be
> able 
> to use a "test_and_set_bit()" on its own, but the unlocking side
> should be
> 
>         smp_mb__before_clear_bit();
>         clear_bit();
> 
> because the ones that don't return a value also don't imply a memory 
> barrier.

Yup. But I much prefer Nick's clear_bit_unlock() :-)

Ben.


