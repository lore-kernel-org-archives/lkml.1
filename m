Return-Path: <linux-kernel-owner+w=401wt.eu-S1762915AbYEGU6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762915AbYEGU6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 16:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbYEGU6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 16:58:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53298 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750833AbYEGU6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 16:58:19 -0400
Date: Wed, 7 May 2008 13:56:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Robin Holt <holt@sgi.com>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>, Chris Wright <chrisw@redhat.com>,
       Marcelo Tosatti <marcelo@kvack.org>, Eric Dumazet <dada1@cosmosbay.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH 08 of 11] anon-vma-rwsem
In-Reply-To: <6b384bb988786aa78ef0.1210170958@duo.random>
Message-ID: <alpine.LFD.1.10.0805071349200.3024@woody.linux-foundation.org>
References: <6b384bb988786aa78ef0.1210170958@duo.random>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 May 2008, Andrea Arcangeli wrote:
> 
> Convert the anon_vma spinlock to a rw semaphore. This allows concurrent
> traversal of reverse maps for try_to_unmap() and page_mkclean(). It also
> allows the calling of sleeping functions from reverse map traversal as
> needed for the notifier callbacks. It includes possible concurrency.

This also looks very debatable indeed. The only performance numbers quoted 
are:

>   This results in f.e. the Aim9 brk performance test to got down by 10-15%.

which just seems like a total disaster.

The whole series looks bad, in fact. Lack of authorship, bad single-line 
description, and the code itself sucks so badly that it's not even funny.

NAK NAK NAK. All of it. It stinks.

		Linus
