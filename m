Return-Path: <linux-kernel-owner+w=401wt.eu-S1758720AbZE1Hrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720AbZE1Hrr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 03:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750983AbZE1Hrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 03:47:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41878 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133AbZE1Hrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 03:47:40 -0400
Date: Thu, 28 May 2009 09:54:16 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       fengguang.wu@intel.com
Subject: Re: [PATCH] [1/16] HWPOISON: Add page flag for poisoned pages
Message-ID: <20090528075416.GY1065@one.firstfloor.org>
References: <200905271012.668777061@firstfloor.org> <20090527201226.CCCBB1D028F@basil.firstfloor.org> <20090527221510.5e418e97@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527221510.5e418e97@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 10:15:10PM +0100, Alan Cox wrote:
> On Wed, 27 May 2009 22:12:26 +0200 (CEST)
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > 
> > Hardware poisoned pages need special handling in the VM and shouldn't be 
> > touched again. This requires a new page flag. Define it here.
> 
> Why can't you use PG_reserved ? That already indicates the page may not
> even be present (which is effectively your situation at that point).

Right now a page must be present with PG_reserved, otherwise /dev/mem, /proc/kcore
lots of other things will explode.

> Given lots of other hardware platforms we support bus error, machine
> check, explode or do random undefined fun things when you touch pages
> that don't exist I'm not sure I see why poisoned is different here ?

It's really a special case for lots of things and mixing it up with
PG_reserved is not very useful I think. Also page flags are not 
that tight a resource anymore anyways. I think it's better to have
it separated.

However I would expect that other architectures would use poisoned
pages too for their own similar issues. It's not really a x86 specific
concept.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
