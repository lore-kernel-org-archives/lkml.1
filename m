Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbXKIQTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbXKIQTi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 11:19:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbXKIQTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 11:19:31 -0500
Received: from relay1.corp.sgi.com ([192.48.171.29]:47581 "EHLO relay.sgi.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751173AbXKIQTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 11:19:30 -0500
Date: Fri, 9 Nov 2007 08:19:29 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@skynet.ie>
cc: akpm@linux-foundation.org, Lee.Schermerhorn@hp.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, rientjes@google.com,
       nacc@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 6/6] Use one zonelist that is filtered by nodemask
In-Reply-To: <20071109161455.GB32088@skynet.ie>
Message-ID: <Pine.LNX.4.64.0711090818100.14292@schroedinger.engr.sgi.com>
References: <20071109143226.23540.12907.sendpatchset@skynet.skynet.ie>
 <20071109143426.23540.44459.sendpatchset@skynet.skynet.ie>
 <Pine.LNX.4.64.0711090741120.13932@schroedinger.engr.sgi.com>
 <20071109161455.GB32088@skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Nov 2007, Mel Gorman wrote:

> > Argh.... GFP_THISNODE must use the nid passed to alloc_pages_node and 
> > *not* the local numa node id. Only if the node specified to alloc_pages 
> > nodes is -1 will this work.
> > 
> 
> alloc_pages_node() calls __alloc_pages_nodemask() though where in this
> function if I'm reading it right is called without a node id. Given no
> other details on the nid, the current one seemed a logical choice.

If the function only called when the first zone == numa_node_id then 
the use of numa_node_id here is okay.


