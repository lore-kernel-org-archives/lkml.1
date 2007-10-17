Return-Path: <linux-kernel-owner+w=401wt.eu-S935778AbXJQCBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935778AbXJQCBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 22:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753965AbXJQCBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 22:01:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:3696 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753806AbXJQCBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 22:01:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,286,1188802800"; 
   d="scan'208";a="248797958"
Subject: Re: [PATCH -mm -v5 0/3] i386/x86_64 boot: 32-bit boot protocol
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1192168345.17539.42.camel@caritas-dev.intel.com>
References: <1192168345.17539.42.camel@caritas-dev.intel.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 17 Oct 2007 09:59:36 +0800
Message-Id: <1192586376.17856.26.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 17 Oct 2007 01:57:10.0354 (UTC) FILETIME=[077CA320:01C81061]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-12 at 13:52 +0800, Huang, Ying wrote:
> Known Issues:
> 
> - Where is safe to place the linked list of setup_data?  Because the
>   length of the linked list of setup_data is variable, it can not be
>   copied into BSS segment of kernel as that of "zero page". We must
>   find a safe place for it, where it will not be overwritten by kernel
>   during booting up. The i386 kernel will overwrite some pages after
>   _end. The x86_64 kernel will overwrite some pages from 0x1000 on.

Do you think it is a good idea to check the collision between setup data
and memory area used during kernel boot through bootmem allocator? If
any memory area used by setup data is reserved in bootmem allocator by
some other kernel subsystem, there is a collision, otherwise, the setup
data should be safe.

Best Regards,
Huang Ying
