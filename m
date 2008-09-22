Return-Path: <linux-kernel-owner+w=401wt.eu-S1753500AbYIVPOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbYIVPOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 11:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbYIVPOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 11:14:38 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:52459 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbYIVPOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 11:14:37 -0400
Subject: Re: [patch] mm: tiny-shmem fix lor, mmap_sem vs i_mutex
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: David Howells <dhowells@redhat.com>, Matt Mackall <mpm@selenic.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, Dave Hansen <haveblue@us.ibm.com>
In-Reply-To: <Pine.LNX.4.64.0809201649400.13926@blonde.site>
References: <20080910121217.GA16013@elte.hu>
	 <20080910144812.GB18644@wotan.suse.de>
	 <1221058864.30429.291.camel@twins.programming.kicks-ass.net>
	 <20080910152651.GE18644@wotan.suse.de> <20080911082709.GA14378@elte.hu>
	 <20080914073906.GA6184@elte.hu>
	 <20080914004442.4f8e851f.akpm@linux-foundation.org>
	 <20080914080631.GA10720@elte.hu> <20080914221231.GG27080@wotan.suse.de>
	 <20080917131419.e6b7622e.akpm@linux-foundation.org>
	 <20080918111226.GD29968@elte.hu>  <48D2ABFD.3040103@goop.org>
	 <1221772310.4779.29.camel@calx> <1221877119.8533.2.camel@nimitz>
	 <Pine.LNX.4.64.0809201649400.13926@blonde.site>
Content-Type: text/plain
Date: Mon, 22 Sep 2008 08:14:14 -0700
Message-Id: <1222096454.8533.18.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-09-20 at 17:12 +0100, Hugh Dickins wrote:
> It's not immediately obvious why two such similar functions needed
> two such dissimilar patches; and we'd all (Nick, Matt and I) prefer
> to restore the similarity, especially now the tiny-shmem.c variant
> has shown a locking problem.  Do you see any reason against that?

The only reason I diverged them was that I was trying to encourage the
use of alloc_file() and discourage the use of init_file() due to some
guidance from Christoph H.

But, you're certainly right, being able to find bugs between the two
implementations certainly trumps that, so I see no reason not to reunify
them.

-- Dave

