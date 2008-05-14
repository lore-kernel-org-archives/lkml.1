Return-Path: <linux-kernel-owner+w=401wt.eu-S1757672AbYENQ6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757672AbYENQ6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 12:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbYENQ6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 12:58:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54202 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752086AbYENQ6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 12:58:16 -0400
Date: Wed, 14 May 2008 09:56:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Robin Holt <holt@sgi.com>
cc: Nick Piggin <npiggin@suse.de>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrea Arcangeli <andrea@qumranet.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
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
In-Reply-To: <20080514162223.GZ9878@sgi.com>
Message-ID: <alpine.LFD.1.10.0805140954280.3019@woody.linux-foundation.org>
References: <6b384bb988786aa78ef0.1210170958@duo.random> <alpine.LFD.1.10.0805071429170.3024@woody.linux-foundation.org> <20080508003838.GA9878@sgi.com> <200805132206.47655.nickpiggin@yahoo.com.au> <20080513153238.GL19717@sgi.com> <20080514041122.GE24516@wotan.suse.de>
 <20080514112625.GY9878@sgi.com> <alpine.LFD.1.10.0805140807400.3019@woody.linux-foundation.org> <20080514162223.GZ9878@sgi.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 May 2008, Robin Holt wrote:
> 
> Would it be acceptable to always put a sleepable stall in even if the 
> code path did not require the pages be unwritable prior to continuing?  
> If we did that, I would be freed from having a pool of invalidate 
> threads ready for XPMEM to use for that work. Maybe there is a better 
> way, but the sleeping requirement we would have on the threads make most 
> options seem unworkable.

I'm not understanding the question. If you can do you management outside 
of the spinlocks, then you can obviously do whatever you want, including 
sleping. It's changing the existing spinlocks to be sleepable that is not 
acceptable, because it's such a performance problem.

		Linus
