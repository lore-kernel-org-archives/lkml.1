Return-Path: <linux-kernel-owner+w=401wt.eu-S1753369AbYKHF5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbYKHF5x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 00:57:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbYKHF5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 00:57:41 -0500
Received: from kroah.org ([198.145.64.141]:43662 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750971AbYKHF5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 00:57:40 -0500
Date: Fri, 7 Nov 2008 21:54:22 -0800
From: Greg KH <greg@kroah.com>
To: freevanx <freevanx@gmail.com>
Cc: Yu Zhao <yu.zhao@uniscape.net>, "Zhao, Yu" <yu.zhao@intel.com>,
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
Message-ID: <20081108055422.GA15055@kroah.com>
References: <4913B8A5.5010806@intel.com> <20081107061603.GC3860@kroah.com> <4913F34A.8020805@intel.com> <20081107080222.GA6284@kroah.com> <4913F97E.7030408@intel.com> <20081107082432.GA6601@kroah.com> <4913FDE3.8050804@intel.com> <20081107185325.GE2320@kroah.com> <49151CED.8060507@uniscape.net> <fe8256d20811072150o1d82e8bdq40bf61df0a3faebe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe8256d20811072150o1d82e8bdq40bf61df0a3faebe@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 08, 2008 at 01:50:20PM +0800, freevanx wrote:
> Dear all,
> 
> I'm glad to hear this. In fact, I'm developing for BIOS area. This feature
> is very useful when your system have one or more PCI/PCIe hotplug slot.
> Generally, BIOS reserve amount of resource for empty hotplug slot by
> default, but it is not always enough for all device. We have many kind of
> Express Modules which consume different amount of resouce, generally we
> reserve a small number of resouce for this, so, sometime, some Express
> Modules hotplug without card installed at boot time, it will not useable.

Then fix the BIOS :)

Seriously, that is what the PCI hotplug spec says to do, right?

> Then, Microsoft say they implement PCI Multi-level Resource Rebanlence in
> Vista and Server 2008, you can refer
> http://www.microsoft.com/whdc/archive/multilevel-rebal.mspx
> http://www.microsoft.com/whdc/connect/pci/PCI-rsc.mspx

But they did not implement this for Vista, and pulled it before it
shipped, right?  That is what the driver development documentation for
Vista said that I read.

Do you know if they are going to add it back for Windows 7?  If so, then
we should probably look into this, otherwise, no need to, as the BIOSes
will be fixed properly.

> They use a method of ACPI to tell OS that you can ignore the resource
> allocation of PCI devices below the bridge. I think this is more useful than
> specify the BUS number to ignore resouce allocation, because the BUS number
> often change due to some need by BIOS or new PCI/PCIe device added in
> system. Users generally do not know the system architecture and can not
> specify the BUS number of the root bridge, while if you specify the _DSM
> method like MS to the root bridge of hotplug slot, it is a much easier way
> to archive for BIOS writers.

Yes, push the burden of getting this right onto the OS developers,
instead of doing it properly in the BIOS, how fun :(

Seriously, it isn't that hard to reserve enough space on most machines
in the BIOS to get this correct.  It only gets messy when you have
hundreds of hotplug PCI slots and bridges.  Even then, the BIOS writers
have been able to resolve this for a while due to this kind of hardware
shipping successfully with Linux for many years now.

> PS:
> Since my mail address was blocked by the maillist, this mail may not reach
> people who only in linux kernel maillist.

It is being blocked because you are sending out html email.

Please reconfigure your gmail client to not do that, and your mail will
go through just fine.

thanks,

greg k-h
