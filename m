Return-Path: <linux-kernel-owner+w=401wt.eu-S1758441AbYGFQk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758441AbYGFQk1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 12:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757143AbYGFQkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 12:40:15 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2623 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756686AbYGFQkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 12:40:14 -0400
Date: Sun, 6 Jul 2008 12:40:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrey Borzenkov <arvidjaar@mail.ru>, David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: All 2.6.26-rcX hang immediately after loading ohci_hcd
In-Reply-To: <alpine.LFD.1.10.0807052212200.3016@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0807061237200.29191-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jul 2008, Linus Torvalds wrote:

> Ok, that's certainly pretty conclusive. Thanks for the great console logs 
> making it so straightforward to narrow it down to this (even if it was 
> just a wild guess - with your extensive logs it was still fairly 
> informed).
> 
> Greg, Alan, David - at this point I think the commit should just be 
> reverted. We're past -rc9, and unless either of you can see some obvious 
> alternate fix (eg some bug in the commit that explains Adrey's problems 
> that can just be fixed), I'm not seeing any good alternatives.
> 
> I don't know what the hardware details are, but based on the bootup 
> messages it seems to be a Toshiba motherboatd with an ALI 1535 chipset - I 
> think it's a Toshiba Portege 4000 (which would mean that the OHCI 
> controlle is the ALI M5237).
> 
> For all I know, that may not be the best possible chipset out there, but 
> it's not something extremely odd either. The machine may be a bit long in 
> the tooth by now (I think it's a 750MHz PIII in there), but that may also 
> explain why most developers wouldn't have seen this issue..

There doesn't seem to be much choice.

As I recall, the consequences of leaving the old code were that 
sometimes a suspend or a resume wouldn't work as expected.  That's 
better than hanging the entire system -- but on the other hand, it 
would affect more people.

Andrey, when you have time I'd like to do some more debugging to find 
out exactly what's going wrong.

Alan Stern

