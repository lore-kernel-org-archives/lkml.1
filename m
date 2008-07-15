Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbYGOPJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbYGOPJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 11:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbYGOPJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 11:09:26 -0400
Received: from mail.lang.hm ([64.81.33.126]:36504 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189AbYGOPJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 11:09:26 -0400
Date: Tue, 15 Jul 2008 08:09:17 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Willy Tarreau <w@1wt.eu>, David Miller <davem@davemloft.net>,
       jeff@garzik.org, arjan@infradead.org, akpm@linux-foundation.org,
       dwmw2@infradead.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <alpine.LFD.1.10.0807150747540.3017@woody.linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0807150759020.6370@asgard>
References: <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org> <487C09EB.1050903@garzik.org> <alpine.LFD.1.10.0807141928540.3017@woody.linux-foundation.org> <20080714.194032.117461306.davem@davemloft.net> <alpine.LFD.1.10.0807141947540.3017@woody.linux-foundation.org>
 <20080715045848.GG1369@1wt.eu> <alpine.LFD.1.10.0807150747540.3017@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008, Linus Torvalds wrote:

> On Tue, 15 Jul 2008, Willy Tarreau wrote:
>>>
>>> But once you can load a module, you can load the firmware. You just have
>>> to _remember_ to move it along with the module.
>>
>> In order to transfer it, right now you feed it through a working device.
>> When that device itself requires firmware to work, you will suddenly
>> discover that it becomes harder and harder to get any communication device
>> to work on your target system.
>
> Willy, stop this blathering.
>
> I suspect I will have to just delete this thread unread because it's so
> full of total crap.
>
> This whole "working device" argument is total bullshit.
>
> If the driver was a module before, it needed a module load to become
> working. If you could load the module, you could load the firmware. Thus
> the transfer is non-issue.
>
> And if the driver was built-in, you can still build in the firmware.
>
> And by proof of induction - your "now you feed it through a working
> device" - this also holds for that "a working device" driver. The device
> you load the module off has exactly the same rules: you can build in the
> firmware.
>
> So it didn't get any harder at all. Except for the fact that you need to
> remember to install the firmware.
>
> Which is just about the same thing as asking people to remember to do
> "make modules_install" to get a working system. Yes, if you have a driver
> as a module, you need to install that module for the device to work. Yes,
> it's definitely "harder", but seriously..

has a standard been defined for how to maintain different versions of 
firmware for different versions of drivers yet? driver maintainers do not 
test drivers with all different firmware versions, just the one(s) that 
ship with that kernel version. there are also reports from maintainers 
that some driver/firmware combos do not have full backwards compatability 
so you can't just use the new firmware with the old drivers (causing 
unexpected glitches when switching between kernel versions)

that was one of the things that was identified in the last flamewar that 
was handwaved away but nothing was defined.

yes it's something that other drivers that use request_firmware() have not 
run into problems with, but the maintainers of drivers that have embedded 
the firmware into the driver up until now have stated that they see this 
as a problem.

it's also not that hard to do (it's just someone making a statement of 
what the standard will be that others can agree with), but it needs to be 
done.

the trivial way out is to define a firmware tree per kernel version 
(similar to how modules are handled), but that would offend some people (I 
think it was Alan Cox who was arguing in the last flamewar about how much 
bandwidth it would save to not distribute firmware with each kernel 
version), and it would definantly be a waste of disk space since the 
firmware changes far less frequently then the modules do.

David Lang
