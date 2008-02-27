Return-Path: <linux-kernel-owner+w=401wt.eu-S1760225AbYB0WXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760225AbYB0WXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 17:23:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753020AbYB0WXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 17:23:31 -0500
Received: from relay2.sgi.com ([192.48.171.30]:46980 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752628AbYB0WXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:23:30 -0500
Date: Wed, 27 Feb 2008 14:23:29 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, akpm@linux-foundation.org,
       Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 2/6] mmu_notifier: Callbacks to invalidate address ranges
In-Reply-To: <20080219133405.GH7128@v2.random>
Message-ID: <Pine.LNX.4.64.0802271421480.13186@schroedinger.engr.sgi.com>
References: <20080215064859.384203497@sgi.com> <20080215064932.620773824@sgi.com>
 <200802191954.14874.nickpiggin@yahoo.com.au> <20080219133405.GH7128@v2.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008, Andrea Arcangeli wrote:

> Yes, that's why I kept maintaining my patch and I posted the last
> revision to Andrew. I use pte/tlb locking of the core VM, it's
> unintrusive and obviously safe. Furthermore it can be extended with
> Christoph's stuff in a 100% backwards compatible fashion later if needed.

How would that work? You rely on the pte locking. Thus calls are all in an 
atomic context. I think we need a general scheme that allows sleeping when 
references are invalidates. Even the GRU has performance issues when using 
the KVM patch.


 
