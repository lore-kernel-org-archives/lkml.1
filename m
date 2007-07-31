Return-Path: <linux-kernel-owner+w=401wt.eu-S1752196AbXGaG6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196AbXGaG6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 02:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982AbXGaG60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 02:58:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:42641 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbXGaG6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 02:58:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,201,1183359600"; 
   d="scan'208";a="274665362"
Subject: Re: [PATCH 5/5] x86_64 EFI support -v3: EFI document
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: ak@suse.de, akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <m1r6mptcc8.fsf@ebiederm.dsl.xmission.com>
References: <1185851583.23149.30.camel@caritas-dev.intel.com>
	 <m1r6mptcc8.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 31 Jul 2007 14:58:07 +0800
Message-Id: <1185865087.23149.50.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 31 Jul 2007 06:58:17.0904 (UTC) FILETIME=[2C5D7B00:01C7D340]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-30 at 22:40 -0600, Eric W. Biederman wrote:
> "Huang, Ying" <ying.huang@intel.com> writes:
> 
> > This patch adds document for EFI x86_64 support. The boot parameters
> > added are documented in Documentation/i386/zero-page.txt. The setup
> > and operation guide of EFI based system is documented in
> > Documentation/x86_64/uefi.txt.
> >
> > Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> >
> > ---
> >
> >  i386/zero-page.txt |   18 ++++++++++++++----
> >  x86_64/uefi.txt    |   42 ++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 56 insertions(+), 4 deletions(-)
> >
> > Index: linux-2.6.23-rc1/Documentation/i386/zero-page.txt
> > ===================================================================
> > --- linux-2.6.23-rc1.orig/Documentation/i386/zero-page.txt 2007-07-30
> > 11:28:45.000000000 +0800
> > +++ linux-2.6.23-rc1/Documentation/i386/zero-page.txt 2007-07-30
> > 11:29:28.000000000 +0800
> > @@ -31,11 +31,11 @@
> >   0xb0 - 0x13f		Free. Add more parameters here if you really need them.
> >   0x140- 0x1be		EDID_INFO Video mode setup
> >  
> > -0x1c4	unsigned long	EFI system table pointer
> > -0x1c8	unsigned long	EFI memory descriptor size
> > -0x1cc	unsigned long	EFI memory descriptor version
> > +0x1c4	unsigned long	EFI system table pointer*
> > +0x1c8	unsigned long	EFI memory descriptor size*
> > +0x1cc	unsigned long	EFI memory descriptor version*
> >  0x1d0	unsigned long	EFI memory descriptor map pointer
> > -0x1d4	unsigned long	EFI memory descriptor map size
> > +0x1d4	unsigned long	EFI memory descriptor map size*
> >  0x1e0	unsigned long	ALT_MEM_K, alternative mem check, in Kb
> >  0x1e4	unsigned long	Scratch field for the kernel setup code
> >  0x1e8	char		number of entries in E820MAP (below)
> > @@ -87,3 +87,13 @@
> >  0x2d0 - 0xd00		E820MAP
> >  0xd00 - 0xeff		EDDBUF (edd.S) for disk signature read sector
> >  0xd00 - 0xeeb		EDDBUF (edd.S) for edd data
> > +
> > +Changes for x86_64 implementation:
> > +---------------------------------
> > +For alignment purposes, the following parameters are rearranged.
> > +
> > +0x1b8	unsigned long	EFI system table pointer
> > +0x1c0	unsigned long	EFI Loader signature
> > +0x1c4	unsigned long	EFI memory descriptor size
> > +0x1c8	unsigned long	EFI memory descriptor version
> > +0x1cc	unsigned long	EFI memory descriptor map size
> 
> Huh?  It is the same protocol.  Unless there are specific issues such
> as pointers being to small we should remain 100% the same for both
> arch/i386 and arch/x86_64   This variation looks like a serious
> bug.

The parameters are rearranged, because the pointer is too small. For
example, the EFI system table pointer is 8 bytes in x86_64, while it is
4 bytes in i386.

Best Regards,
Huang Ying
