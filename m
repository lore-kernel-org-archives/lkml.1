Return-Path: <linux-kernel-owner+w=401wt.eu-S1758190AbYE3HGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190AbYE3HGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 03:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754058AbYE3HGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 03:06:05 -0400
Received: from ozlabs.org ([203.10.76.45]:33064 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754048AbYE3HGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 03:06:04 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 04/41] cpu ops: Core piece for generic atomic per cpu operations
Date: Fri, 30 May 2008 17:05:42 +1000
User-Agent: KMail/1.9.9
Cc: Christoph Lameter <clameter@sgi.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Travis <travis@sgi.com>
References: <20080530035620.587204923@sgi.com> <Pine.LNX.4.64.0805292214280.12107@schroedinger.engr.sgi.com> <20080529223825.bf744d37.akpm@linux-foundation.org>
In-Reply-To: <20080529223825.bf744d37.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805301705.43594.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 May 2008 15:38:25 Andrew Morton wrote:
> On Thu, 29 May 2008 22:17:55 -0700 (PDT) Christoph Lameter 
<clameter@sgi.com> wrote:
> > But then its related to percpu operations and relies extensively on the
> > various percpu.h files in asm-generic and asm-arch and include/linux
>
> Well that should be fixed.  We should never have mixed the
> alloc_percpu() and DEFINE_PER_CPU things inthe same header.  They're
> different.
>
> otoh as you propose removing the old alloc_percpu() I guess the end
> result is no worse than what we presently have.

No, the worst thing is that this is a great deal of churn which doesn't 
actually fix the "running out of per-cpu memory" problem.

It can, and should, be fixed, before changing dynamic percpu alloc to use the 
same percpu pool.

Rusty.
