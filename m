Return-Path: <linux-kernel-owner+w=401wt.eu-S1752552AbXHTFOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbXHTFOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 01:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750948AbXHTFOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 01:14:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:32087 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbXHTFOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 01:14:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,283,1183359600"; 
   d="scan'208";a="265342948"
Subject: Re: [PATCH 0/3] x86_64 EFI runtime service support
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <m11wdzrwl7.fsf@ebiederm.dsl.xmission.com>
References: <1186990219.22431.37.camel@caritas-dev.intel.com>
	 <20070815161642.1bfbbe9c.akpm@linux-foundation.org>
	 <46C38AA8.5040202@zytor.com>
	 <1187251248.15063.12.camel@caritas-dev.intel.com>
	 <m11wdzrwl7.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 20 Aug 2007 13:14:47 +0800
Message-Id: <1187586887.27947.76.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 20 Aug 2007 05:14:09.0951 (UTC) FILETIME=[F08E82F0:01C7E2E8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-08-19 at 16:25 -0600, Eric W. Biederman wrote:
> "Huang, Ying" <ying.huang@intel.com> writes:
> >> > +#define EFI_LOADER_SIG ((unsigned char *)(PARAM+0x1c0))
> >> > +#define EFI_MEMDESC_SIZE (*((unsigned int *) (PARAM+0x1c4)))
> >> > +#define EFI_MEMDESC_VERSION (*((unsigned int *) (PARAM+0x1c8)))
> >> > +#define EFI_MEMMAP_SIZE (*((unsigned int *) (PARAM+0x1cc)))
> >> > +#define EFI_MEMMAP (*((unsigned long *)(PARAM+0x1d0)))
> >> > +#define EFI_SYSTAB (*((unsigned long *)(PARAM+0x1d8)))
> >> >  #define MOUNT_ROOT_RDONLY (*(unsigned short *) (PARAM+0x1F2))
> Be very very very  careful how you talk about this.
> 
> I have seen machines in the wild a 64bit processor and a 32bit EFI.
> So this is not a linux architecture issue, or a cpu architecture
> issue.  This is an EFI architecture issue.
> 
> This is an issue of do you have a 32bit or a 64bit EFI implementation
> on your machine.  Which is very different.
> 
> We should be able to boot a 32bit kernel with a 64bit EFI.
> We should be able to boot a 64bit kernel with a 32bit EFI.
> 
> Maybe our response is to ignore the information from elilo so
> we don't attempt EFI runtime calls but the boot information should
> be unambiguous.
> 
> So we need to be able to look at the data and answer these questions.
> - Is EFI present?
> - Is EFI 32bit?
> - Is EFI 64bit?

Yes, it is necessary to distinguish these situations. I think the
EFI_LOADER_SIG defined above can be used for that. For example the
following signature can be defined:

32-bit EFI	EL32
64-bit EFI	EL64

All other values will be treated as no EFI present.

If struct setup_data proposed by H. Peter Anvin is used for EFI
information passed from bootloader, two "type" can be defined for 32-bit
EFI and 64-bit EFI, such as SETUP_DATA_TYPE_EFI_32 and
SETUP_DATA_TYPE_EFI64. If either type is not presented in "linked list
of struct setup_data", it is considered that EFI is not present.

Best Regards,
Huang Ying
