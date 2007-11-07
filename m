Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbXKGCXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbXKGCXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 21:23:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbXKGCXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 21:23:46 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36126 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751140AbXKGCXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 21:23:44 -0500
Date: Tue, 6 Nov 2007 18:23:44 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Rik van Riel <riel@redhat.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH 3/10] define page_file_cache
In-Reply-To: <20071103185516.24832ab0@bree.surriel.com>
Message-ID: <Pine.LNX.4.64.0711061821010.5249@schroedinger.engr.sgi.com>
References: <20071103184229.3f20e2f0@bree.surriel.com>
 <20071103185516.24832ab0@bree.surriel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Nov 2007, Rik van Riel wrote:

> Define page_file_cache() function to answer the question:
> 	is page backed by a file?

Well its not clear what is meant by a file in the first place.
By file you mean disk space in contrast to ram based filesystems?

I think we could add a flag to the bdi to indicate wheter the backing 
store is a disk file. In fact you can also deduce if if a device has
no writeback capability set in the BDI.

> Unfortunately this needs to use a page flag, since the
> PG_swapbacked state needs to be preserved all the way
> to the point where the page is last removed from the
> LRU.  Trying to derive the status from other info in
> the page resulted in wrong VM statistics in earlier
> split VM patchsets.

The bdi may avoid that extra flag.
