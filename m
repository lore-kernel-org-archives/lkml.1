Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbYEGUcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbYEGUcB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 16:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbYEGUbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 16:31:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56973 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751316AbYEGUbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 16:31:46 -0400
Date: Wed, 7 May 2008 13:30:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andrea Arcangeli <andrea@qumranet.com>, clameter@sgi.com, steiner@sgi.com,
       holt@sgi.com, npiggin@suse.de, a.p.zijlstra@chello.nl,
       kvm-devel@lists.sourceforge.net, kanojsarcar@yahoo.com,
       rdreier@cisco.com, swise@opengridcomputing.com,
       linux-kernel@vger.kernel.org, avi@qumranet.com, linux-mm@kvack.org,
       general@lists.openfabrics.org, hugh@veritas.com, rusty@rustcorp.com.au,
       aliguori@us.ibm.com, chrisw@redhat.com, marcelo@kvack.org,
       dada1@cosmosbay.com, paulmck@us.ibm.com
Subject: Re: [PATCH 01 of 11] mmu-notifier-core
In-Reply-To: <20080507130528.adfd154c.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0805071324570.3024@woody.linux-foundation.org>
References: <patchbomb.1210170950@duo.random> <e20917dcc8284b6a07cf.1210170951@duo.random> <20080507130528.adfd154c.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 May 2008, Andrew Morton wrote:
> 
> The patch looks OK to me.

As far as I can tell, authorship has been destroyed by at least two of the 
patches (ie Christoph seems to be the author, but Andrea seems to have 
dropped that fact).

> The proposal is that we sneak this into 2.6.26.  Are there any
> sufficiently-serious objections to this?

Yeah, too late and no upside.

That "locking" code is also too ugly to live, at least without some 
serious arguments for why it has to be done that way. Sorting the locks? 
In a vmalloc'ed area?  And calling this something innocuous like 
"mm_lock()"? Hell no. 

That code needs some serious re-thinking.

		Linus
