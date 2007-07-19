Return-Path: <linux-kernel-owner+w=401wt.eu-S941087AbXGSSFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941087AbXGSSFn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 14:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759825AbXGSSFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 14:05:20 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41580 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936158AbXGSSFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 14:05:17 -0400
Date: Thu, 19 Jul 2007 11:04:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Krzysztof Halasa <khc@pm.waw.pl>
cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, ak@suse.de, adaplas@gmail.com,
       linux-fbdev-devel@lists.sourceforge.net, benh@kernel.crashing.org
Subject: Re: [git patches] two warning fixes
In-Reply-To: <m3r6n4bjgg.fsf@maximus.localdomain>
Message-ID: <alpine.LFD.0.999.0707191100480.27353@woody.linux-foundation.org>
References: <20070718235504.GA9601@havoc.gtf.org>
 <alpine.LFD.0.999.0707181834070.27353@woody.linux-foundation.org>
 <469ECD29.2010909@garzik.org> <m3r6n4bjgg.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 19 Jul 2007, Krzysztof Halasa wrote:
>
> Jeff Garzik <jeff@garzik.org> writes:
> 
> > My overall goal is killing useless warnings
> > that continually obscure real ones.
> 
> Precisely, the goal should be to make must_check (and similar things)
> warn only in real cases.

.. the problem with that mentality is that it's not how people work.

People shut up warnings by adding code.

Adding code tends to add bugs.

People don't generally think "maybe that warning was bogus".

More people *should* generally ask themselves: "was the warning worth it?" 
and then, if the answer is "no", they shouldn't add code, they should 
remove the thing that causes the warning in the first place.

For example, for compiler options, the correct thign is often to just say 
"that option was broken", and not use "-fsign-warning", for example. We've 
literally have had bugs *added* because people "fixed" a sign warning. 
More than once, in fact.

Every time you see a warning, you should ask yourself: is the warning 
interesting, correct and valid? And if it isn't all three, then the 
problem is whatever *causes* the warning, not the code itself.

			Linus
