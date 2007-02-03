Return-Path: <linux-kernel-owner+w=401wt.eu-S1750698AbXBCRdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750698AbXBCRdU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 12:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbXBCRdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 12:33:20 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:38954 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750698AbXBCRdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 12:33:19 -0500
Date: Sat, 3 Feb 2007 09:33:01 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Christoph Hellwig <hch@infradead.org>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [RFC] Tracking mlocked pages and moving them off the LRU
In-Reply-To: <20070203101628.GB28806@infradead.org>
Message-ID: <Pine.LNX.4.64.0702030931460.5355@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702022214580.3960@schroedinger.engr.sgi.com>
 <20070203101628.GB28806@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Feb 2007, Christoph Hellwig wrote:

> This patch seems to not handle the cases where more than one process mlocks
> a page and you really need a pincount in the page to not release it before
> all processes have munlock it or died.  I did a similar patch a while
> ago and tried to handle it by overloading the lru lists pointers with
> a pincount, but at some point I gave up because I couldn't get that part
> right.

It doees handle that case. Before PageMlocked is cleared for a page we 
check for vmas referencing the page that have VM_LOCKED set. That logic 
makes the patch so big.

