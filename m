Return-Path: <linux-kernel-owner+w=401wt.eu-S1757336AbZCFWCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336AbZCFWCM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 17:02:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757291AbZCFWBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 17:01:55 -0500
Received: from xenotime.net ([72.52.64.118]:51647 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754975AbZCFWBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 17:01:53 -0500
Message-ID: <49B19DB5.9050606@xenotime.net>
Date: Fri, 06 Mar 2009 14:03:33 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Yu Zhao <yu.zhao@intel.com>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 1/7] PCI: initialize and release SR-IOV capability
References: <1235112888-9524-1-git-send-email-yu.zhao@intel.com> <1235112888-9524-2-git-send-email-yu.zhao@intel.com> <20090306200810.GD25995@parisc-linux.org>
In-Reply-To: <20090306200810.GD25995@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Fri, Feb 20, 2009 at 02:54:42PM +0800, Yu Zhao wrote:
>> +config PCI_IOV
>> +	bool "PCI IOV support"
>> +	depends on PCI
>> +	select PCI_MSI
> 
> My understanding is that having 'select' of a config symbol that the
> user can choose is bad.  I think we should probably make this 'depends
> on PCI_MSI'.

Ack.

> PCI MSI can also be disabled at runtime (and Fedora do by default).
> Since SR-IOV really does require MSI, we need to put in a runtime check
> to see if pci_msi_enabled() is false.
> 
> We don't depend on PCIEPORTBUS (a horribly named symbol).  Should we?
> SR-IOV is only supported for PCI Express machines.  I'm not sure of the
> right answer here, but I thought I should raise the question.
> 
>> +	help
>> +	  PCI-SIG I/O Virtualization (IOV) Specifications support.
>> +	  Single Root IOV: allows the Physical Function driver to enable
>> +	  the hardware capability, so the Virtual Function is accessible
>> +	  via the PCI Configuration Space using its own Bus, Device and
>> +	  Function Numbers. Each Virtual Function also has the PCI Memory
>> +	  Space to map the device specific register set.

Too spec. and implementation specific for users.

> I'm not convinced this is the most helpful we could be to the user who's
> configuring their own kernel.  How about something like this?  (Randy, I
> particularly look to you to make my prose less turgid).
> 
> 	help
> 	  IO Virtualisation is a PCI feature supported by some devices
	             z ;)
> 	  which allows you to create virtual PCI devices and assign them
> 	  to guest OSes.  This option needs to be selected in the host
> 	  or Dom0 kernel, but does not need to be selected in the guest
> 	  or DomU kernel.  If you don't know whether your hardware supports
> 	  it, you can check by using lspci to look for the SR-IOV capability.
> 
> 	  If you have no idea what any of that means, it is safe to
> 	  answer 'N' here.

That's certainly more readable and user-friendly.
I don't know what else it needs.  Looks good to me.

~Randy

