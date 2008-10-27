Return-Path: <linux-kernel-owner+w=401wt.eu-S1752569AbYJ0HPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbYJ0HPK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 03:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbYJ0HO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 03:14:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:11577 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbYJ0HO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 03:14:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,491,1220252400"; 
   d="scan'208";a="352591629"
Message-ID: <49056A2F.6030206@intel.com>
Date: Mon, 27 Oct 2008 15:13:51 +0800
From: "Zhao, Yu" <yu.zhao@intel.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Yu Zhao <yu.zhao@uniscape.net>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       Rakib Mullick <rakib.mullick@gmail.com>
Subject: Re: [PATCH] pci: Fixing drivers/pci/search.c compilation warning.
References: <b9df5fa10809280816u23ef3021k7eee287a237b72ae@mail.gmail.com> <20080928163211.GR27204@parisc-linux.org> <20081021011308.GA3889@parisc-linux.org> <490467CD.3000402@uniscape.net> <20081026183412.GX26094@parisc-linux.org> <49053313.9080706@intel.com> <20081027070745.GY26094@parisc-linux.org>
In-Reply-To: <20081027070745.GY26094@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Mon, Oct 27, 2008 at 11:18:43AM +0800, Zhao, Yu wrote:
>> Matthew Wilcox wrote:
>>> Yes, that's why pci_find_device() is deprecated.  But it doesn't also
>>> need to be buggy ;-)
>> How about pci_get_bus_and_slot()? People would meet the problem with it 
>> anyway.
> 
> What problem with it?  It's documented to return the device with an
> increased refcount, and the implementation appears to do exactly that:
> 
> struct pci_dev * pci_get_bus_and_slot(unsigned int bus, unsigned int devfn)
> {
>         struct pci_dev *dev = NULL;
> 
>         while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
>                 if (pci_domain_nr(dev->bus) == 0 &&
>                    (dev->bus->number == bus && dev->devfn == devfn))
>                         return dev;
>         }
>         return NULL;
> }
> 
> Are you saying some users of it neglect to decrement the refcount before
> disposing of the device?
> 

The 'dev' returned by pci_get_device() may be destroyed by PCI hotplug. 
I suppose that passing this 'dev' to pci_get_device() in the next loop 
would crash the system, right?
