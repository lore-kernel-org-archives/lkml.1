Return-Path: <linux-kernel-owner+w=401wt.eu-S1756225AbZJ0Cna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbZJ0Cna (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 22:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756191AbZJ0CnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 22:43:21 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48502 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705AbZJ0Cm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 22:42:58 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 5/5] ONLY-APPLY-IF-STILL-FAILING Revert 373c0a7e, 8aa7e847: Fix congestion_wait() sync/async vs read/write confusion
Cc: kosaki.motohiro@jp.fujitsu.com, Frans Pop <elendil@planet.nl>,
       Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       David Miller <davem@davemloft.net>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Kalle Valo <kalle.valo@iki.fi>, David Rientjes <rientjes@google.com>,
       Mohamed Abbas <mohamed.abbas@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org\"" <linux-mm@kvack.org>
In-Reply-To: <1256221356-26049-6-git-send-email-mel@csn.ul.ie>
References: <1256221356-26049-1-git-send-email-mel@csn.ul.ie> <1256221356-26049-6-git-send-email-mel@csn.ul.ie>
Message-Id: <20091026235628.2F7B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 27 Oct 2009 11:42:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Testing by Frans Pop indicates that in the 2.6.30..2.6.31 window at
> least that the commits 373c0a7e 8aa7e847 dramatically increased the
> number of GFP_ATOMIC failures that were occuring within a wireless
> driver. It was never isolated which of the changes was the exact problem
> and it's possible it has been fixed since. If problems are still
> occuring with GFP_ATOMIC in 2.6.31-rc5, then this patch should be
> applied to determine if the congestion_wait() callers are still broken.

Oops. no, please no.
8aa7e847 is regression fixing commit. this revert indicate the regression
occur again.
if we really need to revert it, we need to revert 1faa16d2287 too.
however, I doubt this commit really cause regression to iwlan. IOW,
I agree Jens.

I hope to try reproduce this problem on my test environment. Can anyone
please explain reproduce way?
Is special hardware necessary?


----------------------------------------------------
commit 8aa7e847d834ed937a9ad37a0f2ad5b8584c1ab0
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Thu Jul 9 14:52:32 2009 +0200

    Fix congestion_wait() sync/async vs read/write confusion

    Commit 1faa16d22877f4839bd433547d770c676d1d964c accidentally broke
    the bdi congestion wait queue logic, causing us to wait on congestion
    for WRITE (== 1) when we really wanted BLK_RW_ASYNC (== 0) instead.

    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>



