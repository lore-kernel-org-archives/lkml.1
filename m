Return-Path: <linux-kernel-owner+w=401wt.eu-S1755015Ab0AEQQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab0AEQQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 11:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674Ab0AEQQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 11:16:17 -0500
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:10279 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754659Ab0AEQQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 11:16:16 -0500
X-Trace: 321790948/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.28.176/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.28.176
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-Originating-Country: GB/UNITED KINGDOM
X-MUA: Alpine 2.00 (LSU 1167 2008-08-23)
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuwAAAf1QktPRRyw/2dsb2JhbAAI1A+EMAQ
X-IronPort-AV: E=Sophos;i="4.47,506,1257120000"; 
   d="scan'208";a="321790948"
Date: Tue, 5 Jan 2010 16:16:11 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: David Howells <dhowells@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Eric B Munson <ebmunson@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] nommu: reject MAP_HUGETLB
In-Reply-To: <17220.1262705013@redhat.com>
Message-ID: <alpine.LSU.2.00.1001051536420.13371@sister.anvils>
References: <alpine.LSU.2.00.1001051232530.1055@sister.anvils> <alpine.LSU.2.00.0912302009040.30390@sister.anvils> <20100104123858.GA5045@us.ibm.com> <17220.1262705013@redhat.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jan 2010, David Howells wrote:
> Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:
> 
> > We've agreed to restore the rejection of MAP_HUGETLB to nommu.
> > Mimic what happens with mmu when hugetlb is not configured in:
> > say -ENOSYS, but -EINVAL if MAP_ANONYMOUS was not given too.
> 
> On the other hand, why not just ignore the MAP_HUGETLB flag on NOMMU?

I don't care very much either way: originally it was ignored,
then it became an -ENOSYS when Al moved the MAP_HUGETLB handling
into util.c, then it was ignored again when I moved that back into
mmap.c and nommu.c, now this patch makes it -ENOSYS on nommu again
- which Eric preferred.

I'd say this patch is _correct_; but I'm perfectly happy to have
you NAK it, or Linus ignore it, with the observation that nommu is
more likely to want to cut bloat than to be pedantically correct -
pedantic because I'd expect the nommu mmap() to work fine with the
MAP_HUGETLB flag there, just wouldn't be using any huge pages.

Okay with me whichever way it goes.

Hugh
