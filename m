Return-Path: <linux-kernel-owner+w=401wt.eu-S1761908AbXHVKSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761908AbXHVKSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 06:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757339AbXHVKSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 06:18:06 -0400
Received: from mx1.suse.de ([195.135.220.2]:56704 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412AbXHVKSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 06:18:05 -0400
Date: Wed, 22 Aug 2007 13:11:55 +0200
From: Andi Kleen <ak@suse.de>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <ak@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org, Aaron Durbin <adurbin@google.com>
Subject: Re: [PATCH 0/3] x86_64 EFI runtime service support
Message-ID: <20070822111155.GP32640@bingen.suse.de>
References: <1187313920.28497.1.camel@caritas-dev.intel.com> <46C5C8C4.4060407@zytor.com> <1187580031.27947.67.camel@caritas-dev.intel.com> <46C9CB89.7020603@zytor.com> <20070821113310.GF32640@bingen.suse.de> <46CAC168.7090102@zytor.com> <20070821114548.GI32640@bingen.suse.de> <86802c440708211658j1fb2a8caj41e1bb8bffa4baf4@mail.gmail.com> <20070822012216.GN32640@bingen.suse.de> <86802c440708212343x3b1438d3m4bbbfbd04db1f1ef@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440708212343x3b1438d3m4bbbfbd04db1f1ef@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 11:43:38PM -0700, Yinghai Lu wrote:
> On 8/21/07, Andi Kleen <ak@suse.de> wrote:
> > > current LinuxBIOS's path: the elfboot in LinuxBIOS will prepare the
> > > e820 table, and jump to startup_32 in kernel. is that not good and
> > > simple?
> >
> > The problem is that the zero page cannot be changed at all in this
> > setup. Or rather it can be only changed by breaking LinuxBios.
> 
> So you want to construct e820 table in x86_boot_params from LinuxBIOS
> memmap in head64.c?

The short term fix is probably to just add a version number to
the zero page and make sure new changes only add stuff to the
end and the kernel has reasonable compat code for old versions.

Then LinuxBIOS would need to be changed to supply that version number.

Perhaps it could also include a checksum just to detect old BIOS
that don't supply a version number.

Long term I'm not sure. Adding LinuxBIOS specific tables also doesn't
sound very attractive.

-Andi
