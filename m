Return-Path: <linux-kernel-owner+w=401wt.eu-S1753071AbXINHm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbXINHm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 03:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750960AbXINHmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 03:42:50 -0400
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:34093 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbXINHmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 03:42:49 -0400
Message-Id: <6.0.0.20.2.20070914162337.037e82e0@172.19.0.2>
X-Mailer: QUALCOMM Windows Eudora Version 6J-Jr3
Date: Fri, 14 Sep 2007 16:42:01 +0900
To: Andrew Morton <akpm@linux-foundation.org>
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [PATCH] mm: use pagevec to rotate reclaimable page
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20070913193711.ecc825f7.akpm@linux-foundation.org>
References: <6.0.0.20.2.20070907113025.024dfbb8@172.19.0.2>
 <20070913193711.ecc825f7.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your comment.

At 11:37 07/09/14, Andrew Morton wrote:

 >The page_count() test here is a bit of a worry, too.  Why do we need it?
 >The caller must have pinned the page in some fashion else we couldn't use
 >it safely in this function at all.
 >
 >I assume that you discovered that once we've cleared PageWriteback(), the
 >page can get reclaimed elsewhere?  If so, that could still happen
 >immediately after the page_count() test.  It's all a bit of a worry.
 >Deferring the ClearPageWriteback() will fix any race concerns, but I do
 >think that we need to take a ref on the page for the pagevec ownership.
 >

Actually, I considered taking a ref to pin pages. But this could prevent 
the page
reclaiming activity so I did not use it.

I reflect your comment and send you modified patch.

