Return-Path: <linux-kernel-owner+w=401wt.eu-S1765298AbYBMA45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765298AbYBMA45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 19:56:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbYBMA4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 19:56:48 -0500
Received: from relay1.sgi.com ([192.48.171.29]:59888 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753286AbYBMA4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 19:56:47 -0500
Date: Tue, 12 Feb 2008 16:56:45 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Roland Dreier <rdreier@cisco.com>
cc: Steve Wise <swise@opengridcomputing.com>, Rik van Riel <riel@redhat.com>,
       Andrea Arcangeli <andrea@qumranet.com>, a.p.zijlstra@chello.nl,
       izike@qumranet.com, steiner@sgi.com, linux-kernel@vger.kernel.org,
       avi@qumranet.com, linux-mm@kvack.org, daniel.blueman@quadrics.com,
       Robin Holt <holt@sgi.com>, general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net
Subject: Re: [ofa-general] Re: Demand paging for memory regions
In-Reply-To: <adazlu5vlub.fsf@cisco.com>
Message-ID: <Pine.LNX.4.64.0802121653460.11628@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0802081540180.4291@schroedinger.engr.sgi.com>
 <20080208234302.GH26564@sgi.com> <20080208155641.2258ad2c.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0802081603430.4543@schroedinger.engr.sgi.com>
 <adaprv70yyt.fsf@cisco.com> <Pine.LNX.4.64.0802081614030.5115@schroedinger.engr.sgi.com>
 <adalk5v0yi6.fsf@cisco.com> <Pine.LNX.4.64.0802081634070.5298@schroedinger.engr.sgi.com>
 <20080209012446.GB7051@v2.random> <Pine.LNX.4.64.0802081725200.5445@schroedinger.engr.sgi.com>
 <20080209015659.GC7051@v2.random> <Pine.LNX.4.64.0802081813300.5602@schroedinger.engr.sgi.com>
 <20080209075556.63062452@bree.surriel.com> <Pine.LNX.4.64.0802091345490.12965@schroedinger.engr.sgi.com>
 <ada3arzxgkz.fsf_-_@cisco.com> <47B2174E.5000708@opengridcomputing.com>
 <Pine.LNX.4.64.0802121408150.9591@schroedinger.engr.sgi.com>
 <adazlu5vlub.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008, Roland Dreier wrote:

> I don't know anything about the T3 internals, but it's not clear that
> you could do this without a new chip design in general.  Lot's of RDMA
> devices were designed expecting that when a packet arrives, the HW can
> look up the bus address for a given memory region/offset and place the
> packet immediately.  It seems like a major change to be able to
> generate a "page fault" interrupt when a page isn't present, or even
> just wait to scatter some data until the host finishes updating page
> tables when the HW needs the translation.

Well if the VM wants to invalidate a page then the remote end first has to 
remove its mapping. 

If a page has been removed then the remote end would encounter a fault and 
then would have to wait for the local end to reestablish its mapping 
before proceeding.

So the packet would only be generated when both ends are in sync.


