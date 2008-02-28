Return-Path: <linux-kernel-owner+w=401wt.eu-S932537AbYB1BKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537AbYB1BKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 20:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758837AbYB1BK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 20:10:29 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:44901
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757029AbYB1BK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 20:10:28 -0500
Date: Thu, 28 Feb 2008 02:10:20 +0100
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
Message-ID: <20080228011020.GG8091@v2.random>
References: <20080215064859.384203497@sgi.com> <20080215064932.620773824@sgi.com> <200802201008.49933.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0802271424390.13186@schroedinger.engr.sgi.com> <20080228001104.GB8091@v2.random> <Pine.LNX.4.64.0802271613080.15791@schroedinger.engr.sgi.com> <20080228005249.GF8091@v2.random> <Pine.LNX.4.64.0802271702490.16510@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802271702490.16510@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 05:03:21PM -0800, Christoph Lameter wrote:
> RDMA works across a network and I would assume that it needs confirmation 
> that a connection has been torn down before pages can be unmapped.

Depends on the latency of the network, for example with page pinning
it can even try to reduce the wait time, by tearing down the mapping
in range_begin and spin waiting the ack only later in range_end.
