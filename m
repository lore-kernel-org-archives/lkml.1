Return-Path: <linux-kernel-owner+w=401wt.eu-S1759830AbXHFFkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759830AbXHFFkw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 01:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbXHFFkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 01:40:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:38489 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbXHFFko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 01:40:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,224,1183359600"; 
   d="scan'208";a="259363296"
Subject: Re: [PATCH 0/5] x86_64 EFI support -v3
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: ak@suse.de, akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org, "Mao, Bibo" <bibo.mao@intel.com>
In-Reply-To: <m1myxdtc19.fsf@ebiederm.dsl.xmission.com>
References: <1185851569.23149.25.camel@caritas-dev.intel.com>
	 <m1myxdtc19.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 06 Aug 2007 13:40:38 +0800
Message-Id: <1186378838.3769.27.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 06 Aug 2007 05:40:34.0280 (UTC) FILETIME=[4F1B6E80:01C7D7EC]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 12:47 +0800, Eric W. Biederman wrote:
> Using efi_set_virtual means kdump doesn't work which means that no
> one is going to use this in a prebuilt kernel.

It is possible to make kexec/kdump work with EFI virtual mode, in
following ways:

1. Do not turn on EFI in kexeced kernel. That is, when kexec prepares
the boot parameters for kexeced kernel, do not set boot parameter
"EFI_LOADER_SIG" to be "EFIL". And, if the boot parameter
"screen_info.orig_video_isVGA" is set to VIDEO_TYPE_EFI and other
members of "screen_info" are set properly, the EFI framebuffer can work
properly too. With this method, a EFI disabled kernel can be kexeced
from a EFI enabled kernel. This is OK for kdump to work.

2. If it is intended to kexec a EFI enabled kernel from a EFI enabled
kernel, the same method as IA64 EFI virtual mode support can be used.
That is, the memory area used by EFI runtime service is mapped to exact
same address in both kernels, and the "efi_set_virtual" is not called in
kexeced kernel. A fixmap area can be used to map memory mapped IO area
of EFI runtime service, the code and data area of EFI runtime service
are always mapped to same address in direct map area.

Best Regards,
Huang Ying
