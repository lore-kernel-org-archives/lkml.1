Return-Path: <linux-kernel-owner+w=401wt.eu-S1757638AbZJSV7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638AbZJSV7Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 17:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756295AbZJSV7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 17:59:15 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:25916 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755446AbZJSV7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 17:59:14 -0400
Date: Tue, 20 Oct 2009 06:57:57 +0900
From: Chris Mason <chris.mason@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Frans Pop <elendil@planet.nl>,
       David Rientjes <rientjes@google.com>,
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
Message-ID: <20091019215757.GC12570@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Christoph Hellwig <hch@infradead.org>, Mel Gorman <mel@csn.ul.ie>,
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
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera>
 <20091014103002.GA5027@csn.ul.ie>
 <200910141510.11059.elendil@planet.nl>
 <200910190133.33183.elendil@planet.nl>
 <20091019140151.GC9036@csn.ul.ie>
 <20091019161815.GA11487@think>
 <20091019170115.GA4593@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091019170115.GA4593@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4ADCE0EF.01A9:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 01:01:15PM -0400, Christoph Hellwig wrote:
> On Tue, Oct 20, 2009 at 01:18:15AM +0900, Chris Mason wrote:
> > Waiting doesn't make it synchronous from the elevator point of view ;)
> > If you're using WB_SYNC_NONE, it's a async write.  WB_SYNC_ALL makes it
> > a sync write.  I only see WB_SYNC_NONE in vmscan.c, so we should be
> > using the async congestion wait.  (the exception is xfs which always
> > does async writes).
> 
> That's only because those people who did the global sweep did not bother
> to convert it or even tell the list about it.  I have a patch in my
> QA queue to change it..

Yes, we just didn't realize XFS was missed.  Sorry.  I wasn't trying to
blame xfs for being behind, just mentioning that we've got about 10
different variables here and I'm having a hard time figuring out which
ones to push on.

-chris

