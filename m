Return-Path: <linux-kernel-owner+w=401wt.eu-S1757333AbYDWNge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333AbYDWNge (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 09:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756991AbYDWNgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 09:36:23 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:55929
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756943AbYDWNgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 09:36:22 -0400
Date: Wed, 23 Apr 2008 15:36:19 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Robin Holt <holt@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>, Nick Piggin <npiggin@suse.de>,
       Jack Steiner <steiner@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>,
       akpm@linux-foundation.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 01 of 12] Core of mmu notifiers
Message-ID: <20080423133619.GV24536@duo.random>
References: <ea87c15371b1bd49380c.1208872277@duo.random> <Pine.LNX.4.64.0804221315160.3640@schroedinger.engr.sgi.com> <20080422223545.GP24536@duo.random> <20080422230727.GR30298@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080422230727.GR30298@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 06:07:27PM -0500, Robin Holt wrote:
> > The only other change I did has been to move mmu_notifier_unregister
> > at the end of the patchset after getting more questions about its
> > reliability and I documented a bit the rmmod requirements for
> > ->release. we'll think later if it makes sense to add it, nobody's
> > using it anyway.
> 
> XPMEM is using it.  GRU will be as well (probably already does).

XPMEM requires more patches anyway. Note that in previous email you
told me you weren't using it. I think GRU can work fine on 2.6.26
without mmu_notifier_unregister, like KVM too. You've simply to unpin
the module count in ->release. The most important bit is that you've
to do that anyway in case mmu_notifier_unregister fails (and it can
fail because of vmalloc space shortage because somebody loaded some
framebuffer driver or whatever).
