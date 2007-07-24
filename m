Return-Path: <linux-kernel-owner+w=401wt.eu-S1759992AbXGXWdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759992AbXGXWdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 18:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756371AbXGXWdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 18:33:16 -0400
Received: from gate.crashing.org ([63.228.1.57]:40044 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756800AbXGXWdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 18:33:15 -0400
Subject: Re: [PATCH 6/8] i386: bitops: Don't mark memory as clobbered
	unnecessarily
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1185314112.6586.93.camel@localhost>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
	 <20070723160558.22137.71943.sendpatchset@cselinux1.cse.iitk.ac.in>
	 <alpine.LFD.0.999.0707231054290.3607@woody.linux-foundation.org>
	 <1185270756.5439.256.camel@localhost.localdomain>
	 <alpine.LFD.0.999.0707241021210.3607@woody.linux-foundation.org>
	 <1185298932.6586.22.camel@localhost>
	 <alpine.LFD.0.999.0707241108360.3607@woody.linux-foundation.org>
	 <1185313061.5439.283.camel@localhost.localdomain>
	 <1185314112.6586.93.camel@localhost>
Content-Type: text/plain
Date: Wed, 25 Jul 2007 08:32:48 +1000
Message-Id: <1185316368.5439.293.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-24 at 17:55 -0400, Trond Myklebust wrote:
> 
> If you want to use bitops as spinlocks you should rather be using
> <linux/bit_spinlock.h>. That also does the right thing w.r.t.
> pre-emption and sparse locking annotations.

Heh, I didn't know about those... A bit annoying that I can't override
them in the arch, I might be able to save a barrier or two here. Our
test_and_set_bit() contains both barriers for lock and unlock semantics
to cope with all kind of abuses, but your bit_spinlock obviously doesn't
need that.

Cheers,
Ben.

