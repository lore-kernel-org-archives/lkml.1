Return-Path: <linux-kernel-owner+w=401wt.eu-S1755565AbYHSKfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbYHSKfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 06:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344AbYHSKf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 06:35:26 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53501 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbYHSKfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 06:35:25 -0400
Date: Tue, 19 Aug 2008 19:34:18 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: No, really, stop trying to delete slab until you've finished making slub perform as well
Cc: kosaki.motohiro@jp.fujitsu.com, Matthew Wilcox <matthew@wil.cx>,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, andi@firstfloor.org,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <48A98259.7030101@linux-foundation.org>
References: <20080818193143.60D7.KOSAKI.MOTOHIRO@jp.fujitsu.com> <48A98259.7030101@linux-foundation.org>
Message-Id: <20080819192515.12C5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +#if 0
> >         if (!s->remote_node_defrag_ratio ||
> >                         get_cycles() % 1024 > s->remote_node_defrag_ratio)
> >                 return NULL;
> > +#endif
> > 
> >         zonelist = node_zonelist(slab_node(current->mempolicy), flags);
> >         for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
> 
> Hmmm.... So always take from partial lists works? That is the same effect that
> the setting of the remote_defrag_ratio to 100 should have had (its multiplied
> by 10 when storing it).

Sorry, I don't know reason.
OK, I'll digg it more.

> So its a NUMA only phenomenon. How is performance affected?

Unfortunately, I can't mesure it.

because
   - Fujitsu server can access remote node fastly than typical numa server.
     So, my performance number often isn't typical.
   - My box (4G x2node) is very small in NUMA machine.
     but that is large server improving mechanism.

IOW, My box didn't happend performance regression.
but I think it isn't typical.



