Return-Path: <linux-kernel-owner+w=401wt.eu-S1762642AbXEKBJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762642AbXEKBJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 21:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbXEKBJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 21:09:15 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49291 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866AbXEKBJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 21:09:14 -0400
Date: Fri, 11 May 2007 10:09:47 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: y-goto@jp.fujitsu.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@osdl.org, mel@csn.ul.ie
Subject: Re: [RFC] memory hotremove patch take 2 [01/10] (counter of
 removable page)
Message-Id: <20070511100947.470a764d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0705101058260.10002@schroedinger.engr.sgi.com>
References: <20070509115506.B904.Y-GOTO@jp.fujitsu.com>
	<20070509120132.B906.Y-GOTO@jp.fujitsu.com>
	<Pine.LNX.4.64.0705101058260.10002@schroedinger.engr.sgi.com>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 11:00:31 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On Wed, 9 May 2007, Yasunori Goto wrote:
> 
> >  
> > +unsigned int nr_free_movable_pages(void)
> > +{
> > +	unsigned long nr_pages = 0;
> > +	struct zone *zone;
> > +	int nid;
> > +
> > +	for_each_online_node(nid) {
> > +		zone = &(NODE_DATA(nid)->node_zones[ZONE_MOVABLE]);
> > +		nr_pages += zone_page_state(zone, NR_FREE_PAGES);
> > +	}
> > +	return nr_pages;
> > +}
> 
> 
> Hmmmm... This is redoing what the vm counters already provide
> 
> Could you add
> 
> NR_MOVABLE_PAGES etc.
> 
> instead and then let the ZVC counter logic take care of the rest?
> 
Okay, we'll try ZVC.

Thanks,
-Kame

