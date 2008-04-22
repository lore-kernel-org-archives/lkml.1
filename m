Return-Path: <linux-kernel-owner+w=401wt.eu-S1757571AbYDVUTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571AbYDVUTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 16:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbYDVUTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 16:19:32 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39231 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750892AbYDVUTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 16:19:31 -0400
Date: Tue, 22 Apr 2008 13:19:29 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Nick Piggin <npiggin@suse.de>, Jack Steiner <steiner@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       Robin Holt <holt@sgi.com>, general@lists.openfabrics.org,
       Hugh Dickins <hugh@veritas.com>, akpm@linux-foundation.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 01 of 12] Core of mmu notifiers
In-Reply-To: <ea87c15371b1bd49380c.1208872277@duo.random>
Message-ID: <Pine.LNX.4.64.0804221315160.3640@schroedinger.engr.sgi.com>
References: <ea87c15371b1bd49380c.1208872277@duo.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for adding most of my enhancements. But

1. There is no real need for invalidate_page(). Can be done with 
	invalidate_start/end. Needlessly complicates the API. One
	of the objections by Andrew was that there mere multiple
	callbacks that perform similar functions.

2. The locks that are used are later changed to semaphores. This is
   f.e. true for mm_lock / mm_unlock. The diffs will be smaller if the
   lock conversion is done first and then mm_lock is introduced. The
   way the patches are structured means that reviewers cannot review the
   final version of mm_lock etc etc. The lock conversion needs to come 
   first.

3. As noted by Eric and also contained in private post from yesterday by 
   me: The cmp function needs to retrieve the value before
   doing comparisons which is not done for the == of a and b.
