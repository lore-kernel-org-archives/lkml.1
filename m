Return-Path: <linux-kernel-owner+w=401wt.eu-S1756999AbZFYHL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999AbZFYHL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 03:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbZFYHLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 03:11:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:47802 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbZFYHLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 03:11:47 -0400
Subject: Re: [PATCH v2] IA64 Compilation Error Fix for Intel IOMMU Identity
 Mapping Support
From: David Woodhouse <dwmw2@infradead.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: fenghua.yu@intel.com, chrisw@redhat.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, tony.luck@intel.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       linux-ia64@vger.kernel.org
In-Reply-To: <20090625134827W.fujita.tomonori@lab.ntt.co.jp>
References: <20090625003841.GA12226@linux-os.sc.intel.com>
	 <20090625095643F.fujita.tomonori@lab.ntt.co.jp>
	 <20090625041605.GA9330@linux-os.sc.intel.com>
	 <20090625134827W.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Date: Thu, 25 Jun 2009 08:11:26 +0100
Message-Id: <1245913886.17089.91.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-25 at 13:48 +0900, FUJITA Tomonori wrote:
> This patch is really ugly; adds another ifdef and VT-D specific code
> to the generic place (arch/x86/kernel/pci-dma.c).
> 
> However, I guess that we need to live with this for now since this
> fixes the build error.

It raises the question: Why are we using firmware-specific interfaces to
list the available memory -- can't we get that from somewhere _generic_?

The less we tie our code to these crappy BIOS, EFI and ACPI interfaces,
the better off we'll be.

> Another complaint from me is that, IIRC, the patch causes this build
> error was posted was posted first during the merge window (18 June)
> and merged few days later without properly reviewed (or compile
> tested).

I apologise for that. I got to it rather late, just as I was reviewing
my outstanding code for Linus to pull. It _had_ been reviewed though --
this was the second incarnation of the patch, after review.

I didn't include it in my original pull request, and instead let it sit
in linux-next for a day (which is not long, I know, but better than
nothing). I then spent that day testing it myself, and tracking down a
bug in it.

I sent the fixed version to Linus at the end of the day -- I _thought_
I would have been told of any IA64 build failures in linux-next by then,
even if the original hadn't been tested on IA64 -- evidently I was
wrong.

I really must set myself up an IA64 cross-compiler. Every time I've
looked at that so far I've got distracted into the whole "why is
GCC/glibc build so incestuously broken" quagmire -- but I only need gcc,
so I'll steel myself to ignore the braindamage and just build a simple
compiler without glibc support.

Better still would be if I could find some IA64 hardware with this
IOMMU. Would kind of help with maintenance...

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

