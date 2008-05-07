Return-Path: <linux-kernel-owner+w=401wt.eu-S1758721AbYEGQUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721AbYEGQUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 12:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbYEGQUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 12:20:12 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:50210
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbYEGQUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 12:20:09 -0400
Date: Wed, 7 May 2008 18:20:07 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Robin Holt <holt@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>, Chris Wright <chrisw@redhat.com>,
       Marcelo Tosatti <marcelo@kvack.org>, Eric Dumazet <dada1@cosmosbay.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH 02 of 11] get_task_mm
Message-ID: <20080507162006.GB18260@duo.random>
References: <patchbomb.1210170950@duo.random> <c5badbefeee07518d9d1.1210170952@duo.random> <20080507155948.GO18857@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080507155948.GO18857@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 10:59:48AM -0500, Robin Holt wrote:
> You can drop this patch.
> 
> This turned out to be a race in xpmem.  It "appeared" as if it were a
> race in get_task_mm, but it really is not.  The current->mm field is
> cleared under the task_lock and the task_lock is grabbed by get_task_mm.

100% agreed, I'll nuke it as it seems really a noop.

> I have been testing you v15 version without this patch and not
> encountere the problem again (now that I fixed my xpmem race).

Great. About your other deadlock I'm curious if my deadlock fix for
the i_mmap_sem patch helped. That was crashing kvm with a VM 2G in the
swap + a swaphog allocating and freeing another 2G of swap in a
loop. I couldn't reproduce any other problem with KVM since I fixed
that bit regardless if I apply only mmu-notifier-core (2.6.26 version)
or the full patchset (post 2.6.26).
