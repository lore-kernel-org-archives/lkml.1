Return-Path: <linux-kernel-owner+w=401wt.eu-S965550AbXCOMrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965550AbXCOMrF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 08:47:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965558AbXCOMrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 08:47:05 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:48559 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965550AbXCOMrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 08:47:02 -0400
Subject: Re: [PATCH] mm/filemap.c: unconditionally call mark_page_accessed
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Ashif Harji <asharji@cs.uwaterloo.ca>
Cc: Xiaoning Ding <dingxn@cse.ohio-state.edu>,
       Andreas Mohr <andi@rhlx01.fht-esslingen.de>, linux-mm@kvack.org,
       Nick Piggin <npiggin@suse.de>, Jan Kara <jack@suse.cz>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <Pine.GSO.4.64.0703150045550.18191@cpu102.cs.uwaterloo.ca>
References: <Pine.GSO.4.64.0703081612290.1080@cpu102.cs.uwaterloo.ca>
	 <Pine.GSO.4.64.0703150045550.18191@cpu102.cs.uwaterloo.ca>
Content-Type: text/plain
Date: Thu, 15 Mar 2007 07:46:56 -0500
Message-Id: <1173962816.14380.8.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-15 at 01:22 -0400, Ashif Harji wrote:

> I would tend to agree with David that:  "Any application doing many 
> tiny-sized reads isn't exactly asking for great performance."  As well, 
> applications concerned with performance and caching problems can read in a 
> file in PAGE_SIZE chunks.  I still think the simple fix of removing the 
> condition is the best approach, but I'm certainly open to alternatives.

A possible alternative might be to store the offset within the page in
the readahead state, and call mark_page_accessed() when the read offset
is less than or equal to the previous offset.

-- 
David Kleikamp
IBM Linux Technology Center

