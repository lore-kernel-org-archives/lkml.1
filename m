Return-Path: <linux-kernel-owner+w=401wt.eu-S1755313AbXHSWZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbXHSWZi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 18:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbXHSWZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 18:25:30 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:60467 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbXHSWZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 18:25:29 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86_64 EFI runtime service support
References: <1186990219.22431.37.camel@caritas-dev.intel.com>
	<20070815161642.1bfbbe9c.akpm@linux-foundation.org>
	<46C38AA8.5040202@zytor.com>
	<1187251248.15063.12.camel@caritas-dev.intel.com>
Date: Sun, 19 Aug 2007 16:25:08 -0600
In-Reply-To: <1187251248.15063.12.camel@caritas-dev.intel.com> (Ying Huang's
	message of "Thu, 16 Aug 2007 16:00:48 +0800")
Message-ID: <m11wdzrwl7.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Huang, Ying" <ying.huang@intel.com> writes:

> On Thu, 2007-08-16 at 07:22 +0800, H. Peter Anvin wrote:
>> Andrew Morton wrote:
>> > On Mon, 13 Aug 2007 15:30:19 +0800
>> > "Huang, Ying" <ying.huang@intel.com> wrote:
>> >
>> >> Following sets of patches add EFI/UEFI (Unified Extensible Firmware
>> >> Interface) runtime services support to x86_64 architecture.
>> >
>> > OK, we have a major trainwreck when these patches meet Peter's
>> > get-newsetup.patch.
>> >
>> > I'm halfway into fixing it when I see this.  You have:
>> >
>> >  #define SYS_DESC_TABLE (*(struct sys_desc_table_struct*)(PARAM
>> +0xa0))
>> > +#define EFI_LOADER_SIG ((unsigned char *)(PARAM+0x1c0))
>> > +#define EFI_MEMDESC_SIZE (*((unsigned int *) (PARAM+0x1c4)))
>> > +#define EFI_MEMDESC_VERSION (*((unsigned int *) (PARAM+0x1c8)))
>> > +#define EFI_MEMMAP_SIZE (*((unsigned int *) (PARAM+0x1cc)))
>> > +#define EFI_MEMMAP (*((unsigned long *)(PARAM+0x1d0)))
>> > +#define EFI_SYSTAB (*((unsigned long *)(PARAM+0x1d8)))
>> >  #define MOUNT_ROOT_RDONLY (*(unsigned short *) (PARAM+0x1F2))
>> >
>> 
>> Please, no more of these kinds of macros.  We have already had
>> collisions.  Go ahead and redefine the efi_info structure if
>> necessary,
>
> according to the git-newsetup.patch.
>
> One question:
>
> The boot_params.efi_info.efi_systab is defined as u32. But it should be
> u64 on x86_64, because it comes from firmware and is not controlled by
> bootloader. But, changing it from u32 to u64 will break current i386 EFI
> support, should we change it and fix the i386 EFI bootloader?

Be very very very  careful how you talk about this.

I have seen machines in the wild a 64bit processor and a 32bit EFI.
So this is not a linux architecture issue, or a cpu architecture
issue.  This is an EFI architecture issue.

This is an issue of do you have a 32bit or a 64bit EFI implementation
on your machine.  Which is very different.

We should be able to boot a 32bit kernel with a 64bit EFI.
We should be able to boot a 64bit kernel with a 32bit EFI.

Maybe our response is to ignore the information from elilo so
we don't attempt EFI runtime calls but the boot information should
be unambiguous.

So we need to be able to look at the data and answer these questions.
- Is EFI present?
- Is EFI 32bit?
- Is EFI 64bit?

Eric
