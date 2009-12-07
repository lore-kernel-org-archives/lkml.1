Return-Path: <linux-kernel-owner+w=401wt.eu-S935432AbZLGQiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935432AbZLGQiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 11:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935422AbZLGQiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 11:38:52 -0500
Received: from mga14.intel.com ([143.182.124.37]:22216 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935420AbZLGQiv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 11:38:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="219714715"
From: "Tung, Chien Tin" <chien.tin.tung@intel.com>
To: Julia Lawall <julia@diku.dk>
CC: "Latif, Faisal" <faisal.latif@intel.com>,
       Roland Dreier <rolandd@cisco.com>, "Hefty, Sean" <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>,
       "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Mon, 7 Dec 2009 09:38:55 -0700
Subject: RE: [PATCH 3/5] drivers/infiniband: correct size computation
Thread-Topic: [PATCH 3/5] drivers/infiniband: correct size computation
Thread-Index: Acp3WX/uWyMCHYN/TPqBTJSTa63e5gAAcqtg
Message-ID: <603F8A3875DCE940BA37B49D0A6EA0AE3CE36C9F@azsmsx501.amr.corp.intel.com>
References: <Pine.LNX.4.64.0912061015540.20858@ask.diku.dk>
 <603F8A3875DCE940BA37B49D0A6EA0AE3CE36BF4@azsmsx501.amr.corp.intel.com>
 <Pine.LNX.4.64.0912071720520.15109@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0912071720520.15109@ask.diku.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > 	/* Remap the PCI registers in adapter BAR0 to kernel VA space */
>> >-	mmio_regs = ioremap_nocache(pci_resource_start(pcidev, BAR_0), sizeof(mmio_regs));
>> >+	mmio_regs = ioremap_nocache(pci_resource_start(pcidev, BAR_0),
>> >+				    sizeof(*mmio_regs));
>> > 	if (mmio_regs == NULL) {
>> > 		printk(KERN_ERR PFX "Unable to remap BAR0\n");
>> > 		ret = -EIO;
>>
>> mmio_regs is initialized to NULL at the top of the function so
>> *mmio_regs wouldn't be a good idea.  Instead of sizeof(*mmio_regs) use
>> pci_resource_len(pcidev, BAR_0).  If you can recreate the patch with
>> this change I will ack it.
>
>When you say that it isn't a good idea, do you mean that the result is
>wrong, or that it looks odd?  I didn't think sizeof looked at the value,
>but only at the type?


I misspoke on the problem.  Mmio_regs is declared as a void pointer:

        void __iomem *mmio_regs = NULL;

Thus pci_resource_len(pcidev, BAR_0) is the correct fix.

Chien


