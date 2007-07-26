Return-Path: <linux-kernel-owner+w=401wt.eu-S934129AbXGZO0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934129AbXGZO0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 10:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759938AbXGZOZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 10:25:53 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:49075 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759018AbXGZOZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 10:25:53 -0400
Date: Thu, 26 Jul 2007 15:25:50 +0100
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>, ak@suse.de,
       Christoph Lameter <clameter@sgi.com>, apw@shadowen.org,
       kamezawa.hiroyu@jp.fujitsu.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: bind_zonelist() - are we definitely sizing this correctly?
Message-ID: <20070726142550.GA14891@skynet.ie>
References: <20070726141756.GB18825@skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070726141756.GB18825@skynet.ie>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (26/07/07 15:17), Mel Gorman didst pronounce:
> I was looking closer at bind_zonelist() and it has the following snippet
> 
>         struct zonelist *zl;
>         int num, max, nd;
>         enum zone_type k;
> 
>         max = 1 + MAX_NR_ZONES * nodes_weight(*nodes);
>         max++;                  /* space for zlcache_ptr (see mmzone.h) */
>         zl = kmalloc(sizeof(struct zone *) * max, GFP_KERNEL);
>         if (!zl)
>                 return ERR_PTR(-ENOMEM);
> 
> That set off alarm bells because we are allocating based on the size of a
> zone, not the size of the zonelist.
> 

Never mind me, I'm a tool as it's now semi-obvious. When statically defined,
zlcache_ptr is pointing to something useful as it's setup at boottime. When
dynamically allocated in bind_zonelist, the zlcache_ptr is set to NULL so
it never gets used by zlc_setup().

This could have done with a comment.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
