Return-Path: <linux-kernel-owner+w=401wt.eu-S1422887AbXDXRpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422887AbXDXRpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 13:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422889AbXDXRpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 13:45:44 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:21693 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422881AbXDXRpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 13:45:17 -0400
X-AuditID: d80ac287-ab3e3bb00000590d-ed-462e422c663c 
Date: Tue, 24 Apr 2007 18:45:03 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Christoph Lameter <clameter@sgi.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, pj@sgi.com
Subject: Re: Pagecache: find_or_create_page does not call a proper page
 allocator function
In-Reply-To: <Pine.LNX.4.64.0704241036020.8341@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0704241841190.19956@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0704231408530.691@schroedinger.engr.sgi.com>
 <20070423142919.5809e03f.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704231503540.975@schroedinger.engr.sgi.com>
 <20070423154224.15ebf8f7.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704241339460.26223@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0704241036020.8341@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 24 Apr 2007 17:45:16.0218 (UTC) FILETIME=[5166A1A0:01C78698]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007, Christoph Lameter wrote:
> On Tue, 24 Apr 2007, Hugh Dickins wrote:
> 
> > I've not yet looked at the patch under discussion, but this remark
> > prompts me...  a couple of days ago I got very worried by the various
> > hard-wired GFP_HIGHUSER allocations in mm/migrate.c and mm/mempolicy.c,
> > and wondered how those would work out if someone has a blockdev mmap'ed.
> 
> Hmmm.... These not that critical given that 32 bit NUMA systems are a bit 
> rare.

That's true.  And everybody but the owners of those systems wish
fervently that they didn't exist ;)

> And if a page is in the wrong area then it can be bounced before I/O 
> is performed on it.

I think that much is also true, but not where the problem lies.
Isn't the problem that filesystems using these block devices
expect their metadata to be accessible without kmap calls?

Hugh
