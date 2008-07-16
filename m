Return-Path: <linux-kernel-owner+w=401wt.eu-S1759203AbYGPWFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759203AbYGPWFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 18:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757292AbYGPWFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 18:05:06 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:49983 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945AbYGPWFD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 18:05:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=tmkFCoEMaBLUeJtjKqM9oyHJKenkvDl7FUOqBxsg3x3taDYlylIFnDiL/s/Cw2GeCz
         jJLMH6eBE4+mCYBS+SaTQVOyxg9pWdKm8FTvSl08ZEsQ2g4HgEodvEveObhB92XYVfyt
         Q7gJvtFI5lyjJzEHE9Q4xd6VeDRv/D9IG4PgE=
Date: Thu, 17 Jul 2008 00:05:03 +0200
From: Diego Calleja <diegocalleja@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Marcel Holtmann <marcel@holtmann.org>,
       David Woodhouse <dwmw2@infradead.org>, Frans Pop <elendil@planet.nl>,
       arjan@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
 in-kernel, use it in more drivers.
Message-ID: <20080717000503.44b3576d@diego-desktop>
In-Reply-To: <487D0801.4000206@garzik.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	<20080714164119.99c33d5b.akpm@linux-foundation.org>
	<20080714165956.7fe2d4ee@infradead.org>
	<487C0365.5030203@garzik.org>
	<487C0365.5030203@garzik.org>
	<alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
	<200807151757.10626.elendil@planet.nl>
	<1216149637.27242.65.camel@violet.holtmann.net>
	<alpine.LFD.1.10.0807151223290.3351@woody.linux-foundation.org>
	<1216150616.27455.377.camel@shinybook.infradead.org>
	<alpine.LFD.1.10.0807151244320.3351@woody.linux-foundation.org>
	<1216151640.27242.90.camel@violet.holtmann.net>
	<alpine.LFD.1.10.0807151301130.2867@woody.linux-foundation.org>
	<487D0801.4000206@garzik.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Tue, 15 Jul 2008 16:26:41 -0400, Jeff Garzik <jeff@garzik.org> escribió:

> And yes, it enables "weirdos" like me to continue building the firmware 
> into the driver, because it has a proven track record of high 
> reliability and simplicity.

I'm one of those "weirdos", and I'd like to explain from my user-POV (a user
who usually compiles and tests -rcs) why I prefer firmware-in-module I don't
find it "weird".

I use modules as much as I can. Apparently many people here uses non-modular
.configs. Me, I learnt lot of time ago that we live in a hotplugged world
were you can't predict what hardware you are going to need to plug, and you
don't want to tell your girlfriend that you need to compile a "kernel module"
because she brought a USB memory stick and you didn't compiled the support
when you compiled your kernel. And I don't like doing "lspci" every time I
want to know what network card I have in a box. So I compile everything as
a module (except the support for all sata/ide controllers and ext3, to
avoid the nightmares of initrds) and I let udev do all the job. I only use
external firmware when it's strictly needed for legal reasons.

Yes, just like I can do "make modules_install", I can do "make
firmware_install". It's not hard - just an extra command. But it's an
extra one. And I'm lazy to the point that I'm _not_ willing to type
that extra command. You could install the firmware automatically with
"make modules_install". Still, I'd need to cleanup frequently
/lib/firmware/<version> because of all the crap (and MB) that old
-rcs and -next's versions will leave there.

Those are _extra_ steps. Steps that force me to learn things that
I didn't need to know before. I didn't even know if my network
card had firmware or not. I never cared, and I don't want to start
caring about it now.

With firmware-in-module, I can switch a simple config option that will
get me back to my ignorance of firmware related things. And Jeff will
be my hero of the month for bringing back the simplicity of the old
times, while the rest of the people that want to force me to learn about
firmware (iow, the people who thinks that firmware-in-module is worthless)
remember me of the microkernel people, who could write books and give
speeches in universities about how insanely great is to have fulfilled
one of the most important problems in the story of CS - separating
firmware from the driver code. Despite of the fact that it does not
bring ANYTHING new for me, excepting added complexity.

I'll continue using external firmware only when for legal reasons it
can't be redistributed, of course, but fortunately for me that's an
exception on my hardware devices, not the rule.
