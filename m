Return-Path: <linux-kernel-owner+w=401wt.eu-S1754190AbXJHVDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbXJHVDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 17:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbXJHVDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 17:03:09 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38023 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbXJHVDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 17:03:08 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: casey@schaufler-ca.com
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access Control Kernel
References: <384716.99898.qm@web36602.mail.mud.yahoo.com>
Date: Mon, 08 Oct 2007 15:02:24 -0600
In-Reply-To: <384716.99898.qm@web36602.mail.mud.yahoo.com> (Casey Schaufler's
	message of "Mon, 8 Oct 2007 13:39:01 -0700 (PDT)")
Message-ID: <m1tzp1z5en.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> writes:

> --- "Eric W. Biederman" <ebiederm@xmission.com> wrote:
>
>
>> My very practical question:  How do I run selinux in one container,
>> and SMACK in another?
>
> How would you run PREEMPT_RT in one container, and PREEMPT_DESKTOP
> in another?

Well the style of kernel preemption is generally an implementation
detail that is not visible to user space.

> How would you run SMP in one and UP in the other?
Bind all of the UP processes to a single cpu.

> One aspect that SELinux and Smack share is that they only really
> provide security if all processes involved are under their control,
> just like the preemption behavior.

Right.  But in a container that look like a full system arguably this
is doable.  There are a few additional details that would be needed
to ensure containers are isolated from each other that would be
needed to ensure this is effective but those are fairly minor.

> This is not necessarily true of all possible LSMs. In that case it may
> be practicle to have different behavior for different containers.

When we get to the point where this is a real concern I believe the
isolation will be sufficient that this it is a valid question to
ask.

If there is nothing visible to user space I don't care.  But security
modules are fundamentally about changing when -EPERM happens so are
very visible to user space.

Eric
