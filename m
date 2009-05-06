Return-Path: <linux-kernel-owner+w=401wt.eu-S1757628AbZEFTWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628AbZEFTWH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 15:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754220AbZEFTVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 15:21:54 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59444 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778AbZEFTVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 15:21:53 -0400
Date: Wed, 6 May 2009 20:20:35 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <hannes@cmpxchg.org>, akpm@linux-foundation.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       hartleys@visionengravers.com, mcrapet@gmail.com, fred99@carolina.rr.com,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] Double check memmap is actually valid with a memmap
	has unexpected holes
Message-ID: <20090506192035.GB21993@n2100.arm.linux.org.uk>
References: <20090505082944.GA25904@csn.ul.ie> <20090505110653.GA16649@cmpxchg.org> <20090506143059.GB20709@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506143059.GB20709@csn.ul.ie>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 03:31:00PM +0100, Mel Gorman wrote:
> On Tue, May 05, 2009 at 01:06:53PM +0200, Johannes Weiner wrote:
> > I think we also need to fix up show_mem(). 
> 
> As it turns out, ARM has its own show_mem(). I don't see how, but ARM
> must not be using lib/show_mem.c even though it compiles it.

That happens because lib/show_mem.c is a library file, and since there
isn't an unresolved reference to show_mem in from within the object
files ld is asked to link, the version in the .a library won't be
brought in.
