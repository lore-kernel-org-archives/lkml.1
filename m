Return-Path: <linux-kernel-owner+w=401wt.eu-S1759483AbYBIAWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759483AbYBIAWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 19:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305AbYBIAWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 19:22:46 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:21732 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519AbYBIAWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 19:22:45 -0500
To: Christoph Lameter <clameter@sgi.com>
Cc: andrea@qumranet.com, a.p.zijlstra@chello.nl, izike@qumranet.com,
       steiner@sgi.com, linux-kernel@vger.kernel.org, avi@qumranet.com,
       linux-mm@kvack.org, daniel.blueman@quadrics.com,
       Robin Holt <holt@sgi.com>, general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net
Subject: Re: [ofa-general] Re: [patch 0/6] MMU Notifiers V6
X-Message-Flag: Warning: May contain useful information
References: <20080208220616.089936205@sgi.com>
	<20080208142315.7fe4b95e.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0802081528070.4036@schroedinger.engr.sgi.com>
	<20080208233636.GG26564@sgi.com>
	<Pine.LNX.4.64.0802081540180.4291@schroedinger.engr.sgi.com>
	<20080208234302.GH26564@sgi.com>
	<20080208155641.2258ad2c.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0802081603430.4543@schroedinger.engr.sgi.com>
	<adaprv70yyt.fsf@cisco.com>
	<Pine.LNX.4.64.0802081614030.5115@schroedinger.engr.sgi.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 08 Feb 2008 16:22:41 -0800
In-Reply-To: <Pine.LNX.4.64.0802081614030.5115@schroedinger.engr.sgi.com> (Christoph Lameter's message of "Fri, 8 Feb 2008 16:16:34 -0800 (PST)")
Message-ID: <adalk5v0yi6.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Feb 2008 00:22:42.0004 (UTC) FILETIME=[E2645140:01C86AB1]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > I thought the adaptor can always remove the mapping by renegotiating 
 > with the remote side? Even if its dumb then a callback could notify the 
 > driver that it may be required to tear down the mapping. We then hold the 
 > pages until we get okay by the driver that the mapping has been removed.

Of course we can always destroy the memory region but that would break
the semantics that applications expect.  Basically an application can
register some chunk of its memory and get a key that it can pass to a
remote peer to let the remote peer operate on its memory via RDMA.
And that memory region/key is expected to stay valid until there is an
application-level operation to destroy it (or until the app crashes or
gets killed, etc).

 > We could also let the unmapping fail if the driver indicates that the 
 > mapping must stay.

That would of course work -- dumb adapters would just always fail,
which might be inefficient.
