Return-Path: <linux-kernel-owner+w=401wt.eu-S1755826AbYCLVrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826AbYCLVrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 17:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbYCLVrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 17:47:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:31847 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733AbYCLVrB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 17:47:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,490,1199692800"; 
   d="scan'208";a="353905254"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH, RFC] Create 'slot' sysfs attribute in/sys/devices/system/cpu/cpuN/topology/
Date: Wed, 12 Mar 2008 14:42:04 -0700
Message-ID: <1FE6DD409037234FAB833C420AA843ECCBFA9D@orsmsx424.amr.corp.intel.com>
In-Reply-To: <20080310222735.GA22619@ldl.fc.hp.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH, RFC] Create 'slot' sysfs attribute in/sys/devices/system/cpu/cpuN/topology/
Thread-Index: AciC/fH/EZSgZKXLRHiH2V78Fqzs0wBiPnxQ
References: <20080310222735.GA22619@ldl.fc.hp.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Alex Chiang" <achiang@hp.com>, <lenb@kernel.org>
Cc: <linux-ia64@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 12 Mar 2008 21:42:07.0662 (UTC) FILETIME=[EB8224E0:01C88489]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> include/asm-x86/cpu.h         |    1 +

I assume this slipped in accidentally (though it would
eventually be needed for an x86 version of this patch).

> +#ifdef	topology_slot
> +define_id_show_func(slot);
> +define_one_ro(slot);
> +#define ref_slot_attr			&attr_slot.attr,
> +#else
> +#define ref_slot_attr
> +#endif

This is a bit ugly ... I don't see how to make it better (but
I'm sure that akpm will say "You could just ...", and then
I'll wonder why I didn't think of that).

> +EXPORT_SYMBOL(arch_set_topology_slot);

As the author you get to choose the license ... but there is
strong movement to make new exported symbols GPL only.

When I apply this patch and run it on my tiger, I see a slew
of

	ACPI: Invalid PBLK length [0]

messages on my console during boot and the see

	$ cat /sys/devices/system/cpu/cpu0/topology/slot
	-1

So I guess that the _SUN method isn't there on my machine.

-Tony
