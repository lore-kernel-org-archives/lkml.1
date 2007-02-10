Return-Path: <linux-kernel-owner+w=401wt.eu-S1752053AbXBJWoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbXBJWoy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 17:44:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbXBJWoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 17:44:54 -0500
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:34521 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbXBJWox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 17:44:53 -0500
Subject: Re: [patch 0/3] 2.6.20 fix for PageUptodate memorder problem (try
	3)
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, Hugh Dickins <hugh@veritas.com>,
       Linux Memory Management <linux-mm@kvack.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070210001844.21921.48605.sendpatchset@linux.site>
References: <20070210001844.21921.48605.sendpatchset@linux.site>
Content-Type: text/plain
Organization: IBM Corporation
Date: Sat, 10 Feb 2007 23:44:55 +0100
Message-Id: <1171147495.31563.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-02-10 at 03:31 +0100, Nick Piggin wrote:
> SetNewPageUptodate does not do the S390 page_test_and_clear_dirty, so
> I'd like to make sure that's OK.

An I/O operation on s390 will set the dirty bit for a page. That is the
reason to have SetPageUptodate clear the per page dirty bit when the
page is made uptodate the first time. Otherwise we end up writing each
page back to its backing device at least once. If SetNewPageUptodate is
used on new anonymous pages exclusively I don't see a problem in
omitting the page_test_clear_dirty.

-- 
blue skies,
  Martin.

Martin Schwidefsky
Linux for zSeries Development & Services
IBM Deutschland Entwicklung GmbH

"Reality continues to ruin my life." - Calvin.


