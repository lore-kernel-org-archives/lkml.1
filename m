Return-Path: <linux-kernel-owner+w=401wt.eu-S1761437AbYB0X5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761437AbYB0X5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 18:57:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759008AbYB0X5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 18:57:31 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:51055
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758650AbYB0X5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 18:57:30 -0500
Date: Thu, 28 Feb 2008 00:57:24 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, akpm@linux-foundation.org,
       Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 2/6] mmu_notifier: Callbacks to invalidate address
	ranges
Message-ID: <20080227235724.GA8091@v2.random>
References: <20080215064859.384203497@sgi.com> <20080215064932.620773824@sgi.com> <200802191954.14874.nickpiggin@yahoo.com.au> <20080219133405.GH7128@v2.random> <Pine.LNX.4.64.0802271421480.13186@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802271421480.13186@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 02:23:29PM -0800, Christoph Lameter wrote:
> How would that work? You rely on the pte locking. Thus calls are all in an 

I don't rely on the pte locking in #v7, exactly to satisfy GRU
(so far purely theoretical) performance complains.

> atomic context. I think we need a general scheme that allows sleeping when 

Calls are still in atomic context until we change the i_mmap_lock to a
mutex under a CONFIG_XPMEM, or unless we boost mm_users, drop the lock
and restart the loop at every different mm. In any case those changes
should be under CONFIG_XPMEM IMHO given desktop users definitely don't
need this (regular non-blocking mmu notifiers in my patch are all what
a desktop user need as far as I can tell).

> references are invalidates. Even the GRU has performance issues when using 
> the KVM patch.

GRU will perform the same with #v7 or V8.
