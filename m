Return-Path: <linux-kernel-owner+w=401wt.eu-S1161162AbXD1WGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161162AbXD1WGg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 18:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161205AbXD1WGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 18:06:36 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:32138 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161162AbXD1WGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 18:06:35 -0400
Date: Sat, 28 Apr 2007 23:06:21 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Tilman Schmidt <tilman@imap.cc>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: 2.6.21-rc7-mm2 crash: Eeek! page_mapcount(page) went negative!
 (-1)
In-Reply-To: <20070428141024.887342bd.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704282300080.2223@blonde.wat.veritas.com>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
 <46338AEB.2070109@imap.cc> <20070428141024.887342bd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 28 Apr 2007 22:06:33.0893 (UTC) FILETIME=[7BACFD50:01C789E1]
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABWluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZwBsaW51eC1tbUBrdmFjay5vcmcAdGlsbWFuQGltYXAuY2MAbmlja3BpZ2dpbkB5YWhvby5jb20uYXUA
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007, Andrew Morton wrote:
> 
> It seems wildly screwed up that we have a PageReserved() page with a pfn of
> zero (!) which claims to be in a reiserfs mapping, only it isn't attached
> to a reiserfs file.  How the heck did that happen?

It's "simply" that it somehow got a spurious page table entry 00000001.
Great that it's so reproducible, I take that to mean this one is not
bad RAM.  Your request for a bisection is just what we want, thanks.

Hugh
