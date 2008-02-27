Return-Path: <linux-kernel-owner+w=401wt.eu-S1757397AbYB0EbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397AbYB0EbD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 23:31:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbYB0Eaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 23:30:52 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49324 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbYB0Eav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 23:30:51 -0500
Date: Wed, 27 Feb 2008 13:26:47 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC][PATCH] page reclaim throttle take2
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <1204060718.6242.333.camel@lappy>
References: <20080226104647.FF26.KOSAKI.MOTOHIRO@jp.fujitsu.com> <1204060718.6242.333.camel@lappy>
Message-Id: <20080227131939.4244.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

> > +
> > +	atomic_t		nr_reclaimers;
> > +	wait_queue_head_t	reclaim_throttle_waitq;
> >  	/*
> >  	 * rarely used fields:
> >  	 */
> 
> Small nit, that extra blank line seems at the wrong end of the text
> block :-)

Agghhh, sorry ;-)
I'll fix at next post.

> > +out:
> > +	atomic_dec(&zone->nr_reclaimers);
> > +	wake_up_all(&zone->reclaim_throttle_waitq);
> > +
> > +	return ret;
> > +}
> 
> Would it be possible - and worthwhile - to make this FIFO fair?

Hmmm
may be, we don't need perfectly fair.
because try_to_free_page() is unfair mechanism.

but I will test use wake_up() instead wake_up_all().
it makes so so fair order if no performance regression happend.

Thanks very useful comment.


- kosaki



