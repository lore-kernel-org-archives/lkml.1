Return-Path: <linux-kernel-owner+w=401wt.eu-S1031127AbXEEDWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031127AbXEEDWm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 23:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031725AbXEEDWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 23:22:42 -0400
Received: from ozlabs.org ([203.10.76.45]:51421 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031127AbXEEDWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 23:22:41 -0400
Subject: Re: [PATCH] Revert "[PATCH] paravirt: Add startup infrastructure
	for paravirtualization"
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <m18xc4nfqf.fsf@ebiederm.dsl.xmission.com>
References: <m1mz0ku7je.fsf@ebiederm.dsl.xmission.com>
	 <1178280770.23670.61.camel@localhost.localdomain>
	 <m1y7k4smmo.fsf@ebiederm.dsl.xmission.com>
	 <1178289450.23670.100.camel@localhost.localdomain>
	 <m1lkg4sk3f.fsf@ebiederm.dsl.xmission.com>
	 <1178328168.12284.11.camel@localhost.localdomain>
	 <m18xc4nfqf.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Sat, 05 May 2007 13:22:21 +1000
Message-Id: <1178335341.12284.99.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-04 at 20:53 -0600, Eric W. Biederman wrote:
> Rusty Russell <rusty@rustcorp.com.au> writes:
> The delicate part right now is that lguest is attempting to use the
> standard kernel entry point which does have a fixed ABI.
> 
> If lguest uses that entry point in a hard to maintain way it provides
> a bad example, and it potentially leads to other problems.  So I
> really don't want to see the bad example happen, especially if the
> code in the bad example is as general as it is today.

I completely agree, a bad example is worse than no example.  Plus, an
opportunity to have you and hpa hacking on lguest is not to be missed.

> Frankly I think the least risk of problems comes from just doing a
> separate entry point for lguest for now.  It means we don't even have
> to touch the common code path and later dropping will be trivially 
> lguest specific, and certain to not break anything else.

Hmm, I railed for so long against Xen doing that, it feels... wrong...
to do that now 8)

I think I'll need to hack in a magic signature before the lguest start:
it's the only way it'll work with unpacking bzImages as well.  And it'll
be trivial to rip out later when we have the Right Way.

I'll spin a patch this afternoon (got to go to puppy training now).

Thanks!
Rusty.


