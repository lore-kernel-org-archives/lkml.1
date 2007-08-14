Return-Path: <linux-kernel-owner+w=401wt.eu-S1762922AbXHNP33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762922AbXHNP33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 11:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757452AbXHNP3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 11:29:22 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:40408 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755508AbXHNP3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 11:29:21 -0400
Date: Tue, 14 Aug 2007 08:29:20 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <peterz@infradead.org>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/3] Recursive reclaim (on __PF_MEMALLOC)
In-Reply-To: <1187102203.6114.2.camel@twins>
Message-ID: <Pine.LNX.4.64.0708140828060.27248@schroedinger.engr.sgi.com>
References: <20070814142103.204771292@sgi.com> <1187102203.6114.2.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2007, Peter Zijlstra wrote:

> On Tue, 2007-08-14 at 07:21 -0700, Christoph Lameter wrote:
> > The following patchset implements recursive reclaim. Recursive reclaim
> > is necessary if we run out of memory in the writeout patch from reclaim.
> > 
> > This is f.e. important for stacked filesystems or anything that does
> > complicated processing in the writeout path.
> > 
> > Recursive reclaim works because it limits itself to only reclaim pages
> > that do not require writeout. It will only remove clean pages from the LRU.
> > The dirty throttling of the VM during regular reclaim insures that the amount
> > of dirty pages is limited. 
> 
> No it doesn't. All memory can be tied up by anonymous pages - who are
> dirty by definition and are not clamped by the dirty limit.

Ok but that could be addressed by making sure that a certain portion of 
memory is reserved for clean file backed pages.

