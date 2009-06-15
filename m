Return-Path: <linux-kernel-owner+w=401wt.eu-S1753208AbZFOEbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbZFOEbR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 00:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbZFOEbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 00:31:03 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:42183 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbZFOEbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 00:31:02 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18997.52863.576426.501025@cargo.ozlabs.ibm.com>
Date: Mon, 15 Jun 2009 14:30:55 +1000
From: Paul Mackerras <paulus@samba.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: Avi Kivity <avi@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       benh@kernel.crashing.org, akpm@linux-foundation.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] lib: Provide generic atomic64_t implementation
In-Reply-To: <ada4ouixlk2.fsf@cisco.com>
References: <18995.20685.227683.561827@cargo.ozlabs.ibm.com>
	<alpine.LFD.2.01.0906131312470.3237@localhost.localdomain>
	<alpine.LFD.2.01.0906131323270.3237@localhost.localdomain>
	<4A34E4A5.3040306@redhat.com>
	<18996.60235.178618.531664@cargo.ozlabs.ibm.com>
	<4A34F564.2010500@redhat.com>
	<ada4ouixlk2.fsf@cisco.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier writes:

> FWIW, Nehalem EX actually goes to 8 cores/16 threads per socket.  But
> worrying about 32-bit performance on Nehalem is a little silly -- this
> simplest solution is simply to run a 64-bit kernel.

I'm not worried about ANY x86 processor, 32-bit or 64-bit, in fact,
since x86 already has an atomic64_t implementation for both 32-bit and
64-bit.

It is interesting, though, that arch/x86/include/asm/atomic_32.h
unconditionally uses cmpxchg8b to implement atomic64_t, but I thought
that cmpxchg8b didn't exist in processors prior to the Pentium.
Presumably you can't use perf_counters on a 386 or 486.

Paul.
