Return-Path: <linux-kernel-owner+w=401wt.eu-S1755344AbYDBLRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbYDBLRG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 07:17:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbYDBLQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 07:16:54 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:54721
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbYDBLQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 07:16:53 -0400
Date: Wed, 2 Apr 2008 13:16:51 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Robin Holt <holt@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>, Hugh Dickins <hugh@veritas.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Nick Piggin <npiggin@suse.de>
Subject: Re: [patch 1/9] EMM Notifier: The notifier calls
Message-ID: <20080402111651.GN19189@duo.random>
References: <20080401205531.986291575@sgi.com> <20080401205635.793766935@sgi.com> <20080402064952.GF19189@duo.random> <20080402105925.GC22493@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080402105925.GC22493@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 05:59:25AM -0500, Robin Holt wrote:
> On Wed, Apr 02, 2008 at 08:49:52AM +0200, Andrea Arcangeli wrote:
> > Most other patches will apply cleanly on top of my coming mmu
> > notifiers #v10 that I hope will go in -mm.
> > 
> > For #v10 the only two left open issues to discuss are:
> 
> Does your v10 allow sleeping inside the callbacks?

Yes if you apply all the patches. But not if you apply the first patch
only, most patches in EMM serie will apply cleanly or with minor
rejects to #v10 too, Christoph's further work to make EEM sleep
capable looks very good and it's going to be 100% shared, it's also
going to be a lot more controversial for merging than the two #v10 or
EMM first patch. EMM also doesn't allow sleeping inside the callbacks
if you only apply the first patch in the serie.

My priority is to get #v9 or the coming #v10 merged in -mm (only
difference will be the replacement of rcu_read_lock with the seqlock
to avoid breaking the synchronize_rcu in GRU code). I will mix seqlock
with rcu ordered writes. EMM indeed breaks GRU by making
synchronize_rcu a noop and by not providing any alternative (I will
obsolete synchronize_rcu making it a noop instead). This assumes Jack
used synchronize_rcu for whatever good reason. But this isn't the real
strong point against EMM, adding seqlock to EMM is as easy as adding
it to #v10 (admittedly with #v10 is a bit easier because I didn't
expand the hlist operations for zero gain like in EMM).
