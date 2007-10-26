Return-Path: <linux-kernel-owner+w=401wt.eu-S1753035AbXJZBOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbXJZBOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 21:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756649AbXJZBOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 21:14:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:55056 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500AbXJZBOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 21:14:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,330,1188802800"; 
   d="scan'208";a="358712108"
Subject: Re: [PATCH 1/3 -v4] x86_64 EFI runtime service support: EFI basic
	runtime service support
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: akpm@linux-foundation.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <m1myu75drx.fsf@ebiederm.dsl.xmission.com>
References: <1193295473.23935.202.camel@caritas-dev.intel.com>
	 <m1myu75drx.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 26 Oct 2007 09:17:14 +0800
Message-Id: <1193361434.23935.226.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 26 Oct 2007 01:14:25.0790 (UTC) FILETIME=[8C9AF9E0:01C8176D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-10-25 at 11:01 -0600, Eric W. Biederman wrote:
> > +static efi_status_t __init phys_efi_set_virtual_address_map(
> > +	unsigned long memory_map_size,
> > +	unsigned long descriptor_size,
> > +	u32 descriptor_version,
> > +	efi_memory_desc_t *virtual_map)
> > +{
> > +	efi_status_t status;
> > +
> > +	efi_call_phys_prelog();
> > +	status = lin2win4((void *)efi_phys.set_virtual_address_map,
> > +			  (u64)memory_map_size, (u64)descriptor_size,
> > +			  (u64)descriptor_version, (u64)virtual_map);
> > +	efi_call_phys_epilog();
> > +	return status;
> > +}
> 
> So you still have this piece of code which makes a kernel using
> efi not compatible with kexec.  But you are still supporting a physical
> call mode for efi.  If you are going to do this can we please just
> remove the hacks that make the EFI physical call mode early boot only
> and just always use that mode.  Depending on weird call once functions
> like efi_set_virtual_address_map makes me very uncomfortable.

The kexec issue is solved as that of IA-64. The EFI runtime code and
data memory area is mapped with identity mapping, so they will have same
virtual address across kexec. The memory mapped IO memory area used by
EFI runtime services is mapped with fixmap, so they will have same
virtual address across kexec too. And the efi_set_virtual_address_map
runtime service function will be skipped in the kexeced kernel (set to
"nop" in /sbin/kexec). So the kexeced kernel can use the virtual mode of
EFI from kernel bootstrap on.

Best Regards,
Huang Ying
