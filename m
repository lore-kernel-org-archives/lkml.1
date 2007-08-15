Return-Path: <linux-kernel-owner+w=401wt.eu-S937175AbXHOXWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937175AbXHOXWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 19:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764019AbXHOXWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 19:22:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42861 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760206AbXHOXWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 19:22:30 -0400
Message-ID: <46C38AA8.5040202@zytor.com>
Date: Wed, 15 Aug 2007 16:22:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Huang, Ying" <ying.huang@intel.com>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86_64 EFI runtime service support
References: <1186990219.22431.37.camel@caritas-dev.intel.com> <20070815161642.1bfbbe9c.akpm@linux-foundation.org>
In-Reply-To: <20070815161642.1bfbbe9c.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 13 Aug 2007 15:30:19 +0800
> "Huang, Ying" <ying.huang@intel.com> wrote:
> 
>> Following sets of patches add EFI/UEFI (Unified Extensible Firmware
>> Interface) runtime services support to x86_64 architecture.
> 
> OK, we have a major trainwreck when these patches meet Peter's
> get-newsetup.patch.
> 
> I'm halfway into fixing it when I see this.  You have:
> 
>  #define SYS_DESC_TABLE (*(struct sys_desc_table_struct*)(PARAM+0xa0))
> +#define EFI_LOADER_SIG ((unsigned char *)(PARAM+0x1c0))
> +#define EFI_MEMDESC_SIZE (*((unsigned int *) (PARAM+0x1c4)))
> +#define EFI_MEMDESC_VERSION (*((unsigned int *) (PARAM+0x1c8)))
> +#define EFI_MEMMAP_SIZE (*((unsigned int *) (PARAM+0x1cc)))
> +#define EFI_MEMMAP (*((unsigned long *)(PARAM+0x1d0)))
> +#define EFI_SYSTAB (*((unsigned long *)(PARAM+0x1d8)))
>  #define MOUNT_ROOT_RDONLY (*(unsigned short *) (PARAM+0x1F2))
> 

Please, no more of these kinds of macros.  We have already had
collisions.  Go ahead and redefine the efi_info structure if necessary,
but use fixed types (u8, u16, u32, u64), *NOT* unsigned long which is
different between i386 and x86-64.  Also keep in mind the boot code
might in the future be compiled with a 16-bit compiler, so assuming
"unsigned int" == 32 bits is also a Bad Thing.

> 
> I'll give up and will drop the EFI patches.  I'd suggest that you work with
> Peter on getting these patches integrated.
> 

Thanks.

	-hpa
