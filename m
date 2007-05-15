Return-Path: <linux-kernel-owner+w=401wt.eu-S1760097AbXEOPed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760097AbXEOPed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 11:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756170AbXEOPe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 11:34:26 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39806 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754060AbXEOPe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 11:34:26 -0400
Date: Tue, 15 May 2007 08:33:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tjenarvi Tjenarvi <tjenarvi@yahoo.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: no DRQ after issuing MULTWRITE_EXT AND PCI: Bus #0b (-#0e) is
 hidden behind transparent bridge #0a (-#0a) (try 'pci=assign-busses')
In-Reply-To: <466481.34138.qm@web58810.mail.re1.yahoo.com>
Message-ID: <alpine.LFD.0.98.0705150819140.16401@woody.linux-foundation.org>
References: <466481.34138.qm@web58810.mail.re1.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 May 2007, Tjenarvi Tjenarvi wrote:
> 
> "PCI: Bus #0b (-#0e) is hidden behind transparent bridge #0a (-#0a) (try 
> 'pci=assign-busses') Please report the result to linux-kernel to fix 
> this permanently"

This one is most likely totally harmless, but you might try to see if that 
"pci=assign-busses" makes any difference. Do a "lspci" with and without 
that, and send them to me and the kernel mailing list.

But I assume that everything still *works*? The thing about a transparent 
bridge is that it doesn't act as a normal PCI bridge - it just passes 
everything through, so anything that is "hidden" behind one really is 
quite visible, even if the setup of the bridging registers is odd.

So the reason for that report is most likely just that the BIOS set up the 
bridge bus numbers in a really odd (and technically incorrect) way - but 
it probably all still works perfectly fine. You can see all the devices in 
the machine, right?

We migth have to just change the error message - the case is interesting, 
but the "to fix this permanently" part is misleading. There's probably 
nothing to fix (except for a firmware update, and I doubt the BIOS will 
really be fixed either - BIOS vendors wouldn't care, as long as things 
work).

> I just a few days ago found this bug. In, 
> http://lkml.org/lkml/2007/2/28/297 got the same problem, and tells that 
> had to pass combined_mode=libata as kernel option, otherwise DMA does 
> not work and the hard disk is terribly slow.  My DMA also can't work 
> properly on my /dev/hda and my /dev/cdrom,furthermore, now, my dmesg is 
> full of these messages:
> 
> hda: status timeout: status=0xd0 { Busy }
> ide: failed opcode was: unknown
> hda: no DRQ after issuing MULTWRITE_EXT
> ide0: reset: success
> 
> My opinion is that PCI bus bug and DMA problem and then the 
> MULTWRITE_EXT error might be somehow related

I suspect they are unrelated, although they certainly *could* be related 
(where "related" is possibly something indirect like "the firmware set up 
something _else_ strangely too").

> I have tried Slackware default kernel 2.4.33.3, and the dmesg is a little different with 2.6.x.
> 
> hda: no DRQ after issuing WRITE

Ok, so the exact same thing basically happens with a 2.4.x kernel, the 
message is just different. So this is not a new issue, it's really 
somethgn about your machine.

> Someone got this link to patch this bug, 
> http://www.spinics.net/lists/linux-ide/msg04810.html.  Then I post 
> another thread in 
> http://www.linuxquestions.org/questions/showthread.php?t=551630

Have you tried it, and does that patch actually fix things for you?

That patch has not been merged, possibly because it got forgotten, but 
possibly because it had other problems. So if you can test it and send the 
results back to Tejun and Jeff (both Cc'd), please do.

		Linus
