Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbYFUXzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbYFUXzq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 19:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbYFUXze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 19:55:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59302 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751754AbYFUXz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 19:55:27 -0400
Date: Sat, 21 Jun 2008 16:54:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
cc: Mel Gorman <mel@csn.ul.ie>, Alexander Beregalov <a.beregalov@gmail.com>,
       kernel-testers@vger.kernel.org,
       kernel list <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Hugh Dickins <hugh@veritas.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, bfields@fieldses.org,
       neilb@suse.de, linux-nfs@vger.kernel.org
Subject: Re: 2.6.26-rc: nfsd hangs for a few sec
In-Reply-To: <Pine.LNX.4.64.0806211636090.18642@schroedinger.engr.sgi.com>
Message-ID: <alpine.LFD.1.10.0806211651210.2926@woody.linux-foundation.org>
References: <a4423d670806210557k1e8fcee1le3526f62962799e@mail.gmail.com> <20080621224135.GD4692@csn.ul.ie> <Pine.LNX.4.64.0806211636090.18642@schroedinger.engr.sgi.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 21 Jun 2008, Christoph Lameter wrote:
>
>   Not a direct explanation for the problem but the memory wastage could 
> certainly can heretofore undiscovered locking dependencies to be 
> exposed.

Well, not for these traces, no. The trace contains __slab_alloc() in the 
call chain, which definitely fingers SLUB, not slab, despite the name 
(slab calls its allocation routines "cache_alloc", while slub calls them 
"slab_alloc" ;)

So the patch looks fine, and I applied it, but as Mel already mentioned, 
it looks like it won't be making any difference for Alexander.

		Linus
