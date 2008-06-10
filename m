Return-Path: <linux-kernel-owner+w=401wt.eu-S1755715AbYFJRdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715AbYFJRdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 13:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbYFJRda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 13:33:30 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50796 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752331AbYFJRda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 13:33:30 -0400
Date: Tue, 10 Jun 2008 10:33:29 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mike Travis <travis@sgi.com>
cc: Eric Dumazet <dada1@cosmosbay.com>, akpm@linux-foundation.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 02/41] cpu alloc: The allocator
In-Reply-To: <4846AD84.2090800@sgi.com>
Message-ID: <Pine.LNX.4.64.0806101032550.17131@schroedinger.engr.sgi.com>
References: <20080530035620.587204923@sgi.com> <20080530040011.084909898@sgi.com>
 <483F8AF7.9000309@cosmosbay.com> <Pine.LNX.4.64.0805292219220.12107@schroedinger.engr.sgi.com>
 <4846AD84.2090800@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2008, Mike Travis wrote:

> I'm a bit confused.  Why is DEFINE_PER_CPU_SHARED_ALIGNED() conditioned on
> ifdef MODULE?
> 
>         #ifdef MODULE
>         #define SHARED_ALIGNED_SECTION ".data.percpu"
>         #else
>         #define SHARED_ALIGNED_SECTION ".data.percpu.shared_aligned"
>         #endif
> 
>         #define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)                       \
>                 __attribute__((__section__(SHARED_ALIGNED_SECTION)))            \
>                 PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name             \
>                 ____cacheline_aligned_in_smp

Looks wrong to me. There can be shared objects even without modules.

