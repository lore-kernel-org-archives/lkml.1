Return-Path: <linux-kernel-owner+w=401wt.eu-S1754026AbYGGHma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbYGGHma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 03:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929AbYGGHmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 03:42:22 -0400
Received: from sh.osrg.net ([192.16.179.4]:34174 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbYGGHmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 03:42:21 -0400
Date: Mon, 7 Jul 2008 16:40:26 +0900
To: mingo@elte.hu
Cc: joerg.roedel@amd.com, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, robert.richter@amd.com, rjw@sisk.pl
Subject: Re: [PATCH 0/6] AMD IOMMU updates
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080704095213.GB22658@elte.hu>
References: <1215106511-12915-1-git-send-email-joerg.roedel@amd.com>
	<20080704095213.GB22658@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080707164023T.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jul 2008 11:52:13 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > Hi,
> > 
> > this series of patches contain some updates to the AMD IOMMU code 
> > currently in tip/master. The updates address some objections discussed 
> > on the initial patches and also contain optimization and small code 
> > cleanup. The code with these updates is tested on real hardware under 
> > load and showed no problems.
> 
> applied to tip/x86/amd-iommu and pushed that topic out, thanks Joerg.
> 
> also, i've integrated it into tip/master as well (will push that out
> after some testing).
> 
> The IOMMU driver code seems to be getting into good shape, so i've also 
> added the topic to auto-x86-next, which means it will go into linux-next 
> on the next iteration (in 1-2 days). Does anyone see any remaining 
> problems?

Not a showstopper but I like to see the cleanups of the kernel
parameters, as I said before. The AMD IOMMU has two parameters,
amd_iommu=isolate and amd_iommu_size=32M|64M|128M|256M|512M|1G

The former might be useful for the VT-d. The latter is useful for most
of the IOMMU drivers. So I think that it would be better to make them
common parameters.

And if we can change the existing kernel parameters, I think that it
would be better to convert some of the x86 IOMMU parameters to common
parameters.


BTW, "[PATCH 4/6] AMD IOMMU: honor iommu=off instead of amd_iommu=off"
patch in auto-x86-next needs update the kernel parameter.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] AMD IOMMU: fix kernel parameter

amd_iommu=off was replaced with a common parameter, iommu=off.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 Documentation/kernel-parameters.txt |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index cd98762..1a6bb46 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -274,7 +274,6 @@ and is between 256 and 4096 characters. It is defined in the file
 	amd_iommu=	[HW,X86-84]
 			Pass parameters to the AMD IOMMU driver in the system.
 			Possible values are:
-			off     - disable the driver for AMD IOMMU
 			isolate - enable device isolation (each device, as far
 			          as possible, will get its own protection
 			          domain)
-- 
1.5.5.GIT

