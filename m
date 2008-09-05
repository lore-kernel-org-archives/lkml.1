Return-Path: <linux-kernel-owner+w=401wt.eu-S1754659AbYIEBxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbYIEBxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 21:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122AbYIEBxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 21:53:01 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57830 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbYIEBxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 21:53:00 -0400
Date: Fri, 05 Sep 2008 10:52:10 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH 4/4] capture pages freed during direct reclaim for allocation by the reclaimer
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20080904144426.GB18776@brain>
References: <20080904162900.B262.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080904144426.GB18776@brain>
Message-Id: <20080905105137.5A47.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Hi Andy,
> > 
> > I like almost part of your patch.
> > (at least, I can ack patch 1/4 - 3/4)
> > 
> > So, I worry about OOM risk.
> > Can you remember desired page size to capture list (or any other location)?
> > if possible, __capture_on_page can avoid to capture unnecessary pages.
> > 
> > So, if __capture_on_page() can make desired size page by buddy merging, 
> > it can free other pages on capture_list.
> > 
> > In worst case, shrink_zone() is called by very much process at the same time.
> > Then, if each process doesn't back few pages, very many pages doesn't be backed.
> 
> The testing we have done pushes the system pretty damn hard, about as
> hard as you can.  Without the zone watermark checks in capture we would
> periodically lose a test to an OOM.  Since adding that I have never seen
> an OOM, so I am confident we are safe.  That said, clearly some wider
> testing in -mm would be very desirable to confirm that this does not
> tickle OOM for some unexpected workload.
>
> I think the idea of trying to short-circuit capture once it has a page
> of the requisit order or greater is eminently sensible.  I suspect we
> are going to have trouble getting the information to the right place,
> but it is clearly worth investigating.  It feels like a logical step on
> top of this, so I would propose to do it as a patch on top of this set.
> 
> Thanks for your feedback.

Ok. makes sense.
Thanks for good patch.

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



