Return-Path: <linux-kernel-owner+w=401wt.eu-S1762681AbXGWWNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762681AbXGWWNs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 18:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbXGWWNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 18:13:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59359 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751641AbXGWWNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 18:13:39 -0400
Date: Mon, 23 Jul 2007 15:13:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Daniel Phillips <phillips@google.com>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] add __GFP_ZERP to GFP_LEVEL_MASK
Message-Id: <20070723151306.86e3e0ce.akpm@linux-foundation.org>
In-Reply-To: <20070723144323.1ac34b16@schroedinger.engr.sgi.com>
References: <1185185020.8197.11.camel@twins>
	<20070723113712.c0ee29e5.akpm@linux-foundation.org>
	<1185216048.5535.1.camel@lappy>
	<20070723144323.1ac34b16@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2007 14:43:23 -0700
Christoph Lameter <clameter@sgi.com> wrote:

> __GFP_ZERO is implemented by the slab allocators (the page allocator
> has no knowledge about the length of the object to be zeroed). The slab
> allocators do not pass __GFP_ZERO to the page allocator.

OK, well that was weird.  So

	kmalloc(42, GFP_KERNEL|__GFP_ZERO);

duplicates

	kzalloc(42, GFP_KERNEL);


Why do it both ways?
