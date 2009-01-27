Return-Path: <linux-kernel-owner+w=401wt.eu-S1753564AbZA0XcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbZA0XcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 18:32:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbZA0XcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 18:32:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44375 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbZA0XcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 18:32:13 -0500
Date: Wed, 28 Jan 2009 00:31:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [mingo@elte.hu: [git pull] headers_check fixes]
Message-ID: <20090127233159.GA26403@elte.hu>
References: <20090127222825.GA27097@elte.hu> <alpine.LFD.2.00.0901271441280.3123@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901271441280.3123@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> There are parts of the patches that look fine, like moving __KERNEL__ 
> checks around a bit, and changing <asm/types.h> to <linux/types.h> which 
> looks correct _both_ in a kernel and in a user context, but I dislike 
> the stupid parts.

okay - that was the general thinking and this went through a few 
iterations already - not enough it appears. The CONFIG_* thing was 
something that looked somewhat dubious to me too - changing it to those 
random __foo symbols didnt seem like an improvement.

Jaswider, would you mind re-doing the tree filtering out the CONFIG_* 
changes? I'll go over the end result once more to make sure it has no 
changes that make the code look worse.

I still think what i expressed elsewhere in these threads on lkml: 
'exporting' 75,000 lines of random kernel headers to user-space is really 
stretching the term - kernel-space is unaware of it in 90% of the cases. 
"spilling our guts to user-space" would be a more fair description.

It would be much better if we exported _much_ less and reduced our 
cross-section to user-space. Also, the include/linux/Kbuild rules are all 
but transparent: it would also be nice if whatever we exported was be 
visible straight in the header itself, to make it obvious to people who 
modify/extend those files that those definitions are going to be exported 
to user-space.

Some __user_export tag on structures perhaps? I have no good ideas here - 
#ifdefs are ugly and tags obscure the purity of the code.

	Ingo
