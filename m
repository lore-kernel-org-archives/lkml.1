Return-Path: <linux-kernel-owner+w=401wt.eu-S1756123AbYDWS1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbYDWS1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 14:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbYDWS1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 14:27:23 -0400
Received: from relay2.sgi.com ([192.48.171.30]:38083 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753207AbYDWS1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 14:27:22 -0400
Date: Wed, 23 Apr 2008 11:27:21 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Robin Holt <holt@sgi.com>, Nick Piggin <npiggin@suse.de>,
       Jack Steiner <steiner@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>,
       akpm@linux-foundation.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 01 of 12] Core of mmu notifiers
In-Reply-To: <20080423181928.GI24536@duo.random>
Message-ID: <Pine.LNX.4.64.0804231122410.12373@schroedinger.engr.sgi.com>
References: <ea87c15371b1bd49380c.1208872277@duo.random>
 <Pine.LNX.4.64.0804221315160.3640@schroedinger.engr.sgi.com>
 <20080422223545.GP24536@duo.random> <20080422230727.GR30298@sgi.com>
 <20080423133619.GV24536@duo.random> <20080423144747.GU30298@sgi.com>
 <20080423155940.GY24536@duo.random> <Pine.LNX.4.64.0804231105090.12373@schroedinger.engr.sgi.com>
 <20080423181928.GI24536@duo.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2008, Andrea Arcangeli wrote:

> On Wed, Apr 23, 2008 at 11:09:35AM -0700, Christoph Lameter wrote:
> > Why is there still the hlist stuff being used for the mmu notifier list? 
> > And why is this still unsafe?
> 
> What's the problem with hlist, it saves 8 bytes for each mm_struct,
> you should be using it too instead of list.

list heads in mm_struct and in the mmu_notifier struct seemed to 
be more consistent. We have no hash list after all.

> 
> > There are cases in which you do not take the reverse map locks or mmap_sem
> > while traversing the notifier list?
> 
> There aren't.

There is a potential issue in move_ptes where you call 
invalidate_range_end after dropping i_mmap_sem whereas my patches did the 
opposite. Mmap_sem saves you there?
