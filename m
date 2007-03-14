Return-Path: <linux-kernel-owner+w=401wt.eu-S1422655AbXCNU4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422655AbXCNU4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 16:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422660AbXCNU4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 16:56:46 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:34905 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422655AbXCNU4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 16:56:45 -0400
Subject: Re: [PATCH] mm/filemap.c: unconditionally call mark_page_accessed
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Ashif Harji <asharji@cs.uwaterloo.ca>
Cc: linux-mm@kvack.org, Nick Piggin <npiggin@suse.de>, Jan Kara <jack@suse.cz>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <Pine.GSO.4.64.0703141218530.28958@cpu102.cs.uwaterloo.ca>
References: <Pine.GSO.4.64.0703081612290.1080@cpu102.cs.uwaterloo.ca>
	 <20070312142012.GH30777@atrey.karlin.mff.cuni.cz>
	 <20070312143900.GB6016@wotan.suse.de> <20070312151355.GB23532@duck.suse.cz>
	 <Pine.GSO.4.64.0703121247210.7679@cpu102.cs.uwaterloo.ca>
	 <20070312173500.GF23532@duck.suse.cz>
	 <Pine.GSO.4.64.0703131438580.8193@cpu102.cs.uwaterloo.ca>
	 <20070313185554.GA5105@duck.suse.cz>
	 <Pine.GSO.4.64.0703141218530.28958@cpu102.cs.uwaterloo.ca>
Content-Type: text/plain
Date: Wed, 14 Mar 2007 15:55:41 -0500
Message-Id: <1173905741.8763.36.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-14 at 15:58 -0400, Ashif Harji wrote:
> This patch unconditionally calls mark_page_accessed to prevent pages, 
> especially for small files, from being evicted from the page cache despite 
> frequent access.

I guess the downside to this is if a reader is reading a large file, or
several files, sequentially with a small read size (smaller than
PAGE_SIZE), the pages will be marked active after just one read pass.
My gut says the benefits of this patch outweigh the cost.  I would
expect real-world backup apps, etc. to read at least PAGE_SIZE.

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

