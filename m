Return-Path: <linux-kernel-owner+w=401wt.eu-S1753151AbYKHGGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbYKHGGk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 01:06:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbYKHGGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 01:06:30 -0500
Received: from outbound-mail-26.bluehost.com ([69.89.17.191]:53628 "HELO
	outbound-mail-26.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750971AbYKHGG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 01:06:29 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=uniscape.net;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=XxyNu1iIJXvGr4MahJGWlRC+N7wrQvGDaa7DgmbA43dlJ8d9vZ9h8WS/rXDAEQUBac9O+NoDNGgjY0Xul65gDONcUALf3uIABbe6aq11p5IzJokfZNBqeeq/GoMXQ4ZQ;
Message-ID: <49152C35.3040501@uniscape.net>
Date: Sat, 08 Nov 2008 14:05:41 +0800
From: Yu Zhao <yu.zhao@uniscape.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: "Zhao, Yu" <yu.zhao@intel.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "achiang@hp.com" <achiang@hp.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "matthew@wil.cx" <matthew@wil.cx>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 16/16 v6] PCI: document the new PCI boot parameters
References: <20081107025032.GA12824@kroah.com> <4913B8A5.5010806@intel.com> <20081107061603.GC3860@kroah.com> <4913F34A.8020805@intel.com> <20081107080222.GA6284@kroah.com> <4913F97E.7030408@intel.com> <20081107082432.GA6601@kroah.com> <4913FDE3.8050804@intel.com> <20081107185325.GE2320@kroah.com> <49151CED.8060507@uniscape.net> <20081108052519.GA11067@kroah.com>
In-Reply-To: <20081108052519.GA11067@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Identified-User: {2990:host272.hostmonster.com:uniscape:uniscape.net} {sentby:smtp auth 124.76.1.187 authed with yu.zhao@uniscape.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Sat, Nov 08, 2008 at 01:00:29PM +0800, Yu Zhao wrote:
>> Greg KH wrote:
>>> On Fri, Nov 07, 2008 at 04:35:47PM +0800, Zhao, Yu wrote:
>>>> Greg KH wrote:
>>>>> On Fri, Nov 07, 2008 at 04:17:02PM +0800, Zhao, Yu wrote:
>>>>>>> Well, to do it "correctly" you are going to have to tell the driver to
>>>>>>> shut itself down, and reinitialize itself.
>>>>>>> Turns out, that doesn't really work for disk and network devices 
>>>>>>> without
>>>>>>> dropping the connection (well, network devices should be fine 
>>>>>>> probably).
>>>>>>> So you just can't do this, sorry.  That's why the BIOS handles all of
>>>>>>> these issues in a PCI hotplug system.
>>>>>>> How does the hardware people think we are going to handle this in the
>>>>>>> OS?  It's not something that any operating system can do, is it part 
>>>>>>> of
>>>>>>> the IOV PCI spec somewhere?
>>>>>> No, it's not part of the PCI IOV spec.
>>>>>>
>>>>>> I just want the IOV (and whole PCI subsystem) have more flexibility on 
>>>>>> various BIOSes. So can we reconsider about resource rebalance as boot 
>>>>>> option, or should we forget about this idea?
>>>>> As you have proposed it, the boot option will not work at all, so I
>>>>> think we need to forget about it.  Especially if it is not really
>>>>> needed.
>>>> I guess at least one thing would work if people don't want to boot twice: 
>>>> give the bus number 0 as rebalance starting point, then all system 
>>>> resources would be reshuffled :-)
>>> Hm, but don't we do that today with our basic resource reservation logic
>>> at boot time?  What would be different about this kind of proposal?
>> The generic PCI core can do this but this feature is kind of disabled by 
>> low level PCI code in x86. The low level code tries to reserve resource 
>> according to configuration from BIOS. If the BIOS is wrong, the allocation 
>> would fail and the generic PCI core couldn't repair it because the bridge 
>> resources may have been allocated by the PCI low level and the PCI core 
>> can't expand them to find enough resource for the subordinates.
> 
> Yes, we do this on purpose.
> 
>> The proposal is to disable x86 PCI low level to allocation resources 
>> according to BIOS so PCI core can fully control the resource allocation. 
>> The PCI core takes all resources from BARs it knows into account and 
>> configure the resource windows on the bridges according to its own 
>> calculation.
> 
> Ah, so you mean we should revert back to the way we use to do x86 PCI
> resource allocation from about a year and a half ago to about 8 years
> ago?
> 
> Hint, there was a reason why we switched over to using the BIOS instead
> of doing it ourselves.  Turns out we have to trust the BIOS here, as
> that is exactly what other operating systems do.  Trying to do it on our
> own was too fragile and resulted in too many problems over time.
> 
> Go look at the archives for when this all was switched, you'll see the
> reasons why.
> 
> So no, we will not be going back to the way we used to do things, we
> changed for a reason :)

So it's really a long story, and I'm glad to see the reason.

Actually there was no such thing in early SR-IOV patches, but months ago 
I heard some complaints that pushed me to do this kind of reverse. Looks 
like I have to let these complaints turn to BIOS people from now on :-)

Regards,
Yu
