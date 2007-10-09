Return-Path: <linux-kernel-owner+w=401wt.eu-S1756596AbXJISrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbXJISrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 14:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbXJISrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 14:47:13 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34235 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752543AbXJISrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 14:47:12 -0400
Date: Tue, 9 Oct 2007 11:47:10 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nishanth Aravamudan <nacc@us.ibm.com>
cc: Mel Gorman <mel@skynet.ie>, akpm@linux-foundation.org,
       Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 6/6] Use one zonelist that is filtered by nodemask
In-Reply-To: <20071009162526.GC26472@us.ibm.com>
Message-ID: <Pine.LNX.4.64.0710091146360.32162@schroedinger.engr.sgi.com>
References: <20070928142326.16783.98817.sendpatchset@skynet.skynet.ie>
 <20070928142526.16783.97067.sendpatchset@skynet.skynet.ie>
 <20071009011143.GC14670@us.ibm.com> <20071009154052.GC12632@skynet.ie>
 <20071009162526.GC26472@us.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Oct 2007, Nishanth Aravamudan wrote:

> > > And nodemask_thisnode() always gives us a nodemask with only the node
> > > the current process is running on set, I think?
> > > 
> > 
> > Yes, I interpreted THISNODE to mean "this node I am running on".
> > Callers seemed to expect this but the memoryless needs it to be "this
> > node I am running on unless I specify a node in which case I mean that
> > node.".
> 
> I think that is only true (THISNODE = local node) if the callpath is not
> via alloc_pages_node(). If the callpath is via alloc_pages_node(), then
> it depends on whether the nid parameter is -1 (in which case it is also
> local node) or anything (in which case it is the nid specified). Ah,
> reading further along, that's exactly what your changelog indicates too
> :)

Right. THISNODE means the node we are on or the node that we indicated we 
want to allocate from. 

