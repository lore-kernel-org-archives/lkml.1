Return-Path: <linux-kernel-owner+w=401wt.eu-S1751820AbXCTQzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbXCTQzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 12:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbXCTQzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 12:55:16 -0400
Received: from smtp.osdl.org ([65.172.181.24]:47539 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820AbXCTQzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 12:55:14 -0400
Date: Tue, 20 Mar 2007 09:52:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       David Miller <davem@davemloft.net>,
       virtualization@lists.linux-foundation.org, jbeulich@novell.com,
       jeremy@goop.org, xen-devel@lists.xensource.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, chrisw@sous-sol.org,
       virtualization@lists.osdl.org, anthony@codemonkey.ws,
       akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [patch 13/26] Xen-paravirt_ops: Consistently wrap paravirt ops
 callsites to make them patchable
In-Reply-To: <20070320174159.GA4286@bingen.suse.de>
Message-ID: <Pine.LNX.4.64.0703200947501.6730@woody.linux-foundation.org>
References: <20070319.120854.30182994.davem@davemloft.net>
 <20070319.204712.118947830.davem@davemloft.net> <m13b40wnrb.fsf@ebiederm.dsl.xmission.com>
 <200703201428.50564.ak@suse.de> <m1ircvswzz.fsf@ebiederm.dsl.xmission.com>
 <20070320174159.GA4286@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 20 Mar 2007, Andi Kleen wrote:
> 
> No, me and Jan fixed all reported bugs as far as I know.

No you did not. You didn't fix the ones I reported. Which is why it got 
removed, and will not get added back until there is another maintainer.

The ones I reported were all about trusting the stack contents implicitly, 
and assuming that the unwind info was there and valid. Using things like 
"__get_user()" didn't fix it, because if a WARN_ON() happened while we 
held the mm semaphore and the unwind info was bogus, it would take a 
page-fault and deadlock.

Those kinds of things are not acceptable for debugging output. If I cannot 
use WARN_ON() because I hold the MM lock and I'm afraid there might be 
kernel corruption, then something is *wrong*!

And I told you guys this. Over *months*. And you ignored me. You told me 
everything was fine. Each time, somebody else ended up reporting a hang 
where the unwinder was at fault. And since I couldn't trust the 
maintainers to fix it, removing the broken feature that only caused more 
problems than it fixed was the only option.

And you clearly *still* haven't accepted the fact that the code was buggy. 

Does anybody wonder why I wouldn't merge it back?

		Linus
