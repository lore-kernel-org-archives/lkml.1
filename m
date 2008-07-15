Return-Path: <linux-kernel-owner+w=401wt.eu-S1762889AbYGOU1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762889AbYGOU1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757608AbYGOU04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:26:56 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46030 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763156AbYGOU0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:26:55 -0400
Message-ID: <487D0801.4000206@garzik.org>
Date: Tue, 15 Jul 2008 16:26:41 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Marcel Holtmann <marcel@holtmann.org>,
       David Woodhouse <dwmw2@infradead.org>, Frans Pop <elendil@planet.nl>,
       arjan@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
References: <1216077806.27455.85.camel@shinybook.infradead.org>  <20080714164119.99c33d5b.akpm@linux-foundation.org>  <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org>  <487C0365.5030203@garzik.org>  <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>  <200807151757.10626.elendil@planet.nl>  <1216149637.27242.65.camel@violet.holtmann.net>  <alpine.LFD.1.10.0807151223290.3351@woody.linux-foundation.org>  <1216150616.27455.377.camel@shinybook.infradead.org>  <alpine.LFD.1.10.0807151244320.3351@woody.linux-foundation.org> <1216151640.27242.90.camel@violet.holtmann.net> <alpine.LFD.1.10.0807151301130.2867@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807151301130.2867@woody.linux-foundation.org>
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
> On Tue, 15 Jul 2008, Marcel Holtmann wrote:
>> you don't have to. We extend udev once and then it will always work.
> 
> Umm. The thing is, people running new kernels with old user land is not 
> just supposed to work, it's _really_ supposed to work.
> 
> It's what I do. Something that breaks that has to have damn good reasons 
> to break it.
> 
> So I do not disagree with Jeff on that point _at_all_. I'm in violent 
> agreement with Jeff on the fact that we should not require system updates 
> for the kernel to do the right thing.
> 
> The thing I disagree with Jeff on is that he then seems to turn that into 
> something very negative ("let's not separate the firmware at all").

How many times do I have to say you misunderstand?

I'm happy with separating the firmware at the source code level.  I 
never objected to that.

All I want is the _option_ to compile firmware into a module.  We are 
talking about compiled output, here.

That _option_ has the desireable properties of

* working on older userland, even with DavidW's tg3 and scsi patches

* retaining an option several kernel hackers and users find useful

* permitting use of 2.6.27 without _immediately_ having to fix stuff


> And I'd much rather just fix it. And that means that if people can point 
> to udevd's that get confused - or lack of udevd's entirely - both of which 
> sound very likely to me, then we should have a graceful fallback position.
> 
> And just supporting the notion of loading the firmware directly sounds 
> like an obvious such case. It may not be the _only_ solution, for example, 
> which is why I'd actually like to see people point to the _actual_ 
> reported problems.
> 
> IOW, the problems shouldn't a "don't do this" thing. They should be a "ok, 
> that problem happened, we can solve it by doing X".

Stop using strawmen, please.

I never said "don't do that".  Ever.

I said "when you do that, don't remove ability to compile firmware into 
the driver."

And as has been stated repeatedly, the compiling firmware into the 
driver clearly DOES NOT exclude the more flexible, load-from-userland 
request_firmware() model.



To be extremely concrete, firmware-in-module is

	* add Kconfig option (kernel-wide or per-driver, dunno) asking
	  "build firmware into drivers, as before?"

	* tweak build process to build firmware into foo.ko output,
	  probably in a specially marked ELF section

	* get request_firmware() to automatically notice that the
	  MODULE_FIRMWARE() was built into this driver, and to
	  look at the special ELF section for its data

See?  That is not a "don't do that."  That has never been "don't do that."

That is the one major request here, one that enables us to avoid all 
those potential breakages I've been listing, and the many more breakages 
of which I'm unaware.  It enables use of older userlands.

And yes, it enables "weirdos" like me to continue building the firmware 
into the driver, because it has a proven track record of high 
reliability and simplicity.

All without stomping on the flexibility of request_firmware().

	Jeff



