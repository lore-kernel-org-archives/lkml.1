Return-Path: <linux-kernel-owner+w=401wt.eu-S1758155AbYBICQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155AbYBICQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 21:16:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756648AbYBICQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 21:16:20 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43879 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756632AbYBICQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 21:16:19 -0500
Date: Fri, 8 Feb 2008 18:16:16 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Roland Dreier <rdreier@cisco.com>, a.p.zijlstra@chello.nl,
       izike@qumranet.com, steiner@sgi.com, linux-kernel@vger.kernel.org,
       avi@qumranet.com, linux-mm@kvack.org, daniel.blueman@quadrics.com,
       Robin Holt <holt@sgi.com>, general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net, Rik van Riel <riel@redhat.com>
Subject: Re: [ofa-general] Re: [patch 0/6] MMU Notifiers V6
In-Reply-To: <20080209015659.GC7051@v2.random>
Message-ID: <Pine.LNX.4.64.0802081813300.5602@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0802081540180.4291@schroedinger.engr.sgi.com>
 <20080208234302.GH26564@sgi.com> <20080208155641.2258ad2c.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0802081603430.4543@schroedinger.engr.sgi.com>
 <adaprv70yyt.fsf@cisco.com> <Pine.LNX.4.64.0802081614030.5115@schroedinger.engr.sgi.com>
 <adalk5v0yi6.fsf@cisco.com> <Pine.LNX.4.64.0802081634070.5298@schroedinger.engr.sgi.com>
 <20080209012446.GB7051@v2.random> <Pine.LNX.4.64.0802081725200.5445@schroedinger.engr.sgi.com>
 <20080209015659.GC7051@v2.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Feb 2008, Andrea Arcangeli wrote:

> The VM shouldn't break if try_to_unmap doesn't actually make the page
> freeable for whatever reason. Permanent pins shouldn't happen anyway,

VM is livelocking if too many page are pinned that way right now. The 
higher the processors per node the higher the risk of livelock because 
more processors are in the process of cycling through pages that have an 
elevated refcount.

> so defining an ad-hoc API for that doesn't sound too appealing. Not
> sure if old hardware deserves those special lru-size-reduction
> optimizations but it's not my call (certainly swapoff/mlock would get
> higher priority in that lru-size-reduction area).

Rik has a patchset under development that addresses issues like this. The 
elevated refcount pin problem is not really relevant to the patchset we 
are discussing here.
 
