Return-Path: <linux-kernel-owner+w=401wt.eu-S1756163AbZJHJEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbZJHJEy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 05:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755978AbZJHJEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 05:04:54 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:36082 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755859AbZJHJEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 05:04:53 -0400
X-Trace: 268286158/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.10.164/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.10.164
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq0EAN9HzUpPRQqk/2dsb2JhbACBUtcdhCoE
X-IronPort-AV: E=Sophos;i="4.44,524,1249254000"; 
   d="scan'208";a="268286158"
Date: Thu, 8 Oct 2009 10:04:05 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Brian Marete <bgmarete@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG: bad page state in process (In version 2.6.31.2)
In-Reply-To: <6dd519ae0910071805y6000f563y422c42f43bc5e6a2@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0910080958520.25169@sister.anvils>
References: <6dd519ae0910071634q329239f2n360c8a54fcb81a26@mail.gmail.com> 
 <6dd519ae0910071710q6d4acealb749966a86fb860b@mail.gmail.com>
 <6dd519ae0910071805y6000f563y422c42f43bc5e6a2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Oct 2009, Brian Marete wrote:
> On Thu, Oct 8, 2009 at 3:10 AM, Brian Marete <bgmarete@gmail.com> wrote:
> > On Thu, Oct 8, 2009 at 2:34 AM, Brian Marete <bgmarete@gmail.com> wrote:
> >>
> >> Just found the BUG back-trace pasted below in my kernel logs.
> 
> Rebooted the machine and the same BUG manifests. See the trace below:
> 
> (Also, run memtest86 just in case I have bad memory.)
> 
> [  726.890990] BUG: Bad page state in process tracker-indexer  pfn:77541
> [  726.890997] page:c47eb820 flags:80000000 count:0 mapcount:0
> mapping:00000001 index:0

                 ^ for some reason that page->mapping got a 1 in it.

> [  726.891002] Pid: 9758, comm: tracker-indexer Tainted: P           2.6.31.2 #1

                   but you're using a Proprietary module   ^

It's great that you can reproduce this case easily, but please try
without Proprietary modules loaded - they're often the origin, and
we're unable to debug them.

Thanks,
Hugh
