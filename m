Return-Path: <linux-kernel-owner+w=401wt.eu-S1755687AbZHUSlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687AbZHUSlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 14:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753103AbZHUSlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 14:41:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40631 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841AbZHUSlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 14:41:16 -0400
Date: Fri, 21 Aug 2009 20:41:12 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.com>,
       Andi Kleen <andi@firstfloor.org>, Wu Fengguang <fengguang.wu@intel.com>,
       Izik Eidus <ieidus@redhat.com>, Chris Wright <chrisw@redhat.com>,
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
Message-ID: <20090821184112.GB18623@basil.fritz.box>
References: <Pine.LNX.4.64.0908211912330.14259@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0908211912330.14259@sister.anvils>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 21, 2009 at 07:30:15PM +0100, Hugh Dickins wrote:
> linux-next is now sporting MADV_HWPOISON at 12, which would have a very
> nasty effect on KSM if you had CONFIG_MEMORY_FAILURE=y with CONFIG_KSM=y.
> Shift MADV_MERGEABLE and MADV_UNMERGEABLE down two - two to reduce the
> confusion if old and new userspace and kernel are mismatched.
> 
> Personally I'd prefer the MADV_HWPOISON testing feature to shift; but
> linux-next comes first in the mmotm lineup, and I can't be sure that
> madvise KSM already has more users than there are HWPOISON testers:
> so unless Andi is happy to shift MADV_HWPOISON, mmotm needs this.

Thanks for catching.

Shifting is fine, but I would prefer then if it was to some
value that is not reused (like 100) so that I can probe for it 
in the test programs.

-Andi
