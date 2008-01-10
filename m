Return-Path: <linux-kernel-owner+w=401wt.eu-S1758570AbYAJEVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570AbYAJEVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 23:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754857AbYAJEVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 23:21:31 -0500
Received: from mail.gmx.net ([213.165.64.20]:45523 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754875AbYAJEVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 23:21:30 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18lWAd4xzslJAzEIyPkYn6qWNJiNEtbNPwI7GjV/G
	eSEAxPbI8VqO66
Subject: Re: [vm] writing to UDF DVD+RW (/dev/sr0) while under memory
	pressure: box ==> doorstop
From: Mike Galbraith <efault@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       bfennema@falcon.csc.calpoly.edu
In-Reply-To: <20080109150139.311f68d3.akpm@linux-foundation.org>
References: <1199447212.4529.13.camel@homer.simson.net>
	 <1199612533.4384.54.camel@homer.simson.net>
	 <1199642470.3927.12.camel@homer.simson.net>
	 <20080106122954.d8f04c98.akpm@linux-foundation.org>
	 <1199790316.4094.57.camel@homer.simson.net>
	 <20080108033801.40d0043a.akpm@linux-foundation.org>
	 <1199805713.3571.12.camel@homer.simson.net>
	 <1199806071.4174.2.camel@homer.simson.net>
	 <1199877080.4340.19.camel@homer.simson.net>
	 <20080109150139.311f68d3.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 10 Jan 2008 05:21:25 +0100
Message-Id: <1199938885.4324.80.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-09 at 15:01 -0800, Andrew Morton wrote:

> So are you saying that the fs throughput is unaltered by this change,
> but that the side-effects which your workload has on the overall
> machine are lessened?

Yes.  UDF IO is still a slow trickle, but the box is now fine under VM
stress, vs all allocating tasks eventually getting nailed (essentially
forever) by iprune_mutex previously.

	-Mike

P.S.  I would submit one-liner for VFS part, but it's useless without
UDF part, and nobody is hitting what I ran into while testing alleged
scsi_done regression thingy anyway.  cc added.

