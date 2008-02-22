Return-Path: <linux-kernel-owner+w=401wt.eu-S933342AbYBVM7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933342AbYBVM7x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 07:59:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754598AbYBVM7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 07:59:45 -0500
Received: from one.firstfloor.org ([213.235.205.2]:60258 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbYBVM7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 07:59:45 -0500
Date: Fri, 22 Feb 2008 14:00:02 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       akpm@osdl.org, torvalds@osdl.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] Document huge memory/cache overhead of memory controller in Kconfig
Message-ID: <20080222130002.GA22369@one.firstfloor.org>
References: <20080220122338.GA4352@basil.nowhere.org> <47BC2275.4060900@linux.vnet.ibm.com> <200802211535.38932.nickpiggin@yahoo.com.au> <47BD06C2.5030602@linux.vnet.ibm.com> <47BD55F6.5030203@firstfloor.org> <47BE527D.2070109@linux.vnet.ibm.com> <47BE9B11.7090809@firstfloor.org> <47BEBCB7.8000607@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BEBCB7.8000607@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 05:44:47PM +0530, Balbir Singh wrote:
> 
> My concern with all the points you mentioned is that this solution might need to
> change again,

No why would it need to change again?

> depending on the factors you've mentioned. vmalloc() is good and
> straightforward, but it has these dependencies which could call for another
> rewrite of the code.

The hotplug change would not need a rewrite of anything, just
some additional code in the SRAT parser to increase __VMALLOC_RESERVE for
each hotplug region. It's likely <= 3 additional lines.

> 
> > 
> >>>> if we decided to use vmalloc space, we would need 64
> >>>> MB of vmalloc'ed memory
> >>> Yes and if you increase mem_map you need exactly the same space
> >>> in lowmem too. So increasing the vmalloc reservation for this is
> >>> equivalent. Just make sure you use highmem backed vmalloc.
> >>>
> >> I see two problems with using vmalloc. One, the reservation needs to be done
> >> across architectures. 
> > 
> > Only on 32bit. Ok hacking it into all 32bit architectures might be
> > difficult, but I assume it would be ok to rely on the architecture
> > maintainers for that and only enable it on some selected architectures
> > using Kconfig for now.
> > 
> 
> Yes, but that's not such a good idea

Waiting for the maintainers? Why not? 

I assume the memory controller would be primarily used on larger
systems anyways and except for i386 these should be mostly 64bit
these days anyways.

> > On 64bit vmalloc should be by default large enough so it could
> > be enabled for all 64bit architectures.
> > 
> >> Two, a big vmalloc chunk is not node aware, 
> > 
> > vmalloc_node()
> > 
> 
> vmalloc_node() would need to work much the same way as mem_map does. I am

would? It already is implemented and works just fine AFAIK. 

I don't understand the rest of your point.

-Andi
