Return-Path: <linux-kernel-owner+w=401wt.eu-S1756240AbYB2BGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbYB2BGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 20:06:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758595AbYB2Azh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 19:55:37 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:37797
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764224AbYB2Azf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 19:55:35 -0500
Date: Fri, 29 Feb 2008 01:55:30 +0100
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
Message-ID: <20080229005530.GO8091@v2.random>
References: <20080215064859.384203497@sgi.com> <20080215064932.620773824@sgi.com> <200802201008.49933.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0802271424390.13186@schroedinger.engr.sgi.com> <20080228001104.GB8091@v2.random> <Pine.LNX.4.64.0802271613080.15791@schroedinger.engr.sgi.com> <20080228005249.GF8091@v2.random> <Pine.LNX.4.64.0802271702490.16510@schroedinger.engr.sgi.com> <20080228011020.GG8091@v2.random> <Pine.LNX.4.64.0802281043430.29191@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802281043430.29191@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 10:43:54AM -0800, Christoph Lameter wrote:
> What about invalidate_page()?

That would just spin waiting an ack (just like the smp-tlb-flushing
invalidates in numa already does).

Thinking more about this, we could also parallelize it with an
invalidate_page_before/end. If it takes 1usec to flush remotely,
scheduling would be overkill, but spending 1usec in a while loop isn't
nice if we can parallelize that 1usec with the ipi-tlb-flush. Not sure
if it makes sense... it certainly would be quick to add it (especially
thanks to _notify ;).
