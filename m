Return-Path: <linux-kernel-owner+w=401wt.eu-S1764451AbXJOBpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764451AbXJOBpx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 21:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754386AbXJOBpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 21:45:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:42378 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361AbXJOBpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 21:45:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,274,1188802800"; 
   d="scan'208";a="173762494"
Subject: Re: [PATCH -mm -v5 0/3] i386/x86_64 boot: 32-bit boot protocol
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1192168345.17539.42.camel@caritas-dev.intel.com>
References: <1192168345.17539.42.camel@caritas-dev.intel.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 15 Oct 2007 09:47:14 +0800
Message-Id: <1192412834.28792.16.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 15 Oct 2007 01:44:53.0520 (UTC) FILETIME=[FB793100:01C80ECC]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Peter and Andi,

Do you think this patch set is ready for merging? Otherwise what I can
do to make it ready?

Best Regards,
Huang Ying

On Fri, 2007-10-12 at 13:52 +0800, Huang, Ying wrote:
> This patchset defines a 32-bit boot protocol for i386/x86_64 platform,
> adds an extensible boot parameter passing mechanism, export the boot
> parameters via sysfs.
> 
> The patchset has been tested against 2.6.23-rc8-mm2 kernel on x86_64
> and i386.
> 
> This patchset is based on the proposal of Peter Anvin.
> 
> 
> Known Issues:
> 
> - Where is safe to place the linked list of setup_data?  Because the
>   length of the linked list of setup_data is variable, it can not be
>   copied into BSS segment of kernel as that of "zero page". We must
>   find a safe place for it, where it will not be overwritten by kernel
>   during booting up. The i386 kernel will overwrite some pages after
>   _end. The x86_64 kernel will overwrite some pages from 0x1000 on.
> 
> - The fields in zero page are fairly complex (such as struct
>   edd_info). Is it necessary to document every field inside the first
>   level fields, until the primary data type? Or is it sufficient to
>   provide the C struct name only?
> 
> 
> v5:
> 
> - Use bt_ioremap/bt_iounmap in copy_setup_data.
> 
> v4:
> 
> - Reserve setup_data and boot parameters for accessing during
>   runtime.
> - Export boot parameters via sysfs.
> 
> v3:
> 
> - Move hd0_info and hd1_info back to zero page for compatibility.
> 
> v2:
> 
> - Increase the boot protocol version number
> - Check version number before parsing setup data.
> - Revise zero page description according to the source code and move
>   them to zero-page.txt.
