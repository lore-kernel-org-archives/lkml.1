Return-Path: <linux-kernel-owner+w=401wt.eu-S1030948AbXEEBBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030948AbXEEBBn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 21:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031332AbXEEBBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 21:01:42 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:18660 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030948AbXEEBBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 21:01:42 -0400
Date: Fri, 4 May 2007 18:04:01 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, dgc@sgi.com,
       Eric Dumazet <dada1@cosmosbay.com>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [RFC 2/3] SLUB: Implement targeted reclaim and partial list
 defragmentation
Message-Id: <20070504180401.5d5fc6dd.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0705041603150.27790@schroedinger.engr.sgi.com>
References: <20070504221555.642061626@sgi.com>
	<20070504221708.596112123@sgi.com>
	<Pine.LNX.4.64.0705041603150.27790@schroedinger.engr.sgi.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 May 2007 16:03:43 -0700 (PDT) Christoph Lameter wrote:

> Fixes suggested by Andrew
> 
> ---
>  include/linux/slab.h |   12 ++++++++++++
>  mm/slub.c            |   32 +++++++++++++++++++++-----------
>  2 files changed, 33 insertions(+), 11 deletions(-)
> 
>  	/* Perform the KICK callbacks to remove the objects */
>  	for(p = addr; p < addr + s->objects * s->size; p += s->size)

missed a space after "for".

> -		if (!test_bit((p - addr) / s->size, map))
> +		if (test_bit((p - addr) / s->size, map))
>  			s->slab_ops->kick_object(p);

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
