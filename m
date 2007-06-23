Return-Path: <linux-kernel-owner+w=401wt.eu-S1759082AbXFWRXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759082AbXFWRXi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 13:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbXFWRX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 13:23:29 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41983 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751191AbXFWRX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 13:23:29 -0400
Date: Sat, 23 Jun 2007 10:23:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Jay L. T. Cornwall" <jay@esuna.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc5: pdflush oops under heavy disk load
Message-Id: <20070623102318.1b4f3d24.akpm@linux-foundation.org>
In-Reply-To: <467D0EB0.9030100@esuna.co.uk>
References: <467B12CA.5060405@esuna.co.uk>
	<467BE118.4090308@redhat.com>
	<467BE4F1.7040308@esuna.co.uk>
	<467D0EB0.9030100@esuna.co.uk>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jun 2007 13:14:40 +0100 "Jay L.  T.  Cornwall" <jay@esuna.co.uk>
wrote:

> Jay L. T. Cornwall wrote:
> 
> > Already done. The filesystem came back as clean after the first oops,
> > but I forced a recheck with fsck to be safe - it found no problems.
> > 
> > This is reproducible on a clean filesystem.
> 
> Following up on this, I've now extracted another oops (at the bottom of
> this mail).
> 
> The common factor here seems to be the buffer_head circular list leading
> to invalid pointers in bh->b_this_page.
> 
> I'm beginning to suspect the Attansic L1 Gigabit Etherner driver (marked
> as EXPERIMENTAL in 2.6.22-rc5). I can't reproduce these panics on
> disk-to-disk copies or SCP across the localhost interface. However, SCP
> from a server onto either of two different HDDs hits these oopses fairly
> quickly.

That sounds like a good theory: you're getting easily-hit oopses in one of
the kernel's most-used codepaths which hasn't chanbged much in a long
time.  So Something Odd Has Happened.

> Is it even possible for the Ethernet driver to corrupt ext3 data
> structures, short of trashing memory?

I suppose so.

I'd suggest that you enable every kernel debugging feature you can get your
hands on (in the Kernel Hacking menu) and see if that turns anything up.

Failing that, if you can whack a different network card in that machine it
would help to firm or deny your suspicion.

