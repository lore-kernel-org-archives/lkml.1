Return-Path: <linux-kernel-owner+w=401wt.eu-S1755254AbYGOVka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbYGOVka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbYGOVkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:40:23 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47425 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472AbYGOVkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:40:22 -0400
Message-ID: <487D1925.50008@garzik.org>
Date: Tue, 15 Jul 2008 17:39:49 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Theodore Tso <tytso@mit.edu>, david@lang.hm,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
References: <alpine.LFD.1.10.0807141903260.3017@woody.linux-foundation.org> <487C585C.2060002@garzik.org> <alpine.LFD.1.10.0807150803580.3017@woody.linux-foundation.org> <487CD7FE.9010209@garzik.org> <alpine.LFD.1.10.0807151008450.3017@woody.linux-foundation.org> <487CDEC0.3090004@garzik.org> <alpine.LFD.1.10.0807151041080.3017@woody.linux-foundation.org> <487CEA73.9000408@garzik.org> <alpine.LFD.1.10.0807151124510.3017@woody.linux-foundation.org> <487CF01E.6000208@garzik.org> <20080715185801.GH8185@mit.edu> <487CF70C.1030309@garzik.org> <alpine.LFD.1.10.0807151218460.3351@woody.linux-foundation.org> <487D1327.7090805@garzik.org> <alpine.LFD.1.10.0807151420550.2867@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807151420550.2867@woody.linux-foundation.org>
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
> On Tue, 15 Jul 2008, Jeff Garzik wrote:
>> Kernel 2.6.26.  Older userland w/ initrd requirement, plus module w/
>> compiled-in firmware.
>>
>> Simply dropping 2.6.27 into that situation will produce an unbootable system,
>> since the firmware would not get copied into the initrd.
> 
> Umm. Neither would the module.

Sure it would.

Normal kernel build with modules, older userland (with older initrd).

'make modules_install && make install' will
	* install modules in /lib
	* install firmware in /lib	[2.6.27 only]
	* install kernel
	* update grub
	* rebuild initrd

Do this, under both 2.6.26 and 2.6.27.

2.6.26 will put a working driver into initrd.

2.6.27 will put a dead driver into initrd (because no firmware got 
copied into initrd image).


> Or are you rebuilding the module into the initrd? If so, why didn't you do 
> the firmware too and my "load directly from file" idea which is pretty 
> simple? IOW, what's the fundamnetal problem here?

The firmware doesn't get copied into the initrd, because it is an 
automated process (older mkinitrd) that is unaware of the need to copy 
the firmware into the initrd.

Do the same build process on 2.6.26 and 2.6.27, and you WILL get 
different results on older userlands, for the same simple reason:  the 
scripts do not know to copy the firmware when they copy the kernel module.


> But hey, if you _do_ the "link it together", go ahead. I don't see why 

Great!  I will :)


> it's so magically superior, but I wanted it for the compiled-in driver 
> case, so it's not fundamentally different from that either.

It's not magically superior, just a necessary tool that helps avoid a 
whole class of regressions, keeps us working on older userland, etc., etc.

	Jeff



