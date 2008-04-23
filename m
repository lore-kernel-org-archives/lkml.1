Return-Path: <linux-kernel-owner+w=401wt.eu-S1756400AbYDWSTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbYDWSTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 14:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751875AbYDWST2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 14:19:28 -0400
Received: from relay2.sgi.com ([192.48.171.30]:34829 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751593AbYDWST1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 14:19:27 -0400
Date: Wed, 23 Apr 2008 11:19:26 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Jack Steiner <steiner@sgi.com>, Robin Holt <holt@sgi.com>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>,
       akpm@linux-foundation.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 01 of 12] Core of mmu notifiers
In-Reply-To: <20080423163713.GC24536@duo.random>
Message-ID: <Pine.LNX.4.64.0804231118190.12373@schroedinger.engr.sgi.com>
References: <ea87c15371b1bd49380c.1208872277@duo.random>
 <Pine.LNX.4.64.0804221315160.3640@schroedinger.engr.sgi.com>
 <20080422223545.GP24536@duo.random> <20080422230727.GR30298@sgi.com>
 <20080423002848.GA32618@sgi.com> <20080423163713.GC24536@duo.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2008, Andrea Arcangeli wrote:

> The only way to avoid failing because of vmalloc space shortage or
> oom, would be to provide a O(N*N) fallback. But one that can't be
> interrupted by sigkill! sigkill interruption was ok in #v12 because we
> didn't rely on mmu_notifier_unregister to succeed. So it avoided any
> DoS but it still can't provide any reliable unregister.

If unregister fails then the driver should not detach from the address
space immediately but wait until -->release is called. That may be
a possible solution. It will be rare that the unregister fails.


