Return-Path: <linux-kernel-owner+w=401wt.eu-S1755754AbYGOHWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754AbYGOHWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 03:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753398AbYGOHWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 03:22:07 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60181 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574AbYGOHWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 03:22:05 -0400
Message-ID: <487C500F.8000109@garzik.org>
Date: Tue, 15 Jul 2008 03:21:51 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
References: <1216077806.27455.85.camel@shinybook.infradead.org> <20080714164119.99c33d5b.akpm@linux-foundation.org> <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org> <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org> <487C09EB.1050903@garzik.org> <alpine.LFD.1.10.0807141928540.3017@woody.linux-foundation.org> <487C1648.5070409@garzik.org> <alpine.LFD.1.10.0807142027140.3017@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807142027140.3017@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 14 Jul 2008, Jeff Garzik wrote:
>> Do you really think embedded system and micro distro authors are in 100%
>> agreement that /lib/firmware is best for their situation?  Really?
> 
> Umm. Why are you bringing up these total red herrings?
> 
> Those embedded systems can just build everything into one image, and are 
> much better off using no modules at all.

Oh come on, embedded systems use modules all the time, and surely you 
know that.  My router running OpenWRT says

	root@gw:~# ipkg list | grep -c kmod
	91

Therefore, simple kernel replacement can create a regression by doing

1) build 2.6.26 kernel, including all associated kernel module packages 
("kmod-*")
2) install new kernel and associated kmod packages
3) watch system work as expected
4) build 2.6.27 kernel, including all associated kernel module packages
5) install new kernel and associated kmod packages
6) watch system fail

Why fail?  The package file lists for kmod-* ipkg's are unaware of any 
firmware needs newly added in 2.6.27.

So the driver gets packaged, but ipkg build process is completely 
unaware of the additional firmware requirement until a manifest is 
updated.  The normal build process appears to succeed -- yet at next 
boot you see that it failed.

Similar breakage for driver disks.

Similar breakage for older versions of mainstream distros (won't get 
copied into initrd, with obvious results).


> But how about instead of complaining, help add the infrastructure then, so 
> that you can insert those firmware things into modules and still use just 
> one single interface? 
> 
> Move _forward_, not backwards.

Does that mean you agree it's a regression?  :)  Sure, I'd be happy to 
help fix the damage.

I am still surprised this was merged at all in its state, and am a bit 
disappointed.  This one

* removed choice, by removing ability to build firmware into modules

* forced a flag day build process change upon all distros/builders who 
switch to >= 2.6.27.  no build script updates == non-working drivers.

* the legal subtext of these changes was not mentioned at all

Generally, we don't do that.  Generally, we give distros the ability to 
choose between old-way and new-way during a time of transition. 
Generally we make it easy for newer kernels to work on existing systems, 
maximizing the [test] audience.

	Jeff



