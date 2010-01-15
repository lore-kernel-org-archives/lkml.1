Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467Ab0AOWjE (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 17:39:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758352Ab0AOWjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 17:39:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40607 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758298Ab0AOWjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 17:39:03 -0500
Date: Fri, 15 Jan 2010 14:38:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Zheng, Shaohui" <shaohui.zheng@intel.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "y-goto@jp.fujitsu.com" <y-goto@jp.fujitsu.com>,
        Dave Hansen <haveblue@us.ibm.com>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH-RESEND v4] memory-hotplug: create /sys/firmware/memmap
 entry for new memory
Message-Id: <20100115143812.b70161d2.akpm@linux-foundation.org>
In-Reply-To: <DA586906BA1FFC4384FCFD6429ECE86031560F92@shzsmsx502.ccr.corp.intel.com>
References: <DA586906BA1FFC4384FCFD6429ECE86031560F92@shzsmsx502.ccr.corp.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
