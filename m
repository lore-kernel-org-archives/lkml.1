Return-Path: <linux-kernel-owner+w=401wt.eu-S966011AbXDHAVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966011AbXDHAVk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 20:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966012AbXDHAVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 20:21:40 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46488 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966011AbXDHAVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 20:21:39 -0400
Date: Sat, 7 Apr 2007 17:21:38 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Hugh Dickins <hugh@veritas.com>, Nick Piggin <npiggin@suse.de>,
       dgc@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Optimize compound_head() by avoiding a shared page
 flag
In-Reply-To: <20070407155148.94da92e8.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704071718530.31790@schroedinger.engr.sgi.com>
References: <20070405223651.21698.77505.sendpatchset@schroedinger.engr.sgi.com>
 <20070405223657.21698.32754.sendpatchset@schroedinger.engr.sgi.com>
 <20070406222336.4dcdd663.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704071509550.31503@schroedinger.engr.sgi.com>
 <20070407155148.94da92e8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Apr 2007, Andrew Morton wrote:

> Which is all a ton of fun, but this subversion of the architecture's
> freedom to use volatile, memory barriers etc is a worry.  We do the same in
> page_alloc.c, of course...  

I just tried the approach that we discussed earlier and it was not 
nice either. Lets just use a page flag please. This check will be in 
several hot code paths. And it may become more important because the file 
system folks want to support buffers > page size. Then we may want more 
transparent support for huge pages... For all of this page->private gets 
in the way.

And I think we curently have 5 or so page flags available?

