Return-Path: <linux-kernel-owner+w=401wt.eu-S1758592AbZFNMVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592AbZFNMVm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 08:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755177AbZFNMVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 08:21:34 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:47839 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629AbZFNMVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 08:21:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18996.60235.178618.531664@cargo.ozlabs.ibm.com>
Date: Sun, 14 Jun 2009 22:21:31 +1000
From: Paul Mackerras <paulus@samba.org>
To: Avi Kivity <avi@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, benh@kernel.crashing.org,
       akpm@linux-foundation.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] lib: Provide generic atomic64_t implementation
In-Reply-To: <4A34E4A5.3040306@redhat.com>
References: <18995.20685.227683.561827@cargo.ozlabs.ibm.com>
	<alpine.LFD.2.01.0906131312470.3237@localhost.localdomain>
	<alpine.LFD.2.01.0906131323270.3237@localhost.localdomain>
	<4A34E4A5.3040306@redhat.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity writes:

> An alternative implementation using 64-bit cmpxchg will recover most of 
> the costs of hashed spinlocks.  I assume most serious 32-bit 
> architectures have them?

Have a 64-bit cmpxchg, you mean?  x86 is the only one I know of, and
it already has an atomic64_t implementation using cmpxchg8b (or
whatever it's called).

My thinking is that the 32-bit non-x86 architectures will be mostly
UP, so the overhead is just an interrupt enable/restore.  Those that
are SMP I would expect to be small SMP -- mostly just 2 cpus and maybe
a few 4-way systems.

Paul.
