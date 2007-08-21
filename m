Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbXHUEw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbXHUEw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 00:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbXHUEwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 00:52:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:28279 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027AbXHUEwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 00:52:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,287,1183359600"; 
   d="scan'208";a="119727985"
Subject: Re: [PATCH 0/3] x86_64 EFI runtime service support
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org, Aaron Durbin <adurbin@google.com>
In-Reply-To: <46CA61DD.4010102@zytor.com>
References: <1186990219.22431.37.camel@caritas-dev.intel.com>
	 <20070815154245.500c572c.akpm@linux-foundation.org>
	 <1187250664.15063.0.camel@caritas-dev.intel.com> <46C45B22.5090701@suse.de>
	 <1187313920.28497.1.camel@caritas-dev.intel.com>
	 <46C5C8C4.4060407@zytor.com>
	 <1187580031.27947.67.camel@caritas-dev.intel.com>
	 <46C9CB89.7020603@zytor.com>
	 <1187660689.20920.27.camel@caritas-dev.intel.com>
	 <46CA61DD.4010102@zytor.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 21 Aug 2007 12:53:23 +0800
Message-Id: <1187672003.20920.50.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 21 Aug 2007 04:52:43.0748 (UTC) FILETIME=[1C554240:01C7E3AF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-20 at 20:54 -0700, H. Peter Anvin wrote:
> Huang, Ying wrote:
> > 
> > I think the "next" field can be u32 instead of u64. Because the linked
> > list of struct setup_data is prepared by bootloader, which can control
> > the memory location.
> > 
> 
> That's making some pretty serious assumptions on future boot loaders and
> environments.

I think this assumption is reasonable. The range of u32 is big enough
for a boot protocol. Do we need to convert that to u128, when 128-bit
machine emerges?

I think there is another possible scheme. An array with variable length
element instead of a linked list can be used too. The type of element is
as follow:

struct setup_data {
	u32 type;
	u32 len;
	u8 data[0];
};

The next element is at (char *)&setup_data + len. The boot information
will be held in a block of memory. This makes initial memory mapping of
kernel more easily. And the memory location of boot information may need
to be kept in a limited range too.

> > As for the magic number in zero page, do you think it should be used
> > only by 16-bit kernel setup code?
> 
> Absolutely not.

If a old boot loader (not aware of magic number) is used to load the new
kernel image. The old boot loader will set the magic number to zero.
Does this mean that the new kernel image can not be booted by the old
boot loader.

Best Regards,
Huang Ying
