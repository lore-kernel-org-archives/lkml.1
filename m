Return-Path: <linux-kernel-owner+w=401wt.eu-S1760679AbYAaCvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760679AbYAaCvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 21:51:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753586AbYAaCv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 21:51:29 -0500
Received: from relay2.sgi.com ([192.48.171.30]:39099 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755101AbYAaCv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 21:51:28 -0500
Date: Wed, 30 Jan 2008 18:51:26 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       steiner@sgi.com, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       daniel.blueman@quadrics.com, Robin Holt <holt@sgi.com>,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [kvm-devel] [patch 2/6] mmu_notifier: Callbacks to invalidate
 address ranges
In-Reply-To: <20080131024252.GF7185@v2.random>
Message-ID: <Pine.LNX.4.64.0801301848550.14263@schroedinger.engr.sgi.com>
References: <20080130000039.GA7233@v2.random> <20080130161123.GS26420@sgi.com>
 <20080130170451.GP7233@v2.random> <20080130173009.GT26420@sgi.com>
 <20080130182506.GQ7233@v2.random> <Pine.LNX.4.64.0801301147330.30568@schroedinger.engr.sgi.com>
 <20080130235214.GC7185@v2.random> <Pine.LNX.4.64.0801301555550.1722@schroedinger.engr.sgi.com>
 <20080131003434.GE7185@v2.random> <Pine.LNX.4.64.0801301805200.14071@schroedinger.engr.sgi.com>
 <20080131024252.GF7185@v2.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008, Andrea Arcangeli wrote:

> On Wed, Jan 30, 2008 at 06:08:14PM -0800, Christoph Lameter wrote:
> >  		hlist_for_each_entry_safe_rcu(mn, n, t,
> 				         ^^^^
> 
> >  					  &mm->mmu_notifier.head, hlist) {
> >  			hlist_del_rcu(&mn->hlist);
> 				 ^^^^
> 
> _rcu can go away from both, if hlist_del_rcu can be called w/o locks.

True. hlist_del_init ok? That would allow to check the driver that the 
mmu_notifier is already linked in using !hlist_unhashed(). Driver then 
needs to properly initialize the mmu_notifier list with INIT_HLIST_NODE().


