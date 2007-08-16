Return-Path: <linux-kernel-owner+w=401wt.eu-S1764480AbXHPIAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764480AbXHPIAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 04:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757824AbXHPIAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 04:00:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:5400 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757731AbXHPIAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 04:00:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,270,1183359600"; 
   d="scan'208";a="118144484"
Subject: Re: [PATCH 0/3] x86_64 EFI runtime service support
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <46C38AA8.5040202@zytor.com>
References: <1186990219.22431.37.camel@caritas-dev.intel.com>
	 <20070815161642.1bfbbe9c.akpm@linux-foundation.org>
	 <46C38AA8.5040202@zytor.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 16 Aug 2007 16:00:48 +0800
Message-Id: <1187251248.15063.12.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 16 Aug 2007 08:00:19.0785 (UTC) FILETIME=[7D637390:01C7DFDB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-16 at 07:22 +0800, H. Peter Anvin wrote:
> Andrew Morton wrote:
> > On Mon, 13 Aug 2007 15:30:19 +0800
> > "Huang, Ying" <ying.huang@intel.com> wrote:
> >
> >> Following sets of patches add EFI/UEFI (Unified Extensible Firmware
> >> Interface) runtime services support to x86_64 architecture.
> >
> > OK, we have a major trainwreck when these patches meet Peter's
> > get-newsetup.patch.
> >
> > I'm halfway into fixing it when I see this.  You have:
> >
> >  #define SYS_DESC_TABLE (*(struct sys_desc_table_struct*)(PARAM
> +0xa0))
> > +#define EFI_LOADER_SIG ((unsigned char *)(PARAM+0x1c0))
> > +#define EFI_MEMDESC_SIZE (*((unsigned int *) (PARAM+0x1c4)))
> > +#define EFI_MEMDESC_VERSION (*((unsigned int *) (PARAM+0x1c8)))
> > +#define EFI_MEMMAP_SIZE (*((unsigned int *) (PARAM+0x1cc)))
> > +#define EFI_MEMMAP (*((unsigned long *)(PARAM+0x1d0)))
> > +#define EFI_SYSTAB (*((unsigned long *)(PARAM+0x1d8)))
> >  #define MOUNT_ROOT_RDONLY (*(unsigned short *) (PARAM+0x1F2))
> >
> 
> Please, no more of these kinds of macros.  We have already had
> collisions.  Go ahead and redefine the efi_info structure if
> necessary,

I missed the git-newsetup.patch. I will change EFI runtime service patch
according to the git-newsetup.patch.

One question:

The boot_params.efi_info.efi_systab is defined as u32. But it should be
u64 on x86_64, because it comes from firmware and is not controlled by
bootloader. But, changing it from u32 to u64 will break current i386 EFI
support, should we change it and fix the i386 EFI bootloader?

Best Regards,
Huang Ying
