Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbXJIIxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbXJIIxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 04:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751126AbXJIIx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 04:53:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:48258 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbXJIIx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 04:53:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,247,1188802800"; 
   d="scan'208";a="295145961"
Subject: Re: [PATCH -mm -v4 1/3] i386/x86_64 boot: setup data
From: "Huang, Ying" <ying.huang@intel.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: linux-mm@kvack.org, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200710090206.22383.nickpiggin@yahoo.com.au>
References: <1191912010.9719.18.camel@caritas-dev.intel.com>
	 <200710090125.27263.nickpiggin@yahoo.com.au>
	 <1191918139.9719.47.camel@caritas-dev.intel.com>
	 <200710090206.22383.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 09 Oct 2007 16:55:23 +0800
Message-Id: <1191920123.9719.71.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 09 Oct 2007 08:53:16.0402 (UTC) FILETIME=[D51B3D20:01C80A51]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-09 at 02:06 +1000, Nick Piggin wrote:
> On Tuesday 09 October 2007 18:22, Huang, Ying wrote:
> > On Tue, 2007-10-09 at 01:25 +1000, Nick Piggin wrote:
> > > On Tuesday 09 October 2007 16:40, Huang, Ying wrote:
> > > > +unsigned long copy_from_phys(void *to, unsigned long from_phys,
> > > > +			     unsigned long n)
> 
> > > I suppose that's not unreasonable to put in mm/memory.c, although
> > > it's not really considered a problem to do this kind of stuff in
> > > a low level arch file...
> > >
> > > You have no kernel virtual mapping for the source data?
> >
> > On 32-bit platform such as i386. Some memory zones have no kernel
> > virtual mapping (highmem region etc).
> 
> I'm just wondering whether you really need to access highmem in
> boot code...

Because the zero page (boot_parameters) of i386 boot protocol has 4k
limitation, a linked list style boot parameter passing mechanism (struct
setup_data) is proposed by Peter Anvin. The linked list is provided by
bootloader, so it is possible to be in highmem region.

> 
> > So I think this may be useful as a 
> > universal way to access physical memory. But it can be more efficient to
> > implement it in arch file for some arch. Should this implementation be
> > used as a fall back implementation with attribute "weak"?
> 
> Definitely on most architectures it would just amount to
> memcpy(dst, __va(phys), n);, right? However I don't know if

Yes.

> it's worth the trouble of overriding it unless there is some
> non-__init user of it.

To support debugging and kexec, the boot parameters include the linked
list above are exported into sysfs. This function is used there too. The
patch is the No. 2 of the series.

Best Regards,
Huang Ying
