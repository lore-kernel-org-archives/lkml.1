Return-Path: <linux-kernel-owner+w=401wt.eu-S1760544AbXEJSEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760544AbXEJSEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 14:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756816AbXEJSEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 14:04:39 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53794 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752880AbXEJSEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 14:04:38 -0400
Date: Thu, 10 May 2007 11:04:37 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Yasunori Goto <y-goto@jp.fujitsu.com>
cc: Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Andrew Morton <akpm@osdl.org>,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: [RFC] memory hotremove patch take 2 [02/10] (make page unused)
In-Reply-To: <20070509120248.B908.Y-GOTO@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0705101101460.10002@schroedinger.engr.sgi.com>
References: <20070509115506.B904.Y-GOTO@jp.fujitsu.com>
 <20070509120248.B908.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007, Yasunori Goto wrote:

> This patch is for supporting making page unused.
> 
> Isolate pages by capturing freed pages before inserting free_area[],
> buddy allocator.
> If you have an idea for avoiding spin_lock(), please advise me.

Using the zone lock instead may avoid to introduce another lock? Or is the 
new lock here for performance reasons?

Isnt it possible to just add another flavor of pages like what Mel has 
been doing with reclaimable and movable? I.e. add another category of free 
pages to Mel's scheme called isolated and use Mel's function to move stuff 
over there?

