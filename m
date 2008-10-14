Return-Path: <linux-kernel-owner+w=401wt.eu-S932196AbYJNAXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196AbYJNAXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 20:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758032AbYJNAXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 20:23:33 -0400
Received: from mga14.intel.com ([143.182.124.37]:30472 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756479AbYJNAXc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 20:23:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,405,1220252400"; 
   d="scan'208";a="59401331"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 6/6 v3] PCI: document the change
Date: Tue, 14 Oct 2008 08:23:34 +0800
Message-ID: <08DF4D958216244799FC84F3514D70F00235CC69@pdsmsx415.ccr.corp.intel.com>
In-Reply-To: <20081001160706.GI13822@parisc-linux.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 6/6 v3] PCI: document the change
Thread-Index: Ackj39PVFUinfMogTyiT2WCiZpwFJAJsgORA
References: <D8078B8B3B09934AA9F8F2D5FB3F28CE088751B5F6@pdsmsx502.ccr.corp.intel.com> <20081001160706.GI13822@parisc-linux.org>
From: "Dong, Eddie" <eddie.dong@intel.com>
To: "Matthew Wilcox" <matthew@wil.cx>, "Zhao, Yu" <yu.zhao@intel.com>
Cc: <linux-pci@vger.kernel.org>, "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Grant Grundler" <grundler@parisc-linux.org>,
       "Alex Chiang" <achiang@hp.com>, "Roland Dreier" <rdreier@cisco.com>,
       "Greg KH" <greg@kroah.com>, <linux-kernel@vger.kernel.org>,
       <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
       "Dong, Eddie" <eddie.dong@intel.com>
X-OriginalArrivalTime: 14 Oct 2008 00:23:27.0651 (UTC) FILETIME=[140B7F30:01C92D93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
 
> Wouldn't it be more useful to have the iov/N directories
> be a symlink to the actual pci_dev used by the virtual
> function? 

The main concern here is that a VF may be disabed such as when PF enter
D3 state or undergo an reset and thus be plug-off, but user won't
re-configure the VF in case the PF return back to working state.

> 
>> +For network device, there are:
>> +       - /sys/bus/pci/devices/BB:DD.F/iov/N/mac
>> +       - /sys/bus/pci/devices/BB:DD.F/iov/N/vlan
>> +               (value update will notify PF driver)
> 
> We already have tools to set the MAC and VLAN parameters
> for network devices.

Do you mean Ethtool? If yes, it is impossible for SR-IOV since the
configuration has to be done in PF side, rather than VF.

> 
> I'm not 100% convinced about this API.  The assumption
> here is that the driver will do it, but I think it should
> probably be in the core.  The driver probably wants to be

Our concern is that the PF driver may put an default state when it is
loaded so that SR-IOV can work without any user level configuration, but
of course the driver won't dynamically change it.
Do u mean we remove this ability?

> notified that the PCI core is going to create a virtual
> function, and would it please prepare to do so, but I'm
> not convinced this should be triggered by the driver. 
> How would the driver decide to create a new virtual
> function?  
> 
> 
> From my reading of the SR-IOV spec, this isn't how it's
> supposed to work.  The device is supposed to be a fully
> functional PCI device that on demand can start peeling
> off virtual functions; it's not supposed to boot up and
> initialise all its virtual functions at once. 

The spec defines either we enable all VFs or Disable. Per VF enabling is
not supported.
Is this what you concern?

Thanks, eddie
