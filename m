Return-Path: <linux-kernel-owner+w=401wt.eu-S1755592AbXJVTMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592AbXJVTMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 15:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbXJVTMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 15:12:00 -0400
Received: from gw.goop.org ([64.81.55.164]:57715 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754316AbXJVTL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 15:11:59 -0400
Message-ID: <471CF5FE.2010105@goop.org>
Date: Mon, 22 Oct 2007 12:11:58 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: dean gaudet <dean@arctic.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Xen-devel <xen-devel@lists.xensource.com>, Morten@suse.de,
       David Chinner <dgc@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?B=F8geskov?= <xen-users@morten.bogeskov.dk>,
       xfs@oss.sgi.com, xfs-masters@oss.sgi.com,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>
Subject: Re: Interaction between Xen and XFS: stray RW mappings
References: <470FA7C3.90404@goop.org> <20071014225618.GN23367404@sgi.com> <4712A254.4090604@goop.org> <200710151415.07248.nickpiggin@yahoo.com.au> <alpine.DEB.0.9999.0710212015430.2320@twinlark.arctic.org> <471C1A61.1010001@goop.org> <p73sl439s7k.fsf@bingen.suse.de> <471CEEB4.9040807@goop.org> <20071022190740.GA1695@one.firstfloor.org>
In-Reply-To: <20071022190740.GA1695@one.firstfloor.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> It's hidden now so it causes any obvious failures any more. Just
> subtle ones which is much worse.
>   

I think anything detected by Xen is still classed as "obscure" ;)

> But why not just disable it?  It's not critical functionality,
> just a optimization that unfortunately turned out to be incorrect.
>
> It could be made correct short term by not freeing the pages until
> vunmap for example.
>   

I think it only ends up holding 64 pages (or is it 64 mappings?), so its
not a horrible use of memory.  Particularly since it responds to memory
pressure callbacks.

>> does his grand unified vmap manager.  I guess a clean workaround would
>> be to add a CONFIG_XFS_LAZY_UNMAP, and do it at the Kconfig level... 
>> I'll cook up a patch.
>>     
>
> This option could only be safely set in architectures that don't
> care about caching attribute aliases or never remap kernel pages
> uncached. That's not x86, powerpc, ia64 at a minimum.
>
> I think the only good short term fix is to turn your ifdef CONFIG_XEN
> into a #if 0
>   

#if 1, but yes, I see your point.

    J
