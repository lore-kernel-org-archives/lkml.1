Return-Path: <linux-kernel-owner+w=401wt.eu-S1757146AbYH3GVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146AbYH3GVW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 02:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbYH3GVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 02:21:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:47636 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbYH3GVN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 02:21:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,296,1217833200"; 
   d="scan'208";a="39335307"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: refcount leak in pci_get_device()?
Date: Sat, 30 Aug 2008 14:20:52 +0800
Message-ID: <7A25B56E4BE99C4283EB931CD1A40E110177E490@pdsmsx414.ccr.corp.intel.com>
In-Reply-To: <20080830053755.GA16219@suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: refcount leak in pci_get_device()?
Thread-Index: AckKYq7Nz0ZfxC9ASHifJs16Et9eRgABI+4g
References: <20080821201918.GA24411@ldl.fc.hp.com> <20080821202504.GU8318@parisc-linux.org> <20080821204758.GB31543@suse.de> <20080821221438.GC20014@ldl.fc.hp.com> <7A25B56E4BE99C4283EB931CD1A40E110177E488@pdsmsx414.ccr.corp.intel.com> <20080830053755.GA16219@suse.de>
From: "Zhao, Yu" <yu.zhao@intel.com>
To: "Greg KH" <gregkh@suse.de>
Cc: "Alex Chiang" <achiang@hp.com>, "Matthew Wilcox" <matthew@wil.cx>,
       <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 30 Aug 2008 06:20:55.0129 (UTC) FILETIME=[8F262C90:01C90A68]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's been so for a while, guess since 2.5. I meant to say the pci_remove_bus_device(), not pci_remove_bus(), is used by pci hotplug code. If a device is being plugged off, and some drivers are calling pci_get_dev_by_id() to search something, then the warning might be fired through bus_find_device -> klist_iter_init_node ->kref_get.

Thanks,
Yu

>-----Original Message-----
>From: linux-pci-owner@vger.kernel.org
>[mailto:linux-pci-owner@vger.kernel.org] On Behalf Of Greg KH
>Sent: Saturday, August 30, 2008 1:38 PM
>To: Zhao, Yu
>Cc: Alex Chiang; Matthew Wilcox; linux-pci@vger.kernel.org;
>linux-kernel@vger.kernel.org
>Subject: Re: refcount leak in pci_get_device()?
>
>On Sat, Aug 30, 2008 at 12:23:20PM +0800, Zhao, Yu wrote:
>> And the pci_get_dev_by_id() is not safe again the PCI device removal.
>> It might fire a warning in bus_find_device() when reference count of
>> the knode_bus is decreased to 0 by pci_remove_bus().
>
>Is this something new?  Hasn't this always been that way?  Why would you
>be wanting to call this function anyway?
>
>thanks,
>
>greg k-h
>--
>To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
