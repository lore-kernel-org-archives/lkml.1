Return-Path: <linux-kernel-owner+w=401wt.eu-S1752313AbYJ0DS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbYJ0DS4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 23:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbYJ0DSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 23:18:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:62511 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbYJ0DSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 23:18:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,490,1220252400"; 
   d="scan'208";a="352557554"
Message-ID: <49053313.9080706@intel.com>
Date: Mon, 27 Oct 2008 11:18:43 +0800
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
References: <b9df5fa10809280816u23ef3021k7eee287a237b72ae@mail.gmail.com> <20080928163211.GR27204@parisc-linux.org> <20081021011308.GA3889@parisc-linux.org> <490467CD.3000402@uniscape.net> <20081026183412.GX26094@parisc-linux.org>
In-Reply-To: <20081026183412.GX26094@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Sun, Oct 26, 2008 at 08:51:25PM +0800, Yu Zhao wrote:
>> This reminds me of other problems of PCI search functions.
>>
>> The 'dev_start' is passed to bus_find_device(), and its 'knode_bus' 
>> reference count is decreased by klist_iter_init_node() in that function. 
>> The problem is the reference count may be already decrease to 0 because 
>> the PCI device 'from' is hot-plugged off (e.g., pci_remove_bus) when the 
>> search goes. A warning is fired when klist_iter_init_node() detects the 
>> reference count becomes 0.
>>
>> Some code uses pci_find_device() in a way that is not safe with the 
>> hotplug, because a device may be destroyed after bus_find_device() 
>> returns it and before it's held by pci_dev_get() in the next round. 
>> Following is an example from a random grep:
> 
> Yes, that's why pci_find_device() is deprecated.  But it doesn't also
> need to be buggy ;-)
> 

How about pci_get_bus_and_slot()? People would meet the problem with it 
anyway.

Thanks,
Yu
