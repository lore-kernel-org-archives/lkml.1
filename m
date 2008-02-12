Return-Path: <linux-kernel-owner+w=401wt.eu-S1758859AbYBLWmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758859AbYBLWmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 17:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758251AbYBLWl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 17:41:59 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:62473 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758170AbYBLWl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 17:41:56 -0500
To: Christoph Lameter <clameter@sgi.com>
Cc: Steve Wise <swise@opengridcomputing.com>, Rik van Riel <riel@redhat.com>,
       Andrea Arcangeli <andrea@qumranet.com>, a.p.zijlstra@chello.nl,
       izike@qumranet.com, steiner@sgi.com, linux-kernel@vger.kernel.org,
       avi@qumranet.com, linux-mm@kvack.org, daniel.blueman@quadrics.com,
       Robin Holt <holt@sgi.com>, general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net
Subject: Re: [ofa-general] Re: Demand paging for memory regions
X-Message-Flag: Warning: May contain useful information
References: <Pine.LNX.4.64.0802081540180.4291@schroedinger.engr.sgi.com>
	<20080208234302.GH26564@sgi.com>
	<20080208155641.2258ad2c.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0802081603430.4543@schroedinger.engr.sgi.com>
	<adaprv70yyt.fsf@cisco.com>
	<Pine.LNX.4.64.0802081614030.5115@schroedinger.engr.sgi.com>
	<adalk5v0yi6.fsf@cisco.com>
	<Pine.LNX.4.64.0802081634070.5298@schroedinger.engr.sgi.com>
	<20080209012446.GB7051@v2.random>
	<Pine.LNX.4.64.0802081725200.5445@schroedinger.engr.sgi.com>
	<20080209015659.GC7051@v2.random>
	<Pine.LNX.4.64.0802081813300.5602@schroedinger.engr.sgi.com>
	<20080209075556.63062452@bree.surriel.com>
	<Pine.LNX.4.64.0802091345490.12965@schroedinger.engr.sgi.com>
	<ada3arzxgkz.fsf_-_@cisco.com>
	<47B2174E.5000708@opengridcomputing.com>
	<Pine.LNX.4.64.0802121408150.9591@schroedinger.engr.sgi.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 12 Feb 2008 14:41:48 -0800
In-Reply-To: <Pine.LNX.4.64.0802121408150.9591@schroedinger.engr.sgi.com> (Christoph Lameter's message of "Tue, 12 Feb 2008 14:10:50 -0800 (PST)")
Message-ID: <adazlu5vlub.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Feb 2008 22:41:48.0658 (UTC) FILETIME=[73F80520:01C86DC8]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > > Chelsio's T3 HW doesn't support this.

 > Not so far I guess but it could be equipped with these features right? 

I don't know anything about the T3 internals, but it's not clear that
you could do this without a new chip design in general.  Lot's of RDMA
devices were designed expecting that when a packet arrives, the HW can
look up the bus address for a given memory region/offset and place the
packet immediately.  It seems like a major change to be able to
generate a "page fault" interrupt when a page isn't present, or even
just wait to scatter some data until the host finishes updating page
tables when the HW needs the translation.

 - R.

