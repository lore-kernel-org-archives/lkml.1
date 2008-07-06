Return-Path: <linux-kernel-owner+w=401wt.eu-S1754418AbYGFFaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbYGFFaU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 01:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbYGFFaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 01:30:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41337 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751249AbYGFFaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 01:30:05 -0400
Date: Sat, 5 Jul 2008 22:29:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrey Borzenkov <arvidjaar@mail.ru>
cc: David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: All 2.6.26-rcX hang immediately after loading ohci_hcd
In-Reply-To: <200807060859.58971.arvidjaar@mail.ru>
Message-ID: <alpine.LFD.1.10.0807052212200.3016@woody.linux-foundation.org>
References: <200807051108.20183.arvidjaar@mail.ru> <200807051704.56141.david-b@pacbell.net> <alpine.LFD.1.10.0807051724090.3016@woody.linux-foundation.org> <200807060859.58971.arvidjaar@mail.ru>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 6 Jul 2008, Andrey Borzenkov wrote:

> On Sunday 06 July 2008, Linus Torvalds wrote:
> > 
> > But Andrey - if you are on-line and have access to the machine, one thing 
> > to try would be to just do a 
> > 
> > 	git revert e872154921a6b5
> > 
> > in case it really was that particular commit. It seems to revert cleanly 
> > (although I didn't actually check if the result then compiled/worked).
> 
> Looks much better; I am writing this now under 2.6.26-rc8 with above
> commit reverted.

Ok, that's certainly pretty conclusive. Thanks for the great console logs 
making it so straightforward to narrow it down to this (even if it was 
just a wild guess - with your extensive logs it was still fairly 
informed).

Greg, Alan, David - at this point I think the commit should just be 
reverted. We're past -rc9, and unless either of you can see some obvious 
alternate fix (eg some bug in the commit that explains Adrey's problems 
that can just be fixed), I'm not seeing any good alternatives.

I don't know what the hardware details are, but based on the bootup 
messages it seems to be a Toshiba motherboatd with an ALI 1535 chipset - I 
think it's a Toshiba Portege 4000 (which would mean that the OHCI 
controlle is the ALI M5237).

For all I know, that may not be the best possible chipset out there, but 
it's not something extremely odd either. The machine may be a bit long in 
the tooth by now (I think it's a 750MHz PIII in there), but that may also 
explain why most developers wouldn't have seen this issue..

Hmm?

			Linus
