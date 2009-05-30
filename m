Return-Path: <linux-kernel-owner+w=401wt.eu-S1758973AbZE3GgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758973AbZE3GgA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 02:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbZE3Gfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 02:35:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56202 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbZE3Gfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 02:35:54 -0400
Date: Sat, 30 May 2009 08:42:44 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Russ Anderson <rja@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, Nick Piggin <npiggin@suse.de>,
       hugh@veritas.com, riel@redhat.com, akpm@linux-foundation.org,
       chris.mason@oracle.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, fengguang.wu@intel.com
Subject: Re: [PATCH] [13/16] HWPOISON: The high level memory error handler in the VM v3
Message-ID: <20090530064244.GJ1065@one.firstfloor.org>
References: <200905271012.668777061@firstfloor.org> <20090527201239.C2C9C1D0294@basil.firstfloor.org> <20090528082616.GG6920@wotan.suse.de> <20090528093141.GD1065@one.firstfloor.org> <20090528120854.GJ6920@wotan.suse.de> <20090528134520.GH1065@one.firstfloor.org> <20090528165625.GA17572@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090528165625.GA17572@sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for late answer, email slipped out earlier.

On Thu, May 28, 2009 at 11:56:25AM -0500, Russ Anderson wrote:
> > I changed it to 
> > 
> >  "MCE: Unable to determine user space address during error handling\n")
> > 
> > Still not perfect, but hopefully better.
> 
> Is it even worth having a message at all?  Does the fact that page_address_in_vma()

I like having a message so that I can see when it happens.

> failed change the behavior in any way?  (Does tk->addr == 0 matter?)  From

It just doesn't report an address to the user (or rather 0)

> If the message is for developers/debugging, it would be nice to have more

It's not really for debugging only, it's a legitimate case. Typically
when the process unmaps or remaps in parallel. Of course when it currently
unmaps you could argue it doesn't need the data anymore and doesn't
need to be killed (that's true), but that doesn't work for mremap()ing.
I considered at some point to loop, but that would risk live lock.
So it just prints and reports nothing.

The only ugly part is the ambiguity of reporting a 0 address (in theory
there could be real memory 0 on virtual 0), but that didn't seem to be
enough an issue to fix.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
