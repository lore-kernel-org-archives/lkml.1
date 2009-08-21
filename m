Return-Path: <linux-kernel-owner+w=401wt.eu-S1755666AbZHUTYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666AbZHUTYa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 15:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbZHUTY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 15:24:29 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:41154 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751175AbZHUTY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 15:24:28 -0400
X-Trace: 247292591/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.31.155/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.31.155
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqIEAC6RjkpPRR+b/2dsb2JhbACBU9UihBoF
X-IronPort-AV: E=Sophos;i="4.44,252,1249254000"; 
   d="scan'208";a="247292591"
Date: Fri, 21 Aug 2009 20:23:51 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andi Kleen <andi@firstfloor.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, Izik Eidus <ieidus@redhat.com>,
       Chris Wright <chrisw@redhat.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Ralf Baechle <ralf@linux-mips.org>, Kyle McMartin <kyle@mcmartin.ca>,
       Helge Deller <deller@gmx.de>, Chris Zankel <chris@zankel.net>,
       Rik van RIel <riel@redhat.com>, Balbir Singh <balbir@in.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Avi Kivity <avi@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH mmotm] ksm: antidote to MADV_MERGEABLE HWPOISON
In-Reply-To: <20090821184112.GB18623@basil.fritz.box>
Message-ID: <Pine.LNX.4.64.0908212003190.24376@sister.anvils>
References: <Pine.LNX.4.64.0908211912330.14259@sister.anvils>
 <20090821184112.GB18623@basil.fritz.box>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Aug 2009, Andi Kleen wrote:
> On Fri, Aug 21, 2009 at 07:30:15PM +0100, Hugh Dickins wrote:
> > linux-next is now sporting MADV_HWPOISON at 12, which would have a very
> > nasty effect on KSM if you had CONFIG_MEMORY_FAILURE=y with CONFIG_KSM=y.
> > Shift MADV_MERGEABLE and MADV_UNMERGEABLE down two - two to reduce the
> > confusion if old and new userspace and kernel are mismatched.
> > 
> > Personally I'd prefer the MADV_HWPOISON testing feature to shift; but
> > linux-next comes first in the mmotm lineup, and I can't be sure that
> > madvise KSM already has more users than there are HWPOISON testers:
> > so unless Andi is happy to shift MADV_HWPOISON, mmotm needs this.
> 
> Thanks for catching.
> 
> Shifting is fine, but I would prefer then if it was to some
> value that is not reused (like 100) so that I can probe for it 
> in the test programs.

Thanks a lot for conceding so generously, Andi.

Okay, let's forget that first patch I posted: here's its replacement,
fix to linux-next.patch in mmotm, but you'll put into your tree to be
picked up by linux-next in due course?  Thanks again.  (patch ends up
with the 100 line in between the 11 line and the 12 line, but doesn't
matter, it'll be easier to tidy that up with another patch afterwards.)


[PATCH] hwpoison: shift MADV_HWPOISON to 100

mm assigns KSM's MADV_MERGEABLE to 12: shift MADV_HWPOISON from 12 to 100,
out of the way so that poisoning test programs can safely probe for it.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---

 include/asm-generic/mman-common.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- next/include/asm-generic/mman-common.h	2009-08-21 19:51:15.000000000 +0100
+++ mmotm/include/asm-generic/mman-common.h	2009-08-21 19:53:21.000000000 +0100
@@ -34,7 +34,8 @@
 #define MADV_REMOVE	9		/* remove these pages & resources */
 #define MADV_DONTFORK	10		/* don't inherit across fork */
 #define MADV_DOFORK	11		/* do inherit across fork */
-#define MADV_HWPOISON	12		/* poison a page for testing */
+
+#define MADV_HWPOISON	100		/* poison a page for testing */
 
 /* compatibility flags */
 #define MAP_FILE	0
