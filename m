Return-Path: <linux-kernel-owner+w=401wt.eu-S1755726AbZEEPqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726AbZEEPqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 11:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbZEEPqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 11:46:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59765 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752505AbZEEPqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 11:46:00 -0400
Date: Tue, 5 May 2009 08:35:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: security@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>, Jake Edge <jake@lwn.net>,
       linux-security-module@vger.kernel.org, mingo@redhat.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Matt Mackall <mpm@selenic.com>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [Security] [PATCH] proc: avoid information leaks to non-privileged
 processes
In-Reply-To: <alpine.LFD.2.01.0905050755310.4983@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0905050833180.4983@localhost.localdomain>
References: <20090504125114.5e391564@chukar> <alpine.LFD.2.01.0905041159480.4983@localhost.localdomain> <20090504125124.0f469970@infradead.org> <m1vdogbows.fsf@fess.ebiederm.org> <alpine.LFD.2.01.0905041514350.4983@localhost.localdomain>
 <alpine.LFD.2.01.0905041646240.4983@localhost.localdomain> <m1r5z40yyr.fsf@fess.ebiederm.org> <alpine.LFD.2.01.0905050755310.4983@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 5 May 2009, Linus Torvalds wrote:
> 
> Note: the "pid + jiffies" is just meant to be a tiny tiny bit of noise. It 
> has no real meaning. It could be anything. I just picked the previous 
> seed, it's just that now we keep the state in between calls and that will 
> feed into the next result, and that should make all the difference.

Actually, thinking about it, we could/should probably just remove that 
tiny bit of noise.

After all, we get _real_ noise from the "keyptr->secret" thing. It's not 
updated all the time, but it's certainly updated often enough that nobody 
will ever see anything remotely guessable, I suspect.

Not that the "pid+jiffies" should hurt either, of course. It just doesn't 
really look meaningful, and only exists as a historical oddity that 
relates to the previous implementation of get_random_int().

			Linus
