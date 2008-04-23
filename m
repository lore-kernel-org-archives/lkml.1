Return-Path: <linux-kernel-owner+w=401wt.eu-S1757174AbYDWNoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174AbYDWNoj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 09:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbYDWNo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 09:44:29 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:35646
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbYDWNo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 09:44:29 -0400
Date: Wed, 23 Apr 2008 15:44:27 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <npiggin@suse.de>, Jack Steiner <steiner@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       Robin Holt <holt@sgi.com>, general@lists.openfabrics.org,
       Hugh Dickins <hugh@veritas.com>, akpm@linux-foundation.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 04 of 12] Moves all mmu notifier methods outside the PT
	lock (first and not last
Message-ID: <20080423134427.GW24536@duo.random>
References: <ac9bb1fb3de2aa5d2721.1208872280@duo.random> <Pine.LNX.4.64.0804221323510.3640@schroedinger.engr.sgi.com> <20080422224048.GR24536@duo.random> <Pine.LNX.4.64.0804221613570.4868@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804221613570.4868@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 04:14:26PM -0700, Christoph Lameter wrote:
> We want a full solution and this kind of patching makes the patches 
> difficuilt to review because later patches revert earlier ones.

I know you rather want to see KVM development stalled for more months
than to get a partial solution now that already covers KVM and GRU
with the same API that XPMEM will also use later. It's very unfair on
your side to pretend to stall other people development if what you
need has stronger requirements and can't be merged immediately. This
is especially true given it was publically stated that XPMEM never
passed all regression tests anyway, so you can't possibly be in such
an hurry like we are, we can't progress without this. Infact we can
but it would be an huge effort and it would run _slower_ and it would
all need to be deleted once mmu notifiers are in.

Note that the only patch that you can avoid with your approach is
mm_lock-rwsem, given that's software developed and not human developed
I don't see a big deal of wasted effort. The main difference is the
ordering. Most of the code is orthogonal so there's not much to
revert.
