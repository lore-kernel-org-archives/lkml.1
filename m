Return-Path: <linux-kernel-owner+w=401wt.eu-S935490AbYBCCYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935490AbYBCCYM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 21:24:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751745AbYBCCYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 21:24:00 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:36398
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbYBCCX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 21:23:59 -0500
Date: Sun, 3 Feb 2008 03:23:56 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Robin Holt <holt@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 2/4] mmu_notifier: Callbacks to invalidate address
	ranges
Message-ID: <20080203022356.GD7185@v2.random>
References: <20080201050439.009441434@sgi.com> <20080201050623.344041545@sgi.com> <20080201220952.GA3875@sgi.com> <Pine.LNX.4.64.0802011517430.20608@schroedinger.engr.sgi.com> <20080201233528.GE12099@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080201233528.GE12099@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 05:35:28PM -0600, Robin Holt wrote:
> No, we need a callout when we are becoming more restrictive, but not
> when becoming more permissive.  I would have to guess that is the case
> for any of these callouts.  It is for both GRU and XPMEM.  I would
> expect the same is true for KVM, but would like a ruling from Andrea on
> that.

I still hope I don't need to take any lock in _range_start and that
losing coherency (w/o risking global memory corruption but only
risking temporary userland data corruption thanks to the page pin) is
ok for KVM.

If I would have to take a lock in _range_start like XPMEM is forced to
do (GRU is by far not forced to it, if it would switch to my #v5) then
it would be a problem.
