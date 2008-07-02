Return-Path: <linux-kernel-owner+w=401wt.eu-S1762273AbYGBEqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762273AbYGBEqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 00:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbYGBEqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 00:46:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34549 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751507AbYGBEqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 00:46:30 -0400
Date: Tue, 1 Jul 2008 21:44:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Robin Holt <holt@sgi.com>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, kvm@vger.kernel.org,
       Kanoj Sarcar <kanojsarcar@yahoo.com>, Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>, Chris Wright <chrisw@redhat.com>,
       Marcelo Tosatti <marcelo@kvack.org>, Eric Dumazet <dada1@cosmosbay.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Izik Eidus <izike@qumranet.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 0 of 3] mmu notifier v18 for -mm
Message-Id: <20080701214415.b3f93706.akpm@linux-foundation.org>
In-Reply-To: <patchbomb.1214440016@duo.random>
References: <patchbomb.1214440016@duo.random>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008 02:26:56 +0200 Andrea Arcangeli <andrea@qumranet.com> wrote:

> Hello,
> 
> Christoph suggested me to repost v18 for merging in -mm, to give it more
> exposure before the .27 merge window opens. There's no code change compared to
> the previous v18 submission (the only change is the correction in the comment
> in the mm_take_all_locks patch rightfully pointed out by Linus).
> 
> Full patchset including other XPMEM support patches can be found here:
> 
> 	http://www.kernel.org/pub/linux/kernel/people/andrea/patches/v2.6/2.6.26-rc7/mmu-notifier-v18
> 
> Only the three patches of the patchset I'm submitting here by email are ready
> for merging, the rest you can find in the website is not ready for merging yet
> for various performance degradations, lots of the XPMEM patches needs to be
> elaborated to avoid any slowdown for the non-XPMEM case, but I keep
> maintaining them to make life easier to XPMEM current development and later we
> can keep work on them to make them suitable for inclusion to avoid any
> performance degradation risk.

I'm a bit concerned about merging the first three patches when there
are eleven more patches of which some, afacit, are required to make
these three actually useful.  Committing these three would be signing a
blank cheque.

Because if we hit strong objections with the later patches we end up in a
cant-go-forward, cant-go-backward situation.

So it would be sensible for us all to get down and at least review the
whole patch series to satisfy ourselves that this is the direction in
which we wish to go.



Also, could I ask that you choose better titles for your patches? 
You'll notice that we never commit patches with titles such as
"mm_take_all_locks".

Someone (ie: me) will need to chage your patch title to "mmu-notifiers:
add mm_take_all_locks() operation" or such.  And, sensibly, the patch's
filename will be changed to reflect its title -
mmu-notifiers-add-mm_take_all_locks-operation.patch

And that's OK, that's what they pay me for.  But it means that for a
period of time, your name for the patch differs from everyone else's
name.  This gets confusing and can lead to mistakes.  Use of consistent
naming from end-to-end is better.

> (the fourth patch in the series of the above url, is not strictly relealted to
> mmu notifiers but it's good at least for me to keep it in the same tree to
> test pci-passthrough capable guest running on reserved-ram at the same time of
> two regular guests swapping heavily with mmu notifiers which tends to
> exercises both spte models at the same time, if you find this confusing I'll
> remove it from any later upload, but xpmem users can totally ignore it, it
> only touches x86-64 code)

