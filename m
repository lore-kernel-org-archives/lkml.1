Return-Path: <linux-kernel-owner+w=401wt.eu-S1754717AbYAWT6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbYAWT6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 14:58:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbYAWT6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 14:58:41 -0500
Received: from relay2.sgi.com ([192.48.171.30]:55360 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751786AbYAWT6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 14:58:40 -0500
Date: Wed, 23 Jan 2008 13:58:39 -0600
From: Robin Holt <holt@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrea Arcangeli <andrea@qumranet.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       Andrew Morton <akpm@osdl.org>, Nick Piggin <npiggin@suse.de>,
       kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [kvm-devel] [PATCH] export notifier #1
Message-ID: <20080123195839.GK26420@sgi.com>
References: <4795F9D2.1050503@qumranet.com> <20080122144332.GE7331@v2.random> <20080122200858.GB15848@v2.random> <Pine.LNX.4.64.0801221232040.28197@schroedinger.engr.sgi.com> <20080122223139.GD15848@v2.random> <Pine.LNX.4.64.0801221433080.2271@schroedinger.engr.sgi.com> <479716AD.5070708@qumranet.com> <20080123105246.GG26420@sgi.com> <20080123120446.GF15848@v2.random> <Pine.LNX.4.64.0801231147370.13547@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801231147370.13547@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2008 at 11:48:43AM -0800, Christoph Lameter wrote:
> On Wed, 23 Jan 2008, Andrea Arcangeli wrote:
> 
> > On Wed, Jan 23, 2008 at 04:52:47AM -0600, Robin Holt wrote:
> > > But 100 callouts holding spinlocks will not work for our implementation
> > > and even if the callouts are made with spinlocks released, we would very
> > > strongly prefer a single callout which messages the range to the other
> > > side.
> > 
> > But you take the physical address and turn into mm+va with your rmap...
> 
> The remote mm+va or a local mm+va?

To be more complete, the phys is pointing to a xpmem_segment+va and the
xpmem_segment points to the mm.  The seg describes a window into the
source processes virtual address space.  Seems somewhat analogous to the
Xen grant, but I do not know.

Thanks,
Robin
