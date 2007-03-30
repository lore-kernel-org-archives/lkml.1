Return-Path: <linux-kernel-owner+w=401wt.eu-S1751735AbXC3NxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbXC3NxZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 09:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbXC3NxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 09:53:25 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59771 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751388AbXC3NxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 09:53:23 -0400
Date: Fri, 30 Mar 2007 15:56:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Aubrey Li" <aubreylee@gmail.com>
Cc: "David Howells" <dhowells@redhat.com>, vapier.adi@gmail.com,
       jie.zhang@analog.com, bryan.wu@analog.com,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nommu arch dont zero the anonymous mapping by adding
 UNINITIALIZE flag
Message-ID: <20070330155635.6a6c55d2@the-village.bc.nu>
In-Reply-To: <6d6a94c50703300644y28e51f47h19182f550c18c40d@mail.gmail.com>
References: <1175226172.15391.66.camel@roc-desktop>
	<10785.1175247540@redhat.com>
	<6d6a94c50703300334w6b4787f3p144715de5166d7bc@mail.gmail.com>
	<15938.1175253862@redhat.com>
	<6d6a94c50703300644y28e51f47h19182f550c18c40d@mail.gmail.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I can't find mmap must give zeroed memory in the mmap manual.
> Is there any reason relying on anon mmap() giving zerod memory?

Its how all Unix/Linux like systems behave. You have to clear the memory
to something to deal with security on any kind of real system, and zero
is a good a value as any

> > Personally, I'd prefer to maintain compatibility with MMU-mode wherever
> > possible, but I'm happy with overrides like the MAP_UNINITIALISED flag
> > suggested.
> >
> Not necessary IMHO.

mmap() for anonymous memory pools should not normally be a hot path,
because the C library malloc is supposed to show some brains. If you need
special behaviour (eg for performance hacks) then create yourself
a /dev/zero like device which just maps uncleared pages. Its not much
code and it keeps special cases out of the core kernel.
