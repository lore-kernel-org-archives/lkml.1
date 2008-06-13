Return-Path: <linux-kernel-owner+w=401wt.eu-S1759275AbYFMAii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275AbYFMAii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 20:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756688AbYFMAi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 20:38:28 -0400
Received: from ozlabs.org ([203.10.76.45]:33268 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756349AbYFMAi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 20:38:28 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch 04/41] cpu ops: Core piece for generic atomic per cpu operations
Date: Fri, 13 Jun 2008 10:38:12 +1000
User-Agent: KMail/1.9.9
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Martin Peschke <mp3@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Travis <travis@sgi.com>
References: <20080530035620.587204923@sgi.com> <200806122121.09835.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0806121017010.30597@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0806121017010.30597@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806131038.12987.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 June 2008 03:19:51 Christoph Lameter wrote:
> Populating the per cpu areas on demand is a good thing especially for
> configurations with a large number of processors. If we really go to 
> support 4k processor by default then we need to allocate the smallest
> amount of per cpu structures necessary.  Maybe ACPI or so can tell us how 
> many processors are possible and we only allocate those. But it would be
> best if the percpu structures are only allocated for actually active
> processors.

cpu_possible_map should definitely be minimal, but your point is well made: 
dynamic percpu could actually cut memory allocation.  If we go for a hybrid 
scheme where static percpu is always allocated from the initial chunk, 
however, we still need the current pessimistic overallocation.

Mike's a clever guy, I'm sure he'll think of something :)
Rusty.
