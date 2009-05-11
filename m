Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbZEKGYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbZEKGYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 02:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754038AbZEKGYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 02:24:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:31780 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053AbZEKGYV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 02:24:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,327,1239001200"; 
   d="scan'208";a="455912960"
From: "Han, Weidong" <weidong.han@intel.com>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Date: Mon, 11 May 2009 14:22:54 +0800
Subject: RE: [PATCH 2/2] Intel-IOMMU, intr-remap: source-id checking
Thread-Topic: [PATCH 2/2] Intel-IOMMU, intr-remap: source-id checking
Thread-Index: AcnPQKSkjtLK9s4WQ7idkslKWtMORgCv6bgA
Message-ID: <715D42877B251141A38726ABF5CABF2C01A6DD4900@pdsmsx503.ccr.corp.intel.com>
References: <1241676996-27406-1-git-send-email-weidong.han@intel.com>
	 <1241676996-27406-2-git-send-email-weidong.han@intel.com>
 <1241720381.27006.8582.camel@localhost.localdomain>
In-Reply-To: <1241720381.27006.8582.camel@localhost.localdomain>
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

Siddha, Suresh B wrote:
> On Wed, 2009-05-06 at 23:16 -0700, Han, Weidong wrote:
>> @@ -634,6 +694,44 @@ static int ir_parse_ioapic_scope(struct
>>  			       acpi_dmar_header *header, " 0x%Lx\n",
>>  			       scope->enumeration_id, drhd->address);
>> 
>> +			bus = pci_find_bus(drhd->segment, scope->bus);
>> +			path = (struct acpi_dmar_pci_path *)(scope + 1); +			count =
>> (scope->length - +				 sizeof(struct acpi_dmar_device_scope))
>> +				/ sizeof(struct acpi_dmar_pci_path);
>> +
>> +			while (count) {
>> +				if (pdev)
>> +					pci_dev_put(pdev);
>> +
>> +				if (!bus)
>> +					break;
>> +
>> +				pdev = pci_get_slot(bus,
>> +					PCI_DEVFN(path->dev, path->fn));
>> +				if (!pdev)
>> +					break;
> 
> ir_parse_ioapic_scope() happens very early in the boot. So, I don't
> think we can do the pci related discovery here.
> 

Thanks for your pointing it out. It should enable the source-id checking for io-apic's after the pci subsystem is up. I will change it.

Regards,
Weidong