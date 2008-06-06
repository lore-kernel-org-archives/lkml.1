Return-Path: <linux-kernel-owner+w=401wt.eu-S1762127AbYFFAdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762127AbYFFAdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 20:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbYFFAdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 20:33:05 -0400
Received: from ozlabs.org ([203.10.76.45]:43106 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129AbYFFAdD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 20:33:03 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [patch 02/41] cpu alloc: The allocator
Date: Fri, 6 Jun 2008 10:32:47 +1000
User-Agent: KMail/1.9.9
Cc: Mike Travis <travis@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Peter Zijlstra <peterz@infradead.org>
References: <20080530035620.587204923@sgi.com> <4846AD84.2090800@sgi.com> <4846B084.6000607@cosmosbay.com>
In-Reply-To: <4846B084.6000607@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806061032.47598.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 June 2008 01:11:00 Eric Dumazet wrote:
> Mike Travis a écrit :
> > I'm a bit confused.  Why is DEFINE_PER_CPU_SHARED_ALIGNED() conditioned
> > on ifdef MODULE?
> Because we had crashes when loading oprofile module, when a previous
> version of oprofile used to use DEFINE_PER_CPU_SHARED_ALIGNED variable
>
> module loader only takes into account the special section ".data.percpu"
> and ignores ".data.percpu.shared_aligned"
>
> I therefore submitted two patches :

Put one way, putting page-aligned per-cpu data in a separate section is a 
space-saving hack: one which is not really required for modules because of 
the low frequency of such variables.  Put another way, not respecting 
the .data.percpu.shared_aligned section in modules is a bug.

But a comment would probably be nice!

Cheers,
Rusty.
