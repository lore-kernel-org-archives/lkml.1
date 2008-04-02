Return-Path: <linux-kernel-owner+w=401wt.eu-S1761746AbYDBVtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761746AbYDBVtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763286AbYDBVpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:45:24 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:33581
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763278AbYDBVpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:45:21 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 0 of 8] mmu notifiers #v10
Message-Id: <patchbomb.1207171801@duo.random>
Date: Wed, 02 Apr 2008 23:30:01 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: akpm@linux-foundation.org
Cc: Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Nick Piggin <npiggin@suse.de>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

this is the mmu notifier #v10. Patches 1 and 2 are the only difference between
this and EMM V2. The rest is the same as with Christoph's patches.

I think maximum priority should be given in merging patch 1 and 2 into -mm and
ASAP in mainline.

Patches from 3 to 8 can go in -mm for testing but I'm not sure if we should
support sleep capable notifiers in mainline unless we make the VM locking
conditional to avoid overscheduling for extremely small critical sections in
the common case. I only rediffed Christoph's patches on top of the mmu
notifier patches.

KVM current plans are to heavily depend on mmu notifiers for swapping, to
optimize the spte faults, and we need it for smp guest ballooning with
madvise(DONT_NEED) and other optimizations and features.

Patches from 3 to 8 are Christoph's work ported on top of #v10 to make the
#v10 mmu notifiers sleep capable (at least supposedly). I didn't test the
scheduling, but I assume you'll quickly test XPMEM on top of this.
