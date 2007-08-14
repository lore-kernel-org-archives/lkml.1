Return-Path: <linux-kernel-owner+w=401wt.eu-S934434AbXHNWsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934434AbXHNWsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 18:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbXHNWsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 18:48:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33192 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199AbXHNWsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 18:48:37 -0400
Date: Wed, 15 Aug 2007 00:48:35 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>, Hajime Inoue <hinoue@ccsl.carleton.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: System call interposition/unprotecting the table
Message-ID: <20070814224835.GJ23308@one.firstfloor.org>
References: <20070813180535.vo36rcevi80s0c4c@www.ccsl.carleton.ca> <20070814000956.7c8929dd@the-village.bc.nu> <46C1E5F5.9050702@ccsl.carleton.ca> <p73zm0tnbf8.fsf@bingen.suse.de> <20070814234206.76121d02@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070814234206.76121d02@the-village.bc.nu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Then you fix the specific case and the game continues.

If they intercept netdev->hard_start_xmit there is nothing
to fix. Or inode->i_ops or any other virtual method pointer
that is called often..

Putting i_ops into const memory doesn't help either -- they
can just copy them and use their own and replace the pointer
in any accessed inode.

It's also not that doing this is rocket science. Anybody
barely skilled in computer architecture should be able
to figure this out.

Ok the only thing that could help is IA64/PPC64 style smart pointer
checking that could prevent foreign code from being 
executed, but you won't get that on x86 or most other
architectures any time soon.

And that would also only work if you disable module loading
or implement a likely impractical/incompatible
with free software code signing scheme
(and Vista has just shown that these don't work anyways) 

> > In general the .data protection is only considered a debugging
> > feature. I don't know why Fedora enables it in their production
> > kernels.
> 
> That would be because we think you are wrong 8)

Well, it might at best buy you a few weeks/months in
terms of the exploit arms race, but thrash your user's TLBs
forever.

-Andi

