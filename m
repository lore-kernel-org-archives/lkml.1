Return-Path: <linux-kernel-owner+w=401wt.eu-S1758054AbZBYSnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054AbZBYSnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 13:43:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754516AbZBYSnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 13:43:13 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:59207 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754166AbZBYSnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 13:43:13 -0500
Date: Wed, 25 Feb 2009 13:33:07 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       penberg@cs.helsinki.fi, riel@redhat.com, kosaki.motohiro@jp.fujitsu.com,
       hannes@cmpxchg.org, npiggin@suse.de, linux-kernel@vger.kernel.org,
       ming.m.lin@intel.com, yanmin_zhang@linux.intel.com
Subject: Re: [PATCH 20/20] Get rid of the concept of hot/cold page freeing
In-Reply-To: <20090225160124.GA31915@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0902251331340.24175@qirst.com>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie> <1235344649-18265-21-git-send-email-mel@csn.ul.ie> <20090223013723.1d8f11c1.akpm@linux-foundation.org> <20090223233030.GA26562@csn.ul.ie> <20090223155313.abd41881.akpm@linux-foundation.org>
 <20090224115126.GB25151@csn.ul.ie> <20090224160103.df238662.akpm@linux-foundation.org> <20090225160124.GA31915@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Feb 2009, Mel Gorman wrote:

> It'd impact it for sure. Due to the non-temporal stores, I'm surprised
> there is any measurable impact from the patch.  This has likely been the
> case since commit 0812a579c92fefa57506821fa08e90f47cb6dbdd. My reading of
> this (someone correct/enlighten) is that even if the data was cache hot,
> it is pushed out as a result of the non-temporal access.

A nontemporal store simply does not set the used flag for the cacheline.
So the cpu cache LRU will evict the cacheline sooner. Thats at least how
it works on I64.

