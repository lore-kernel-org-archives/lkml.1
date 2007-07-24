Return-Path: <linux-kernel-owner+w=401wt.eu-S1756413AbXGXS3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413AbXGXS3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 14:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbXGXS3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 14:29:04 -0400
Received: from pat.uio.no ([129.240.10.15]:42630 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbXGXS3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 14:29:02 -0400
Subject: Re: [PATCH 6/8] i386: bitops: Don't mark memory as clobbered
	unnecessarily
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
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
Date: Tue, 24 Jul 2007 14:28:53 -0400
Message-Id: <1185301733.6586.38.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.083)
X-UiO-Scanned: 4A35F3B5FDE338C8B1B32F874025AF204F745528
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 314 total 2955175 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-24 at 11:13 -0700, Linus Torvalds wrote:
> 
> On Tue, 24 Jul 2007, Trond Myklebust wrote:
> > 
> > That's not what the Documentation/memory-barriers.txt states:
> 
> Hmm.. You're right. We only actually need it for the unconditional bitops, 
> like the *unlock* side.
> 
> IOW, if you do a spinlock with the bitops, the locking side should be able 
> to use a "test_and_set_bit()" on its own, but the unlocking side should be
> 
> 	smp_mb__before_clear_bit();
> 	clear_bit();
> 
> because the ones that don't return a value also don't imply a memory 
> barrier.

Yup, and this is exactly what we currently do in bit_spin_unlock().

Trond

