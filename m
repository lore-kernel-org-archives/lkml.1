Return-Path: <linux-kernel-owner+w=401wt.eu-S1752030AbXDWXaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbXDWXaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 19:30:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbXDWXaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 19:30:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030AbXDWXaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 19:30:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
X-Fcc: ~/Mail/linus
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH 03/25] xen: Add nosegneg capability to the vsyscall page notes
In-Reply-To: Jeremy Fitzhardinge's message of  Monday, 23 April 2007 14:56:41 -0700 <20070423215709.802499615@goop.org>
X-Windows: power tools for power fools.
Message-Id: <20070423232941.476FB1801A4@magilla.sf.frob.com>
Date: Mon, 23 Apr 2007 16:29:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> + * It should contain:
> + *	hwcap 0 nosegneg
> + * to match the mapping of bit to name that we give here.

This needs to be "hwcap 0 nosegneg" to match:

> +NOTE_KERNELCAP_BEGIN(1, 2)
> +NOTE_KERNELCAP(1, "nosegneg")
> +NOTE_KERNELCAP_END

The actual bits you are using should be fine.  (You're intentionally
skipping bit 0 to work around hold glibc bugs, which you might want to add
to the comments.  Also a comment or perhaps using 1<<1 syntax would make it
more clear that "2" is the bit mask containing bit 1 and that's why it has
to be 2, and not because of some other magical property of 2.)  But if
kernel packagers don't write the matching bit number in their ld.so.conf.d
files, then ld.so.cache lookups won't work right.


Thanks,
Roland
