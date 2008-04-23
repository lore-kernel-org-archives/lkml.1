Return-Path: <linux-kernel-owner+w=401wt.eu-S933860AbYDWA3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933860AbYDWA3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 20:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756739AbYDWA3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 20:29:03 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48834 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756790AbYDWA3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 20:29:01 -0400
Date: Tue, 22 Apr 2008 19:28:49 -0500
From: Jack Steiner <steiner@sgi.com>
To: Robin Holt <holt@sgi.com>
Cc: Andrea Arcangeli <andrea@qumranet.com>,
       Christoph Lameter <clameter@sgi.com>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>,
       akpm@linux-foundation.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 01 of 12] Core of mmu notifiers
Message-ID: <20080423002848.GA32618@sgi.com>
References: <ea87c15371b1bd49380c.1208872277@duo.random> <Pine.LNX.4.64.0804221315160.3640@schroedinger.engr.sgi.com> <20080422223545.GP24536@duo.random> <20080422230727.GR30298@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080422230727.GR30298@sgi.com>
User-Agent: Mutt/1.4.2.2i
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

Yeppp.

The GRU driver unregisters the notifier when all GRU mappings
are unmapped. I could make it work either way - either with or without
an unregister function. However, unregister is the most logical
action to take when all mappings have been destroyed.


--- jack
