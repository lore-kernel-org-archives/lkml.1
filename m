Return-Path: <linux-kernel-owner+w=401wt.eu-S1765486AbYBMA54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765486AbYBMA54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 19:57:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765355AbYBMA5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 19:57:24 -0500
Received: from relay2.sgi.com ([192.48.171.30]:50960 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758706AbYBMA5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 19:57:20 -0500
Date: Tue, 12 Feb 2008 16:57:19 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Felix Marti <felix@chelsio.com>
cc: Roland Dreier <rdreier@cisco.com>, Rik van Riel <riel@redhat.com>,
       steiner@sgi.com, Andrea Arcangeli <andrea@qumranet.com>,
       a.p.zijlstra@chello.nl, izike@qumranet.com,
       linux-kernel@vger.kernel.org, avi@qumranet.com, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Robin Holt <holt@sgi.com>,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net
Subject: RE: [ofa-general] Re: Demand paging for memory regions
In-Reply-To: <8A71B368A89016469F72CD08050AD334026D5C23@maui.asicdesigners.com>
Message-ID: <Pine.LNX.4.64.0802121656550.11628@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0802081540180.4291@schroedinger.engr.sgi.com><20080208234302.GH26564@sgi.com><20080208155641.2258ad2c.akpm@linux-foundation.org><Pine.LNX.4.64.0802081603430.4543@schroedinger.engr.sgi.com><adaprv70yyt.fsf@cisco.com><Pine.LNX.4.64.0802081614030.5115@schroedinger.engr.sgi.com><adalk5v0yi6.fsf@cisco.com><Pine.LNX.4.64.0802081634070.5298@schroedinger.engr.sgi.com><20080209012446.GB7051@v2.random><Pine.LNX.4.64.0802081725200.5445@schroedinger.engr.sgi.com><20080209015659.GC7051@v2.random><Pine.LNX.4.64.0802081813300.5602@schroedinger.engr.sgi.com><20080209075556.63062452@bree.surriel.com><Pine.LNX.4.64.0802091345490.12965@schroedinger.engr.sgi.com><ada3arzxgkz.fsf_-_@cisco.com><47B2174E.5000708@opengridcomputing.com><Pine.LNX.4.64.0802121408150.9591@schroedinger.engr.sgi.com>
 <adazlu5vlub.fsf@cisco.com> <8A71B368A89016469F72CD08050AD334026D5C23@maui.asicdesigners.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008, Felix Marti wrote:

> > I don't know anything about the T3 internals, but it's not clear that
> > you could do this without a new chip design in general.  Lot's of RDMA
> > devices were designed expecting that when a packet arrives, the HW can
> > look up the bus address for a given memory region/offset and place the
> > packet immediately.  It seems like a major change to be able to
> > generate a "page fault" interrupt when a page isn't present, or even
> > just wait to scatter some data until the host finishes updating page
> > tables when the HW needs the translation.
> 
> That is correct, not a change we can make for T3. We could, in theory,
> deal with changing mappings though. The change would need to be
> synchronized though: the VM would need to tell us which mapping were
> about to change and the driver would then need to disable DMA to/from
> it, do the change and resume DMA.

Right. That is the intend of the patchset.
