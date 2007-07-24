Return-Path: <linux-kernel-owner+w=401wt.eu-S1759392AbXGXVza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392AbXGXVza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 17:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755899AbXGXVzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 17:55:22 -0400
Received: from pat.uio.no ([129.240.10.15]:52335 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755815AbXGXVzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 17:55:21 -0400
Subject: Re: [PATCH 6/8] i386: bitops: Don't mark memory as clobbered
	unnecessarily
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1185313061.5439.283.camel@localhost.localdomain>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
	 <20070723160558.22137.71943.sendpatchset@cselinux1.cse.iitk.ac.in>
	 <alpine.LFD.0.999.0707231054290.3607@woody.linux-foundation.org>
	 <1185270756.5439.256.camel@localhost.localdomain>
	 <alpine.LFD.0.999.0707241021210.3607@woody.linux-foundation.org>
	 <1185298932.6586.22.camel@localhost>
	 <alpine.LFD.0.999.0707241108360.3607@woody.linux-foundation.org>
	 <1185313061.5439.283.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 24 Jul 2007 17:55:12 -0400
Message-Id: <1185314112.6586.93.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.082)
X-UiO-Scanned: A9F6EDCD4D118B00595E99831430451F7D788507
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 429 total 2956901 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-25 at 07:37 +1000, Benjamin Herrenschmidt wrote:
> On Tue, 2007-07-24 at 11:13 -0700, Linus Torvalds wrote:
> > 
> > IOW, if you do a spinlock with the bitops, the locking side should be
> > able 
> > to use a "test_and_set_bit()" on its own, but the unlocking side
> > should be
> > 
> >         smp_mb__before_clear_bit();
> >         clear_bit();
> > 
> > because the ones that don't return a value also don't imply a memory 
> > barrier.
> 
> Yup. But I much prefer Nick's clear_bit_unlock() :-)
> 
> Ben

If you want to use bitops as spinlocks you should rather be using
<linux/bit_spinlock.h>. That also does the right thing w.r.t.
pre-emption and sparse locking annotations.

Trond

