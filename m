Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbYDQWRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbYDQWRO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 18:17:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754212AbYDQWQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 18:16:58 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:60296
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171AbYDQWQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 18:16:57 -0400
Date: Fri, 18 Apr 2008 00:16:55 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Robin Holt <holt@sgi.com>, akpm@linux-foundation.org,
       Nick Piggin <npiggin@suse.de>, Steve Wise <swise@opengridcomputing.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Kanoj Sarcar <kanojsarcar@yahoo.com>, Roland Dreier <rdreier@cisco.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH 1 of 9] Lock the entire mm to prevent any mmu related
	operation to happen
Message-ID: <20080417221655.GA9287@duo.random>
References: <patchbomb.1207669443@duo.random> <ec6d8f91b299cf26cce5.1207669444@duo.random> <20080416163337.GJ22493@sgi.com> <Pine.LNX.4.64.0804161134360.12296@schroedinger.engr.sgi.com> <20080417155157.GC17187@duo.random> <20080417163642.GE11364@sgi.com> <20080417171443.GM17187@duo.random> <Pine.LNX.4.64.0804171202420.23938@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804171202420.23938@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 12:10:52PM -0700, Christoph Lameter wrote:
> EMM was/is using a single linked list which allows atomic updates. Looked 
> cleaner to me since doubly linked list must update two pointers.

Cleaner would be if it would provide an abstraction in list.h. The
important is the memory taken by the head for this usage.

> I have not seen docs on the locking so not sure why you use rcu 
> operations here? Isnt the requirement to have either rmap locks or 
> mmap_sem held enough to guarantee the consistency of the doubly linked list?

Yes, exactly, I'm not using rcu anymore.
