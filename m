Return-Path: <linux-kernel-owner+w=401wt.eu-S1767186AbXDESPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767186AbXDESPZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 14:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767188AbXDESPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 14:15:25 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:52514 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767186AbXDESPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 14:15:24 -0400
Date: Thu, 5 Apr 2007 11:15:22 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: William Lee Irwin III <wli@holomorphy.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [i386] Use page allocator to allocate threadinfo structure
In-Reply-To: <20070405083021.GR2986@holomorphy.com>
Message-ID: <Pine.LNX.4.64.0704051114100.9800@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704041734270.22851@schroedinger.engr.sgi.com>
 <20070405083021.GR2986@holomorphy.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Apr 2007, William Lee Irwin III wrote:

> On Wed, Apr 04, 2007 at 05:40:31PM -0700, Christoph Lameter wrote:
> > Replace the calls to kmalloc with calls into the page allocator.
> > An alternate solution may be to create a custom slab cache where the 
> > alignment is set to PAGE_SIZE. That would allow slub debugging to be 
> > applied to the threadinfo structure.
> > Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> This was originally made a slab allocation as a preparatory cleanup
> for things that were never merged, and are never likely to be. One
> might as well revert it, though it does make stack space usage
> slightly more difficult to account for.

No other platform does account for kernel stack space though. And you got 
two pages per process. Pretty straightforward.
