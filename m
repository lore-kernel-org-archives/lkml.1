Return-Path: <linux-kernel-owner+w=401wt.eu-S1757065AbZCFXbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065AbZCFXbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 18:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756465AbZCFXbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 18:31:31 -0500
Received: from mga01.intel.com ([192.55.52.88]:18774 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755047AbZCFXb3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 18:31:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,317,1233561600"; 
   d="scan'208";a="671028433"
From: "Duyck, Alexander H" <alexander.h.duyck@intel.com>
To: Randy Dunlap <rdunlap@xenotime.net>, Matthew Wilcox <matthew@wil.cx>
CC: "Zhao, Yu" <yu.zhao@intel.com>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 6 Mar 2009 15:31:27 -0800
Subject: RE: [PATCH v10 1/7] PCI: initialize and release SR-IOV capability
Thread-Topic: [PATCH v10 1/7] PCI: initialize and release SR-IOV capability
Thread-Index: AcmepzaW7N6kt/EERLm0kXDF2BYGcQABcQzQ
Message-ID: <80769D7B14936844A23C0C43D9FBCF0F2C5E0EF0@orsmsx501.amr.corp.intel.com>
References: <1235112888-9524-1-git-send-email-yu.zhao@intel.com>
 <1235112888-9524-2-git-send-email-yu.zhao@intel.com>
 <20090306200810.GD25995@parisc-linux.org> <49B19DB5.9050606@xenotime.net>
In-Reply-To: <49B19DB5.9050606@xenotime.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> Matthew Wilcox wrote:
>> On Fri, Feb 20, 2009 at 02:54:42PM +0800, Yu Zhao wrote:
>> PCI MSI can also be disabled at runtime (and Fedora do by default).
>> Since SR-IOV really does require MSI, we need to put in a runtime
>> check to see if pci_msi_enabled() is false.
>> 
>> We don't depend on PCIEPORTBUS (a horribly named symbol).  Should we?
>> SR-IOV is only supported for PCI Express machines.  I'm not sure of
>> the right answer here, but I thought I should raise the question.
>> 
>>> +	help
>>> +	  PCI-SIG I/O Virtualization (IOV) Specifications support.
>>> +	  Single Root IOV: allows the Physical Function driver to enable
>>> +	  the hardware capability, so the Virtual Function is accessible
>>> +	  via the PCI Configuration Space using its own Bus, Device and
>>> +	  Function Numbers. Each Virtual Function also has the PCI Memory
>>> +	  Space to map the device specific register set.
> 
> Too spec. and implementation specific for users.
> 
>> I'm not convinced this is the most helpful we could be to the user
>> who's configuring their own kernel.  How about something like this? 
>> (Randy, I particularly look to you to make my prose less turgid).
>> 
>> 	help
>> 	  IO Virtualisation is a PCI feature supported by some devices 	   
>> 	  z ;) which allows you to create virtual PCI devices and assign
>> 	  them to guest OSes.  This option needs to be selected in the host
>> 	  or Dom0 kernel, but does not need to be selected in the guest
>> 	  or DomU kernel.  If you don't know whether your hardware supports
>> 	  it, you can check by using lspci to look for the SR-IOV
>> capability. 
>> 
>> 	  If you have no idea what any of that means, it is safe to
>> 	  answer 'N' here.
> 
> That's certainly more readable and user-friendly.
> I don't know what else it needs.  Looks good to me.
> 
> ~Randy

I'm not sure about this help text because SR-IOV and direct assignment are two very different features, and based on this text I would think that SR-IOV is all you need to direct assign VFs into guests when all it actually does is generate the devices that can then be assigned.  We already have questions about if VFs can be used on the host OS and this help text doesn't resolve that and would likely lead to similar questions in the future.

I would recommend keeping things simple and just stating "IO Virtualization is a PCI feature, supported by some devices, which allows the creation of virtual PCI devices that contain a subset of the original device's resources.  If you don't know if you hardware supports it, you can check by using lspci to check for the SR-IOV capability".

-Alex

