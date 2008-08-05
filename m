Return-Path: <linux-kernel-owner+w=401wt.eu-S1761456AbYHEQMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761456AbYHEQMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 12:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755655AbYHEQMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 12:12:34 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:40314 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452AbYHEQMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 12:12:33 -0400
Subject: Re: [RFC] [PATCH 0/5 V2] Huge page backed user-space stacks
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, ebmunson@us.ibm.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, libhugetlbfs-devel@lists.sourceforge.net,
       abh@cray.com
In-Reply-To: <20080805111147.GD20243@csn.ul.ie>
References: <cover.1216928613.git.ebmunson@us.ibm.com>
	 <20080730014308.2a447e71.akpm@linux-foundation.org>
	 <20080730172317.GA14138@csn.ul.ie>
	 <20080730103407.b110afc2.akpm@linux-foundation.org>
	 <20080730193010.GB14138@csn.ul.ie>
	 <20080730130709.eb541475.akpm@linux-foundation.org>
	 <20080731103137.GD1704@csn.ul.ie> <1217884211.20260.144.camel@nimitz>
	 <20080805111147.GD20243@csn.ul.ie>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 09:12:28 -0700
Message-Id: <1217952748.10907.18.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-05 at 12:11 +0100, Mel Gorman wrote:
> See, that's great until you start dealing with MAP_SHARED|MAP_ANONYMOUS.
> To get that right between children, you end up something very fs-like
> when the child needs to fault in a page that is already populated by the
> parent. I strongly suspect we end up back at hugetlbfs backing it :/

Yeah, but the case I'm worried about is plain anonymous.  We already
have the fs to back SHARED|ANONYMOUS, and they're not really
anonymous. :)

This patch *really* needs anonymous pages, and it kinda shoehorns them
in with the filesystem.  Stacks aren't shared at all, so this is a
perfect example of where we can forget the fs, right?

-- Dave

