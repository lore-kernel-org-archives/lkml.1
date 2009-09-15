Return-Path: <linux-kernel-owner+w=401wt.eu-S1751076AbZIOELj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751076AbZIOELj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 00:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbZIOELd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 00:11:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:34822 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbZIOELd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 00:11:33 -0400
Date: Tue, 15 Sep 2009 06:15:12 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, mingo@elte.hu,
       yanmin_zhang@linux.intel.com, jens.axboe@oracle.com,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH v2] cpuidle: Fix the menu governor to boost IO
 performance
Message-ID: <20090915061512.0209d956@infradead.org>
In-Reply-To: <20090914205408.578f7f60.akpm@linux-foundation.org>
References: <20090915054259.5282e5ba@infradead.org>
	<20090914205408.578f7f60.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Sep 2009 20:54:08 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 15 Sep 2009 05:42:59 +0200 Arjan van de Ven
> <arjan@infradead.org> wrote:
> 
> > Rather than adding a new governor temporarily, this just puts the
> > fixes into the existing menu governor.
> 
> Oh, surprised.  I wasn't actually expecting that to happen.
> 
> <actually reads his email>
> 
> > I don't mind either way, will replace. 
> 
> OK.  I'm not particularly strongly opinionated either way.
> 
> The timing is awkward.  We could let it sit in Len's tree and
> linux-next for a couple of months or we could say what-the-hell and
> merge it.

If the performance impact wasn't this huge I'd say "let it sit".
As it is now, with a nearly 2x performance delta, I'd not be very happy
to expose linux users to this regression-like performance drop for
another 3 months. 

(especially given all the scheduler performance attention there is right
now; picking the wrong C state has clearly very high impact in similar
areas)

> 
> If the latter, your original merge plan sound better ;) But we should
> arrange for the new code to default to "on" for test coverage
> reasons. perhaps the original patch did that already?

the original patch defaulted to the new code yes.

redoing the split is not hard again.. just need to do a "cp" and put
the makefile glue back. I do like how the current patch shows exactly
which few things in the algorithm are changed..
(although it says 230 lines added, a lot of that are comments, the rest
isn't very big at all)



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
