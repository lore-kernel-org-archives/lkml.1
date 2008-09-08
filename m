Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbYIHDIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbYIHDIr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 23:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbYIHDIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 23:08:40 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40698 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136AbYIHDIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 23:08:40 -0400
Date: Mon, 08 Sep 2008 12:07:14 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC:Patch: 008/008](memory hotplug) remove_pgdat() function
Cc: Badari Pulavarty <pbadari@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-mm <linux-mm@kvack.org>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>
In-Reply-To: <1220710895.8687.12.camel@twins.programming.kicks-ass.net>
References: <20080731210326.2A51.E1E9C6FF@jp.fujitsu.com> <1220710895.8687.12.camel@twins.programming.kicks-ass.net>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080908120324.B3DA.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 2008-07-31 at 21:04 +0900, Yasunori Goto wrote:
> 
> > +int remove_pgdat(int nid)
> > +{
> > +	struct pglist_data *pgdat = NODE_DATA(nid);
> > +
> > +	if (cpus_busy_on_node(nid))
> > +		return -EBUSY;
> > +
> > +	if (sections_busy_on_node(pgdat))
> > +		return -EBUSY;
> > +
> > +	node_set_offline(nid);
> > +	synchronize_sched();
> > +	synchronize_srcu(&pgdat_remove_srcu);
> > +
> > +	free_pgdat(nid, pgdat);
> > +
> > +	return 0;
> > +}
> 
> FWIW synchronize_sched() is the wrong function to use here,
> synchronize_rcu() is the right one.

Thanks. I'll fix it.


-- 
Yasunori Goto 


