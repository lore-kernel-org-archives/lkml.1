Return-Path: <linux-kernel-owner+w=401wt.eu-S1755311Ab0ASIds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab0ASIds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 03:33:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315Ab0ASIdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 03:33:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:37701 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932151Ab0ASIdr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 03:33:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,302,1262592000"; 
   d="scan'208";a="485103659"
From: "Zheng, Shaohui" <shaohui.zheng@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ak@linux.intel.com" <ak@linux.intel.com>,
       "y-goto@jp.fujitsu.com" <y-goto@jp.fujitsu.com>,
       Dave Hansen <haveblue@us.ibm.com>,
       "Wu, Fengguang" <fengguang.wu@intel.com>,
       "x86@kernel.org" <x86@kernel.org>
Date: Tue, 19 Jan 2010 16:33:08 +0800
Subject: RE: [PATCH-RESEND v4] memory-hotplug: create /sys/firmware/memmap
 entry for new memory
Thread-Topic: [PATCH-RESEND v4] memory-hotplug: create /sys/firmware/memmap
 entry for new memory
Thread-Index: AcqWM277R2FxHEDuQJCxcXuKExCYjQCrNg8A
Message-ID: <DA586906BA1FFC4384FCFD6429ECE86034FF8F0C@shzsmsx502.ccr.corp.intel.com>
References: <DA586906BA1FFC4384FCFD6429ECE86031560F92@shzsmsx502.ccr.corp.intel.com>
 <20100115143812.b70161d2.akpm@linux-foundation.org>
In-Reply-To: <20100115143812.b70161d2.akpm@linux-foundation.org>
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

I did some investigation for my patch, I see that there is an error when I make v4 patch from v3, I change the function firmware_map_add_early() by carelessness, 
The code 
	entry = alloc_bootmem(sizeof(struct firmware_map_entry));
was changed to 
	entry = kmalloc(sizeof(struct firmware_map_entry), GFP_ATOMIC);


The modification from v3 to v4 is minor, so I did not do full testing for v4 patch, I apologize for my fault.	

The patch works after I correct the this code. I will resend it. 

Thanks & Regards,
Shaohui


-----Original Message-----
From: Andrew Morton [mailto:akpm@linux-foundation.org] 
Sent: Saturday, January 16, 2010 6:38 AM
To: Zheng, Shaohui
Cc: linux-mm@kvack.org; linux-kernel@vger.kernel.org; ak@linux.intel.com; y-goto@jp.fujitsu.com; Dave Hansen; Wu, Fengguang; x86@kernel.org
Subject: Re: [PATCH-RESEND v4] memory-hotplug: create /sys/firmware/memmap entry for new memory

On Mon, 11 Jan 2010 10:00:11 +0800
"Zheng, Shaohui" <shaohui.zheng@intel.com> wrote:

> memory-hotplug: create /sys/firmware/memmap entry for hot-added memory
> 
> Interface firmware_map_add was not called in explict, Remove it and add function
> firmware_map_add_hotplug as hotplug interface of memmap.
> 
> When we hot-add new memory, sysfs does not export memmap entry for it. we add
>  a call in function add_memory to function firmware_map_add_hotplug.
> 
> Add a new function add_sysfs_fw_map_entry to create memmap entry, it can avoid 
> duplicated codes.

The patch causes an early exception in kmem_cache_alloc_notrace() -
probably due to a null cache pointer.

config: http://master.kernel.org/~akpm/config-akpm2.txt
