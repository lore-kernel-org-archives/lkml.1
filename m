Return-Path: <linux-kernel-owner+w=401wt.eu-S1761328AbYGOCMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761328AbYGOCMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753122AbYGOCMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:12:34 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60348 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189AbYGOCMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:12:34 -0400
Message-ID: <487C0788.7030907@garzik.org>
Date: Mon, 14 Jul 2008 22:12:24 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: david@lang.hm, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from	in-kernel,
 use it in more drivers.
References: <1216077806.27455.85.camel@shinybook.infradead.org>	 <20080714164119.99c33d5b.akpm@linux-foundation.org>	 <20080714165956.7fe2d4ee@infradead.org>	 <alpine.DEB.1.10.0807141704120.14223@asgard.lang.hm> <1216082213.27455.109.camel@shinybook.infradead.org>
In-Reply-To: <1216082213.27455.109.camel@shinybook.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> On Mon, 2008-07-14 at 17:06 -0700, david@lang.hm wrote:
>> On Mon, 14 Jul 2008, Arjan van de Ven wrote:
>>
>>> On Mon, 14 Jul 2008 16:41:19 -0700
>>> Andrew Morton <akpm@linux-foundation.org> wrote:
>>>
>>>> On Mon, 14 Jul 2008 16:23:26 -0700
>>>> David Woodhouse <dwmw2@infradead.org> wrote:
>>>>
>>>>> Linus, please pull from the for-2.6.27 branch of:
>>>>> 	git://git.infradead.org/users/dwmw2/firmware-2.6.git
>>>>> for-2.6.27
>>>> The firmware flamewars seem to have subsided lately.  Is everyone
>>>> happy with this now?
>>>>
>>> this seems to have left the contentious pieces out....
>> almost, the one thing that this could have done would be to offer an 
>> option to bundle the firmware with the module. currently it offers the 
>> option to load the firmware at the same time as the module, not _quite_ 
>> the same thing.
> 
> I see no real point in that. If you have userspace to load modules, then
> you have userspace to load firmware.

You have been provided with several counter-examples here.

Driver disks, initrd, and other such constructs are not necessarily the 
land of happy, fat and healthy userspace that you believe it universally 
to be.  Image build scripts need to be aware that they need to copy 
firmware.  Some already know -- but many, particularly with networking 
-- were such simple one-driver affairs that nobody bothered to script in 
the extra smarts.


> We made 'make modules_install' install the firmware in /lib/firmware for
> you at the same time as it installs the modules, to avoid problems if
> people forgot to run 'make firmware_install'. That really ought to be
> enough.

And it was like pulling teeth, just get that change in, ensuring the 
normal build process will not suddenly produce non-working drivers... 
which it did for several kernel hackers.  As predicted.


> I know Jeff complained that it wasn't, and insisted that he _needed_ to
> be able to scp a single .ko file around which contained both, and the
> world was broken if he could not -- but I disagree with him.

It's simple logic:  existing systems DO copy around modules.  You seem 
to have forgotten an example not so easily derided:  driver disks and 
their build scripts, which are used all over the place.

Particularly in cases, like enterprise distros, where you are updating a 
driver but never touch the main kernel image.

That will continue to be true even when enterprise distros are based off 
of 2.6.27 or later.


> But since I wanted this tree to be uncontentious and obviously the
> correct thing to do, I've dropped the drivers/net changes for now
> anyway.
> 
> It's odd that this request has suddenly come out of the blue when we've
> been using request_firmware() from modules for years already.

Why is it out of the blue to worry about a working driver suddenly 
ceasing to work?

This has nothing to do with request_firmware() itself -- its about 
having the infrastructure in place so that users do not notice the switch.

	Jeff


