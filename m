Return-Path: <linux-kernel-owner+w=401wt.eu-S1422906AbXDXRwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422906AbXDXRwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 13:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422909AbXDXRwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 13:52:18 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35910 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422906AbXDXRwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 13:52:16 -0400
Date: Tue, 24 Apr 2007 10:51:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Christoph Lameter <clameter@sgi.com>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, pj@sgi.com
Subject: Re: Pagecache: find_or_create_page does not call a proper page
 allocator function
Message-Id: <20070424105147.be823d3b.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704241841190.19956@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0704231408530.691@schroedinger.engr.sgi.com>
	<20070423142919.5809e03f.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704231503540.975@schroedinger.engr.sgi.com>
	<20070423154224.15ebf8f7.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704241339460.26223@blonde.wat.veritas.com>
	<Pine.LNX.4.64.0704241036020.8341@schroedinger.engr.sgi.com>
	<Pine.LNX.4.64.0704241841190.19956@blonde.wat.veritas.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007 18:45:03 +0100 (BST) Hugh Dickins <hugh@veritas.com> wrote:

> On Tue, 24 Apr 2007, Christoph Lameter wrote:
> > On Tue, 24 Apr 2007, Hugh Dickins wrote:
> > 
> > > I've not yet looked at the patch under discussion, but this remark
> > > prompts me...  a couple of days ago I got very worried by the various
> > > hard-wired GFP_HIGHUSER allocations in mm/migrate.c and mm/mempolicy.c,
> > > and wondered how those would work out if someone has a blockdev mmap'ed.
> > 
> > Hmmm.... These not that critical given that 32 bit NUMA systems are a bit 
> > rare.
> 
> That's true.  And everybody but the owners of those systems wish
> fervently that they didn't exist ;)
> 
> > And if a page is in the wrong area then it can be bounced before I/O 
> > is performed on it.
> 
> I think that much is also true, but not where the problem lies.
> Isn't the problem that filesystems using these block devices
> expect their metadata to be accessible without kmap calls?
> 

yup.  wherever we dereference buffer_head.b_data we're touching
page_address(buffer_head.b_page) without kmapping.
