Return-Path: <linux-kernel-owner+w=401wt.eu-S1757034AbZJSRBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034AbZJSRBh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 13:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756089AbZJSRBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 13:01:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58141 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519AbZJSRBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 13:01:35 -0400
Date: Mon, 19 Oct 2009 13:01:15 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Chris Mason <chris.mason@oracle.com>, Mel Gorman <mel@csn.ul.ie>,
       Frans Pop <elendil@planet.nl>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Mohamed Abbas <mohamed.abbas@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "John W. Linville" <linville@tuxdriver.com>, linux-mm@kvack.org
Subject: Re: [Bug #14141] order 2 page allocation failures in iwlagn
Message-ID: <20091019170115.GA4593@infradead.org>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <20091014103002.GA5027@csn.ul.ie> <200910141510.11059.elendil@planet.nl> <200910190133.33183.elendil@planet.nl> <20091019140151.GC9036@csn.ul.ie> <20091019161815.GA11487@think>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091019161815.GA11487@think>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 20, 2009 at 01:18:15AM +0900, Chris Mason wrote:
> Waiting doesn't make it synchronous from the elevator point of view ;)
> If you're using WB_SYNC_NONE, it's a async write.  WB_SYNC_ALL makes it
> a sync write.  I only see WB_SYNC_NONE in vmscan.c, so we should be
> using the async congestion wait.  (the exception is xfs which always
> does async writes).

That's only because those people who did the global sweep did not bother
to convert it or even tell the list about it.  I have a patch in my
QA queue to change it..

