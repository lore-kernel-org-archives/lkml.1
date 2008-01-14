Return-Path: <linux-kernel-owner+w=401wt.eu-S1752158AbYANN3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbYANN3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 08:29:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750808AbYANN3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 08:29:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbYANN3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 08:29:12 -0500
Message-ID: <478B5D0D.7060808@redhat.com>
Date: Mon, 14 Jan 2008 08:01:01 -0500
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <greg@kroah.com>,
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
References: <alpine.LFD.1.00.0801111224090.3148@woody.linux-foundation.org>	<alpine.LFD.1.00.0801111311170.3148@woody.linux-foundation.org>	<20080111211753.GR18741@parisc-linux.org>	<alpine.LFD.1.00.0801111326120.3148@woody.linux-foundation.org>	<20080111213803.GS18741@parisc-linux.org>	<20080111235856.GA16079@jurassic.park.msu.ru>	<20080112002638.GA18710@kroah.com>	<20080112144030.GA19279@jurassic.park.msu.ru>	<20080112094557.71f5382a@laptopd505.fenrus.org>	<20080112214911.GA20102@jurassic.park.msu.ru>	<20080112150120.05f93768@laptopd505.fenrus.org>	<47895767.3090503@redhat.com>	<20080112164006.6f6f7bc2@laptopd505.fenrus.org>	<47896B3B.2000108@redhat.com>	<20080112204248.29abb1dd@laptopd505.fenrus.org>	<478A075F.7010503@redhat.com>	<20080113090311.0a9a1db5@laptopd505.fenrus.org>	<478A8268.6020107@redhat.com>	<20080114005434.48340f84@lxorguk.ukuu.org.uk>	<20080113173331.617ac935@laptopd505.fenrus.org>	<478AD713.8060204@redhat.com> <20080113210501.4584e4d2@laptopd505.fenrus.o!
 rg>
In-Reply-To: <20080113210501.4584e4d2@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Sun, 13 Jan 2008 22:29:23 -0500
> Tony Camuso <tcamuso@redhat.com> wrote:
> 
>> . There is no need to provide different PCI config access
>>    mechanisms at device granularity, since the PCI config access
>>    mechanism between the CPU and the Northbridge is opaque to
>>    the devices. PCI config mechanisms only need to differ at
>>    the Northbridge level.
> 
> This ignores the "lets make it not matter for the 99% of the users" case.

I don't understand. If we're going to differentiate MMCONFIG from some other
access mechanism, it only needs to be done at the Northbridge level. Devices
are electrically ignorant of the protocol used between CPU and Northbridge
to get the Northbridge to assert config cycles on the bus.

>> . If the system is capable of conf1, then PCI config access
>>    at offsets < 256 should be confined to conf1. This solution
>>    is most effective for existing and legacy systems.
> 
> not "conf1" but "what the platform thinks is the best method for < 256".
> 
> We have this nice abstraction for the platform to select the best method... we should use it.
> 
Agreed.

So we have Loic and Ivan's patch limiting MMCONFIG accesses to
offsets >= 256.

And we have Matthew's patch that abstracts the method for config
accesses to offsets < 256.

I beleive Matthew has already tested these patches for functionality
on x86. All that's needed is to test for regressions on other arches.

Is there any interest in providing the following?

1. The ability to use MMCONFIG for all accesses on systems that have
    no problems with MMCONFIG.

2. For systems using both PCI and PCI express, testing each bus
    for MMCONFIG compliance, to determine whether MMCONFIG can be
    used for all config accesses or whether the bus must be limited
    all to the method abstracted for offsets < 256.

Or does that introduce unnecessary complications?


