Return-Path: <linux-kernel-owner+w=401wt.eu-S1758715AbYDVNVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715AbYDVNVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 09:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754365AbYDVNVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 09:21:46 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:44738
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbYDVNVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 09:21:45 -0400
Date: Tue, 22 Apr 2008 15:21:43 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Robin Holt <holt@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
       Nick Piggin <npiggin@suse.de>, Steve Wise <swise@opengridcomputing.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Kanoj Sarcar <kanojsarcar@yahoo.com>, Roland Dreier <rdreier@cisco.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH 0 of 9] mmu notifier #v12
Message-ID: <20080422132143.GS12709@duo.random>
References: <patchbomb.1207669443@duo.random> <20080409131709.GR11364@sgi.com> <20080409144401.GT10133@duo.random> <20080409185500.GT11364@sgi.com> <20080422072026.GM12709@duo.random> <20080422120056.GR12709@duo.random> <20080422130120.GR22493@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080422130120.GR22493@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 08:01:20AM -0500, Robin Holt wrote:
> On Tue, Apr 22, 2008 at 02:00:56PM +0200, Andrea Arcangeli wrote:
> > On Tue, Apr 22, 2008 at 09:20:26AM +0200, Andrea Arcangeli wrote:
> > >     invalidate_range_start {
> > > 	spin_lock(&kvm->mmu_lock);
> > > 
> > > 	kvm->invalidate_range_count++;
> > > 	rmap-invalidate of sptes in range
> > > 
> > 
> > 	write_seqlock; write_sequnlock;
> 
> I don't think you need it here since invalidate_range_count is already
> elevated which will accomplish the same effect.

Agreed, seqlock only in range_end should be enough. BTW, the fact
seqlock is needed regardless of invalidate_page existing or not,
really makes invalidate_page a no brainer not just from the core VM
point of view, but from the driver point of view too. The
kvm_page_fault logic would be the same even if I remove
invalidate_page from the mmu notifier patch but it'd run slower both
when armed and disarmed.
