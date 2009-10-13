Return-Path: <linux-kernel-owner+w=401wt.eu-S933847AbZJMSE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933847AbZJMSE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 14:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760830AbZJMSE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 14:04:26 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:47315 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760829AbZJMSEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 14:04:25 -0400
X-Trace: 270035066/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.56.29/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.56.29
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AicFACte1EpPRTgd/2dsb2JhbACBUtdkhC0E
X-IronPort-AV: E=Sophos;i="4.44,551,1249254000"; 
   d="scan'208";a="270035066"
Date: Tue, 13 Oct 2009 19:03:31 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andi Kleen <andi@firstfloor.org>
cc: Wu Fengguang <fengguang.wu@intel.com>, Izik Eidus <ieidus@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwpoison: fix oops on ksm pages
In-Reply-To: <20091013154356.GA2127@basil.fritz.box>
Message-ID: <Pine.LNX.4.64.0910131855290.6481@sister.anvils>
References: <Pine.LNX.4.64.0910131451280.4698@sister.anvils>
 <20091013154356.GA2127@basil.fritz.box>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009, Andi Kleen wrote:
> On Tue, Oct 13, 2009 at 03:02:11PM +0100, Hugh Dickins wrote:
> > Memory failure on a KSM page currently oopses on its NULL anon_vma in
> > page_lock_anon_vma(): that may not be much worse than the consequence
> > of ignoring it, but it is better to be consistent with how ZERO_PAGE
> > and hugetlb pages and other awkward cases are treated.  Just skip it.
> 
> Thanks, Hugh. I'm curious: did this come out of code review or
> did you actually run into that?

Just out of code review: well, that's too fancy a name for it, I merely
remembered that I hadn't looked at ksm/hwpoison interoperabilty, so did
so just now.  After looking at the code, I did then try MADV_HWPOISON on
a MADV_MERGEABLE area, to check that the problem and the fix were real.

Hugh
