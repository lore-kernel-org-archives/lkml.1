Return-Path: <linux-kernel-owner+w=401wt.eu-S965257AbXBZPzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965257AbXBZPzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 10:55:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbXBZPzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 10:55:24 -0500
Received: from gate.crashing.org ([63.228.1.57]:48688 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965257AbXBZPzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 10:55:16 -0500
Subject: Re: Make sure we populate the initroot filesystem late enough
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       john stultz <johnstul@us.ibm.com>
In-Reply-To: <1172462466.3971.46.camel@shinybook.infradead.org>
References: <200612112059.kBBKx1j7022473@hera.kernel.org>
	 <1172448057.3971.9.camel@shinybook.infradead.org>
	 <Pine.LNX.4.64.0702251614420.12485@woody.linux-foundation.org>
	 <1172452660.3971.33.camel@shinybook.infradead.org>
	 <Pine.LNX.4.64.0702251940500.12485@woody.linux-foundation.org>
	 <1172462466.3971.46.camel@shinybook.infradead.org>
Content-Type: text/plain
Date: Mon, 26 Feb 2007 16:53:27 +0100
Message-Id: <1172505207.11949.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-02-25 at 23:01 -0500, David Woodhouse wrote:

> Yeah, I did that before giving up on it for the day and going in search
> of dinner. It changes the failure mode to a BUG() in
> cache_free_debugcheck(), at line 2876 of mm/slab.c
> 
> It smells like the pages weren't actually reserved in the first place
> and we were blithely allocating them. The only problem with that theory
> is that the initrd doesn't seem to be getting corrupted -- and if we
> were handing out its pages like that then surely _something_ would have
> scribbled on it before we tried to read it.
> 
> When I head back in tomorrow morning I'll instrument free_initrd_mem()
> to check that the PageReserved bit was actually set on each page, before
> clearing it. And I'll make the page allocation routines check whether
> they're giving out pages between initrd_start and initrd_end, etc.

And check that we didn't end up stupidly having the initrd share a page
with something else ... (like not aligned end or such thingy).

Ben.


