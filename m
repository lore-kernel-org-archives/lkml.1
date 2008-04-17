Return-Path: <linux-kernel-owner+w=401wt.eu-S932260AbYDQTLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260AbYDQTLK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 15:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbYDQTKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 15:10:54 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55773 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753467AbYDQTKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 15:10:53 -0400
Date: Thu, 17 Apr 2008 12:10:52 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Robin Holt <holt@sgi.com>, akpm@linux-foundation.org,
       Nick Piggin <npiggin@suse.de>, Steve Wise <swise@opengridcomputing.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Kanoj Sarcar <kanojsarcar@yahoo.com>, Roland Dreier <rdreier@cisco.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH 1 of 9] Lock the entire mm to prevent any mmu related
 operation to happen
In-Reply-To: <20080417171443.GM17187@duo.random>
Message-ID: <Pine.LNX.4.64.0804171202420.23938@schroedinger.engr.sgi.com>
References: <patchbomb.1207669443@duo.random> <ec6d8f91b299cf26cce5.1207669444@duo.random>
 <20080416163337.GJ22493@sgi.com> <Pine.LNX.4.64.0804161134360.12296@schroedinger.engr.sgi.com>
 <20080417155157.GC17187@duo.random> <20080417163642.GE11364@sgi.com>
 <20080417171443.GM17187@duo.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2008, Andrea Arcangeli wrote:

> Also note, EMM isn't using the clean hlist_del, it's implementing list
> by hand (with zero runtime gain) so all the debugging may not be
> existent in EMM, so if it's really a mm_lock race, and it only
> triggers with mmu notifiers and not with EMM, it doesn't necessarily
> mean EMM is bug free. If you've a full stack trace it would greatly
> help to verify what is mangling over the list when the oops triggers.

EMM was/is using a single linked list which allows atomic updates. Looked 
cleaner to me since doubly linked list must update two pointers.

I have not seen docs on the locking so not sure why you use rcu 
operations here? Isnt the requirement to have either rmap locks or 
mmap_sem held enough to guarantee the consistency of the doubly linked list?


