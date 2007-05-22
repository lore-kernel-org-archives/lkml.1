Return-Path: <linux-kernel-owner+w=401wt.eu-S1758783AbXEVF1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783AbXEVF1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 01:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755470AbXEVF1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 01:27:17 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42147 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755369AbXEVF1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 01:27:17 -0400
Date: Mon, 21 May 2007 22:27:16 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: Define CONFIG_BOUNCE to avoid useless inclusion of bounce buffer
 logic.
In-Reply-To: <20070522133906.ae9c362a.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0705212225590.25388@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0705212100420.24947@schroedinger.engr.sgi.com>
 <20070522133906.ae9c362a.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2007, KAMEZAWA Hiroyuki wrote:

> > +config BOUNCE
> > +	def_bool y
> > +	depends on BLOCK && MMU && (ZONE_DMA || HIGHMEM)
> > +
> 
> AFAIK, ppc has only ZONE_DMA and it never needs bounce.
> Is this ok ?

That is wrong. ppc should have ZONE_NORMAL and no ZONE_DMA.
Otherwise you cannot switch off ZONE_DMA and you cannot switch off 
bounce. ZONE_DMA is a zone for exceptional allocs. If you do not have 
those then you only have normal allocs -> ZONE_NORMAL.


