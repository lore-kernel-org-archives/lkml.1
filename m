Return-Path: <linux-kernel-owner+w=401wt.eu-S1757559AbYE0Ox7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559AbYE0Ox7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 10:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756132AbYE0Oxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 10:53:51 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3340 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036AbYE0Oxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 10:53:51 -0400
Date: Tue, 27 May 2008 15:53:03 +0100
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@osdl.org>,
       Christoph Lameter <clameter@sgi.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] slub: record page flag overlays explicitly
Message-ID: <20080527145250.GA3407@shadowen.org>
References: <exportbomb.1211560342@pinky> <1211560402.0@pinky> <20080526133755.4664.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080526133755.4664.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: apw@shadowen.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2008 at 01:40:44PM +0900, KOSAKI Motohiro wrote:
> Hi
> 
> This patch works well on my box.
> but I have one question.
> 
> >  	if (s->flags & DEBUG_DEFAULT_FLAGS) {
> > -		if (!SlabDebug(page))
> > -			printk(KERN_ERR "SLUB %s: SlabDebug not set "
> > +		if (!PageSlubDebug(page))
> > +			printk(KERN_ERR "SLUB %s: SlubDebug not set "
> >  				"on slab 0x%p\n", s->name, page);
> >  	} else {
> > -		if (SlabDebug(page))
> > -			printk(KERN_ERR "SLUB %s: SlabDebug set on "
> > +		if (PageSlubDebug(page))
> > +			printk(KERN_ERR "SLUB %s: SlubDebug set on "
> >  				"slab 0x%p\n", s->name, page);
> >  	}
> >  }
> 
> Why if(SLABDEBUG) check is unnecessary?

They were unconditional before as well.  SlabDebug would always return
0 before the patch.  The point being, to my reading, that if you asked
for debug on the slab and debug was not compiled in you would still get
told that it was not set; which it cannot without the support.

-apw
