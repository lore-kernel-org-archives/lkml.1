Return-Path: <linux-kernel-owner+w=401wt.eu-S1758686AbYDSUPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686AbYDSUPv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 16:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755446AbYDSUPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 16:15:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45175 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755205AbYDSUPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 16:15:39 -0400
Date: Sat, 19 Apr 2008 13:14:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: [GIT PATCH] SCSI updates for 2.6.25
In-Reply-To: <1208626496.3280.40.camel@localhost.localdomain>
Message-ID: <alpine.LFD.1.10.0804191305360.2779@woody.linux-foundation.org>
References: <1208540517.3063.18.camel@localhost.localdomain>  <20080419151934.GA17089@elte.hu>  <1208620484.3280.23.camel@localhost.localdomain>  <20080419170530.GD1595@cs181133002.pp.htv.fi> <1208626496.3280.40.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 19 Apr 2008, James Bottomley wrote:
> 
> Well, we already had this argument on linux-scsi when the interface was
> first proposed:  Apart from select being very nasty and should only be
> sparingly used

I'm still not understanding people who say that.

Yes, select has problems, in that it doesn't guarantee dependencies.

But that said, select is a whole lot better than having simply *different* 
behaviour (or build errors) depending on totally unrelated config options.

So people: stop this total *idiocy* with "select is bad". It's not. The 
lack of select is *much* worse.

If you want LIBSAS to have two different modes, how about just making that 
explicit in the configuration, ie using something like

	config LIBSAS_SET_ADDR
		bool "Provide user-settable SAS address" 
		depends on SCSI_SAS_LIBSAS
		help
		  This allows a runtime "firmware" loader that loads the 
		  SAS address

	config LIBSAS_SET_ADDR_FWLOAD
		tristate
		depends on SCSI_SAS_LIBSAS && LIBSAS_SET_ADDR
		default y
		select FW_LOADER

and now you have the explicit option to turn it on or off - and FW_LOADER 
is loaded appropriately.

> Even if I changed it to select, a user could still defeat it by making
> CONFIG_SCSI_AIC94XX=y (because now the initialisation is before early
> boot userland, so the request always fails).

Not true. That's why we have initrd and ramdisks etc.

Not that any normal people will ever care about LIBSAS, but anyway.. The 
ones that do care about these kinds of things are probably happy to have 
special initrd images.

		Linus
