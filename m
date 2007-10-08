Return-Path: <linux-kernel-owner+w=401wt.eu-S1756718AbXJHSta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbXJHSta (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 14:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbXJHStX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 14:49:23 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:51534 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbXJHStW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 14:49:22 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: casey@schaufler-ca.com
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Kyle Moffett <mrmacman_g4@mac.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access Control Kernel
References: <54877.16343.qm@web36603.mail.mud.yahoo.com>
Date: Mon, 08 Oct 2007 12:47:43 -0600
In-Reply-To: <54877.16343.qm@web36603.mail.mud.yahoo.com> (Casey Schaufler's
	message of "Mon, 8 Oct 2007 10:50:40 -0700 (PDT)")
Message-ID: <m1bqb978a8.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> writes:

> --- "Eric W. Biederman" <ebiederm@xmission.com> wrote:
>
>
>> Likely.  Until we have a generalized LSM interface with 1000 config
>> options like netfilter I don't expect we will have grounds to talk
>> or agree to a common user space interface.  Although I could be
>> wrong.
>
> Gulp. I know that many of you are granularity advocates, but I
> have to say that security derived by tweeking 1000 knobs so that
> they are all just right seems a little far fetched to me. I see
> it as poopooing the 3rd and most important part of the reference
> monitor concept, "small enough to analyze". Sure, you can analyse
> the 1000 individual checks, but you'll never be able to describe
> the system behavior as a whole.

Agreed.  I wasn't thinking 1000 individual checks but 1000 different
capabilities, could be either checks or actions, basically fundamental
different capabilities.  Things like CIPSO, or the ability to store a
security label on a file.  I would not expect most security policies
to use most of them.  Neither do I expect Orange book security to
necessarily be what people want to achieve with the LSM.   But I
haven't looked at it enough detail to know how things should be
factored, in this case I was simply extrapolating from the iptables
experience where  we do have a very large number of options.

The real point being is that I would be surprised if we could come
to an agreement of a common user space API when we can't agree on how
to compile all of the security modules into the kernel and have them
play nice with each other. 

Assuming we can achieve security modules playing nice with each other
using a mechanism similar to iptables, then what needs to be evaluated
is the specific table configuration we are using on the system, not
the full general set of possibilities.  Further I expect that for the
truly security paranoid we want the option to disable further table
changes after the tables have been configured.

On another side personally I don't see where the idea comes from that
you can describe system behavior as a whole without analyzing the
entire kernel.  Has there been work on a sparse like tool that I'm
not aware of to ensure the we always perform the appropriate security
checks on the user/kernel interface boundary?

Eric
