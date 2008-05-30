Return-Path: <linux-kernel-owner+w=401wt.eu-S1759424AbYE3FUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759424AbYE3FUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 01:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbYE3FUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 01:20:46 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42119 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752771AbYE3FUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 01:20:46 -0400
Date: Thu, 29 May 2008 22:20:45 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
Subject: Re: [patch 02/41] cpu alloc: The allocator
In-Reply-To: <483F8AF7.9000309@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0805292219220.12107@schroedinger.engr.sgi.com>
References: <20080530035620.587204923@sgi.com> <20080530040011.084909898@sgi.com>
 <483F8AF7.9000309@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2008, Eric Dumazet wrote:

> > +static DEFINE_PER_CPU(UNIT_TYPE, area[UNITS]);
> >   
> area[] is not guaranteed to be aligned on anything but 4 bytes.
> 
> If someone then needs to call cpu_alloc(8, GFP_KERNEL, 8), it might get an non
> aligned result.
> 
> Either you should add an __attribute__((__aligned__(PAGE_SIZE))),
> or take into account the real address of area[] in cpu_alloc() to avoid waste
> of up to PAGE_SIZE bytes
> per cpu.

I think cacheline aligning should be sufficient. People should not 
allocate large page aligned objects here.
