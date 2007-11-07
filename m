Return-Path: <linux-kernel-owner+w=401wt.eu-S1756172AbXKGDCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbXKGDCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 22:02:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbXKGDCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 22:02:48 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37335 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753514AbXKGDCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 22:02:47 -0500
Date: Tue, 6 Nov 2007 19:02:47 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Rik van Riel <riel@redhat.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH 3/10] define page_file_cache
In-Reply-To: <20071106215552.4ab7df81@bree.surriel.com>
Message-ID: <Pine.LNX.4.64.0711061856400.5565@schroedinger.engr.sgi.com>
References: <20071103184229.3f20e2f0@bree.surriel.com>
 <20071103185516.24832ab0@bree.surriel.com> <Pine.LNX.4.64.0711061821010.5249@schroedinger.engr.sgi.com>
 <20071106215552.4ab7df81@bree.surriel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Nov 2007, Rik van Riel wrote:

> > I think we could add a flag to the bdi to indicate wheter the backing 
> > store is a disk file. In fact you can also deduce if if a device has
> > no writeback capability set in the BDI.
> > 
> > > Unfortunately this needs to use a page flag, since the
> > > PG_swapbacked state needs to be preserved all the way
> > > to the point where the page is last removed from the
> > > LRU.  Trying to derive the status from other info in
> > > the page resulted in wrong VM statistics in earlier
> > > split VM patchsets.
> > 
> > The bdi may avoid that extra flag.
> 
> The bdi will no longer be accessible by the time a page
> makes it to free_hot_cold_page, which is one place in the
> kernel where this information is needed.

At that point you need only information about which list the page
was put on. Dont we need something like PageLRU -> PageFileLRU
and PageMemLRU?

The page may change its nature I think? What if a page becomes
swap backed?
