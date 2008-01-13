Return-Path: <linux-kernel-owner+w=401wt.eu-S1752164AbYAMMoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbYAMMoN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 07:44:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbYAMMoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 07:44:01 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbYAMMoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 07:44:00 -0500
Message-ID: <478A075F.7010503@redhat.com>
Date: Sun, 13 Jan 2008 07:43:11 -0500
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <greg@kroah.com>,
       Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Loic Prylli <loic@myri.com>,
       Prarit Bhargava <prarit@redhat.com>,
       "Chumbalkar, Nagananda" <Nagananda.Chumbalkar@hp.com>,
       "Schoeller, Patrick (Linux - Houston, TX)" <Patrick.Schoeller@hp.com>,
       Bhavana Nagendra <bnagendr@redhat.com>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
References: <alpine.LFD.1.00.0801111224090.3148@woody.linux-foundation.org>	<20080111204228.GP18741@parisc-linux.org>	<alpine.LFD.1.00.0801111311170.3148@woody.linux-foundation.org>	<20080111211753.GR18741@parisc-linux.org>	<alpine.LFD.1.00.0801111326120.3148@woody.linux-foundation.org>	<20080111213803.GS18741@parisc-linux.org>	<20080111235856.GA16079@jurassic.park.msu.ru>	<20080112002638.GA18710@kroah.com>	<20080112144030.GA19279@jurassic.park.msu.ru>	<20080112094557.71f5382a@laptopd505.fenrus.org>	<20080112214911.GA20102@jurassic.park.msu.ru>	<20080112150120.05f93768@laptopd505.fenrus.org>	<47895767.3090503@redhat.com>	<20080112164006.6f6f7bc2@laptopd505.fenrus.org>	<47896B3B.2000108@redhat.com> <20080112204248.29abb1dd@laptopd505.fenrus.org>
In-Reply-To: <20080112204248.29abb1dd@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Sat, 12 Jan 2008 20:36:59 -0500
> Tony Camuso <tcamuso@redhat.com> wrote:
> 
>
> Just about NOBODY has devices that need the extended config space. At all.

The PCI express spec requires the platform to provide access to this space
for express-compliance. More devices will be using this space as express
becomes the dominant IO bus technology.

>> As far as the device is concerned, after the Northbridge translates
>> the config access into PCI bus cycles, the device has no idea what
>> mechanism drove the Northbridge to the translation.
> 
> Wanne bet there'll be devices that screw this up? THere's devices that even screwed
> up the 64-256 region after all.
> 

There may have been devices that incorrectly applied the PCI spec to
various fields in the header, I'll grant you that.

However, there is no way a device can determine electrically whether the
Northbridge received Port IO or MMCONFIG cycles. This is between the CPU
and the Northbridge and is utterly opaque to the devices on the bus.

>> The patch I devised concerned itself with Northbridges and separated
>> MMCONFIG-compliant buses from those that could not handle MMCONFIG.
> 
> THis kind of patchup has been going on for the better part of a year (well 2 years)
> by now and it's STILL NOT ENOUGH, as you can see by the more patchups that have
> been proposed as "alternative" to my approach.
> 

Which is why Loic's proposal and Ivan's implementation of it is so elegant.
It solves all these problems in one sweep, and eliminates the code rendered
cruft by Ivan's patch. A two-fer, by my reckoning.

>> In other words, for x86, I don't think we need to worry about Port
>> IO config access ever going away at all.
> 
> You're wrong there. Sad to say, but you're wrong there.
> 

The PCI spec provides for conf1 as an architected solution. It's not
going away, and especially not in x86 land where Port IO is built-in
to the CPU.



