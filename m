Return-Path: <linux-kernel-owner+w=401wt.eu-S1753495AbYIVP4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbYIVP4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 11:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822AbYIVP4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 11:56:09 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:40984 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbYIVP4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 11:56:07 -0400
Subject: Re: [PATCH 1/2] Report the pagesize backing a VMA in
	/proc/pid/smaps
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
In-Reply-To: <1222047492-27622-2-git-send-email-mel@csn.ul.ie>
References: <1222047492-27622-1-git-send-email-mel@csn.ul.ie>
	 <1222047492-27622-2-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain
Date: Mon, 22 Sep 2008 08:55:55 -0700
Message-Id: <1222098955.8533.50.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-22 at 02:38 +0100, Mel Gorman wrote:
> It is useful to verify that a hugepage-aware application is using the expected
> pagesizes in each of its memory regions. This patch reports the pagesize
> backing the VMA in /proc/pid/smaps. This should not break any sensible
> parser as the file format is multi-line and it should skip information it
> does not recognise.

Time to play devil's advocate. :)

To be fair, this doesn't return the MMU pagesize backing the VMA.  It
returns pagesize that hugetlb reports *or* the kernel's base PAGE_SIZE.

The ppc64 case where we have a 64k PAGE_SIZE, but no hardware 64k
support means that we'll have a 4k MMU pagesize that we're pretending is
a 64k MMU page.  That might confuse someone seeing 16x the number of TLB
misses they expect.

This also doesn't work if, in the future, we get multiple page sizes
mapped under one VMA.  But, I guess that all only matters if you worry
about how the kernel is treating the pages vs. the MMU hardware.

-- Dave

