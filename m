Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202AbYJNE1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbYJNE1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 00:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbYJNE1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 00:27:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:51619 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbYJNE1a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 00:27:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,406,1220252400"; 
   d="scan'208";a="450910609"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 6/6 v3] PCI: document the change
Date: Tue, 14 Oct 2008 12:18:40 +0800
Message-ID: <08DF4D958216244799FC84F3514D70F00235CF5E@pdsmsx415.ccr.corp.intel.com>
In-Reply-To: <20081014040105.GA25780@parisc-linux.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 6/6 v3] PCI: document the change
Thread-Index: AcktsaMoH8Nh4vCvSNe/DEJ++WvqUwAAZjyg
References: <D8078B8B3B09934AA9F8F2D5FB3F28CE088751B5F6@pdsmsx502.ccr.corp.intel.com> <20081001160706.GI13822@parisc-linux.org> <08DF4D958216244799FC84F3514D70F00235CC69@pdsmsx415.ccr.corp.intel.com> <20081014010827.GX25780@parisc-linux.org> <08DF4D958216244799FC84F3514D70F00235CE27@pdsmsx415.ccr.corp.intel.com> <20081014021435.GA1482@yzhao12-linux.sh.intel.com> <20081014040105.GA25780@parisc-linux.org>
From: "Dong, Eddie" <eddie.dong@intel.com>
To: "Matthew Wilcox" <matthew@wil.cx>, "Zhao, Yu" <yu.zhao@intel.com>
Cc: <linux-pci@vger.kernel.org>, "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Grant Grundler" <grundler@parisc-linux.org>,
       "Alex Chiang" <achiang@hp.com>, "Roland Dreier" <rdreier@cisco.com>,
       "Greg KH" <greg@kroah.com>, <linux-kernel@vger.kernel.org>,
       <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
       "Dong, Eddie" <eddie.dong@intel.com>
X-OriginalArrivalTime: 14 Oct 2008 04:18:33.0630 (UTC) FILETIME=[EBDD13E0:01C92DB3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Tue, Oct 14, 2008 at 10:14:35AM +0800, Yu Zhao wrote:
>>> BTW, the SR-IOV patch is not only for network, some
>>> other devices such as IDE will use same code base as
>>> well and we image it could have other parameter to set
>>> such as starting LBA of a IDE VF.   
>> 
>> As Eddie said, we have two problems here:
>> 1) User has to set device specific parameters of a VF
>> when he wants to use this VF with KVM (assign this
>> device to KVM guest). In this case, 
>> VF driver is not loaded in the host environment. So
>> operations which 
>> are implemented as driver callback (e.g.
>> set_mac_address()) are not supported.
> 
> I suspect what you want to do is create, then configure
> the device in the host, then assign it to the guest.

That is not true. Rememver the created VFs will be destroyed no matter
for PF power event or error recovery conducted reset.
So what we want is:

Config, create, assign, and then deassign and destroy and then
recreate...

> 
>> 2) For security reason, some SR-IOV devices prohibit the
>> VF driver configuring the VF via its own register space.
>> Instead, the configurations must be done through the PF
>> which the VF is associated with. This means PF driver
>> has to receive parameters that are used to configure its
>> VFs. These parameters obviously can be passed by
>> traditional tools, if without modification for SR-IOV. 
> 
> I think that idea also covers this point.
> 
Sorry can u explain a little bit more? The SR-IOV patch won't define
what kind of entries should be created or not, we leave network
subsystem to decide what to do. Same for disk subsstem etc.

Thx, eddie
