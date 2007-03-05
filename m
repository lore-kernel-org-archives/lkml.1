Return-Path: <linux-kernel-owner+w=401wt.eu-S1752462AbXCEXKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbXCEXKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 18:10:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbXCEXKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 18:10:20 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:57259 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262AbXCEXKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 18:10:17 -0500
Subject: Re: [PATCH] fs: nobh_truncate_page() fix
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Will Trives <will@trivescon.com.au>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Chuck Ebbert <cebbert@redhat.com>
In-Reply-To: <20070305145753.1180a1d4.akpm@linux-foundation.org>
References: <20070305150317.57e62d70@disher.kickcrew>
	 <45EC3058.2010903@redhat.com>
	 <1173108985.9109.11.camel@kleikamp.austin.ibm.com>
	 <1173109811.9109.17.camel@kleikamp.austin.ibm.com>
	 <1173128289.9109.36.camel@kleikamp.austin.ibm.com>
	 <Pine.LNX.4.64.0703051333140.3998@woody.linux-foundation.org>
	 <20070305145753.1180a1d4.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 05 Mar 2007 17:10:11 -0600
Message-Id: <1173136211.9109.81.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-05 at 14:57 -0800, Andrew Morton wrote:
> Is OK, I think.  nobh_prepare_write() brings the outside-from-and-to
> sections of the page uptodate and memset in nobh_truncate_page() brings the
> rest of the page uptodate.
> 
> We bring the to->PAGE_CACHE_SIZE section uptodate twice, which could be
> optimised.

Why not have nobh_truncate_page() call prepare_write() with to =
PAGE_CACHE_SIZE?  I don't really grok:

to = (offset + blocksize) & ~(blocksize - 1);
-- 
David Kleikamp
IBM Linux Technology Center

