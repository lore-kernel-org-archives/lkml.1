Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451Ab0BEU4c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 15:56:32 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:34567 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab0BEU4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 15:56:30 -0500
Date: Fri, 5 Feb 2010 14:55:20 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org, haicheng.li@intel.com,
       penberg@cs.helsinki.fi, linux-mm@kvack.org
Subject: Re: [PATCH] [0/4] SLAB: Fix a couple of slab memory hotadd issues
In-Reply-To: <87636bv3eq.fsf@basil.nowhere.org>
Message-ID: <alpine.DEB.2.00.1002051453050.27740@router.home>
References: <201002031039.710275915@firstfloor.org> <alpine.DEB.2.00.1002051316350.25989@router.home> <87636bv3eq.fsf@basil.nowhere.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Feb 2010, Andi Kleen wrote:

> > It changes the bootstrap semantics. The requirement was so far that slab
> > initialization must be complete before slab operations can be used.
>
> The problem is that slab itself uses slab it initialize itself.

slab uses itself and also the page allocator to bootstrap itself. The
sequence was always a bit fragile. The page allocator also needs to use
the slab allocator in turn to bootstrap itself.

> > This patchset allows such use before bootstrap on a node is complete and
> > also allows the running of cache reaper before bootstrap is done.
> >
> > I have a bad feeling that this could be the result of Pekka's changes to
> > the bootstrap.
>
> Not sure I fully follow what you're saying.
>
> Are you saying this is a regression fix after all?

I am saying that we may have more trouble lurking here.

If we fix it this way then the bootstrap of a node is different from
system bootstrap that so far does not need these special measures.

