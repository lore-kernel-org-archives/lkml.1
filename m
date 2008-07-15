Return-Path: <linux-kernel-owner+w=401wt.eu-S1762096AbYGODFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762096AbYGODFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 23:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757215AbYGODFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 23:05:23 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48111 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761586AbYGODFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 23:05:21 -0400
Message-ID: <487C13E9.1020402@garzik.org>
Date: Mon, 14 Jul 2008 23:05:13 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Miller <davem@davemloft.net>, arjan@infradead.org,
       akpm@linux-foundation.org, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
References: <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org> <487C09EB.1050903@garzik.org> <alpine.LFD.1.10.0807141928540.3017@woody.linux-foundation.org> <20080714.194032.117461306.davem@davemloft.net> <alpine.LFD.1.10.0807141947540.3017@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807141947540.3017@woody.linux-foundation.org>
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
> On Mon, 14 Jul 2008, David Miller wrote:
>> Jeff's not against request_firmware() in an of itself.
>>
>> He's against the fact that it's not possible to build a
>> self-contained foo.ko module file any longer, and that
>> would definitely be possible with using request_firmware().
> 
> .. but is it really that big of a deal?
> 
> If it were about not being able to build a self-contained non-modular 
> "vmlinux", I'd be upset too.
> 
> But once you can load a module, you can load the firmware. You just have 
> to _remember_ to move it along with the module.

And failure to "remember" to update associated build image scripts 
silently and without complaint producing a non-working driver.  For 
drivers that, in many cases, have worked for 5 or 10 or more years 
without needing additional files.

So it's not about remembering.  You can't just wish new userland and 
build processes upon the universe.

Heck, you yourself have in the past supported building current kernels 
on older userlands -- this flies in the face of that.


> Besides, it's not even true that foo.ko modules are self-contained. We've 
> for years and years (pretty much since day one) had nesting module models, 
> where in order to load foo.ko you need to load baz.ko first. Yes, the 
> firmware file is named differently, but it _is_ different.

It's not only named differently, it is in a markedly different directory 
hierarchy that isn't automatically picked up alongside *.ko.

But fundamentally, why remove a capability that works, thereby depriving 
system builders of the ability to _choose_ when, if ever, to prefer 
/lib/firmware to built-in firmware?

Let's standardize on a request_firmware() sure, one that does not remove 
that choice.

	Jeff



