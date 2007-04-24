Return-Path: <linux-kernel-owner+w=401wt.eu-S1422948AbXDXR4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422948AbXDXR4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 13:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422931AbXDXR4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 13:56:35 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51579 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422948AbXDXR4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 13:56:34 -0400
Date: Tue, 24 Apr 2007 10:56:33 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Hugh Dickins <hugh@veritas.com>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, pj@sgi.com
Subject: Re: Pagecache: find_or_create_page does not call a proper page
 allocator function
In-Reply-To: <20070424105147.be823d3b.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704241056040.8592@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704231408530.691@schroedinger.engr.sgi.com>
 <20070423142919.5809e03f.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704231503540.975@schroedinger.engr.sgi.com>
 <20070423154224.15ebf8f7.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704241339460.26223@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0704241036020.8341@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0704241841190.19956@blonde.wat.veritas.com>
 <20070424105147.be823d3b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007, Andrew Morton wrote:

> > I think that much is also true, but not where the problem lies.
> > Isn't the problem that filesystems using these block devices
> > expect their metadata to be accessible without kmap calls?
> > 
> 
> yup.  wherever we dereference buffer_head.b_data we're touching
> page_address(buffer_head.b_page) without kmapping.

Yes but before we get there we will bounce pagecache pages into an area 
where we do not need kmap.

