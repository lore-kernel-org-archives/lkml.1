Return-Path: <linux-kernel-owner+w=401wt.eu-S1764235AbXK3AMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764235AbXK3AMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 19:12:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764240AbXK3ALd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 19:11:33 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52552 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764225AbXK3ALb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 19:11:31 -0500
Date: Fri, 30 Nov 2007 09:14:24 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc3-mm2 (bugfix for memory cgroup per-zone-struct
 allocation.)
Message-Id: <20071130091424.03731568.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1196371533.5347.11.camel@localhost>
References: <20071128034140.648383f0.akpm@linux-foundation.org>
	<20071129122329.4c56c052.kamezawa.hiroyu@jp.fujitsu.com>
	<20071129142416.f6d1ffcd.kamezawa.hiroyu@jp.fujitsu.com>
	<1196371533.5347.11.camel@localhost>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 16:25:33 -0500
Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:
> > -	pn = kmalloc_node(sizeof(*pn), GFP_KERNEL, node);
> > +	/*
> > +	 * This routine is called against possible nodes.
> > +	 * But it's BUG to call kmalloc() against offline node.
> > +	 *
> > +	 * TODO: this routine can waste much memory for nodes which will
> > +	 *       never be onlined. It's better to use memory hotplug callback
> > +	 *       function.
> > +	 */
> > +	if (node_state(node, N_HIGH_MEMORY))
> > +		pn = kmalloc_node(sizeof(*pn), GFP_KERNEL, node);
> > +	else
> > +		pn = kmalloc(sizeof(*pn), GFP_KERNEL);
> >  	if (!pn)
> >  		return 1;
> >  
> > 
> 
> This worked for me.  Can boot 24-rc3-mm2 [if I turn off async scsi scan,
> that is--not related to mem controller].  
> 
Thank you !

> Just FYI, on my ia64 platform, with NODES_SHIFT == 8 [RHEL & SLES ship
> with 10, I believe], the size of the mem_cgroup structure is ~10KB.
> 
Yes. But...
I'll ask Goto-san how memory hotplug callback works and try it.

Thanks,
-Kame


