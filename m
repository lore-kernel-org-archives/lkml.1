Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbXJJNwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbXJJNwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 09:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbXJJNw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 09:52:26 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38532 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbXJJNwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 09:52:24 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access Control Kernel
References: <alpine.LFD.0.999.0710010854120.3579@woody.linux-foundation.org>
	<4702B1D5.5050502@tmr.com>
	<alpine.LFD.0.999.0710021410470.3579@woody.linux-foundation.org>
	<4703126D.70703@tmr.com>
	<alpine.LFD.0.999.0710022050560.3579@woody.linux-foundation.org>
	<m17im2pc7x.fsf@ebiederm.dsl.xmission.com>
	<15E46546-914A-4A1E-BB0B-642FDA17396B@mac.com>
	<m1zlyymaoy.fsf@ebiederm.dsl.xmission.com>
	<20071008160611.GA7106@vino.hallyn.com>
	<m11wc5a5gp.fsf@ebiederm.dsl.xmission.com>
	<20071008180038.GC7106@vino.hallyn.com>
	<m1hcl11j31.fsf@ebiederm.dsl.xmission.com>
	<20071008222058.208c6f32@the-village.bc.nu>
Date: Wed, 10 Oct 2007 07:48:57 -0600
In-Reply-To: <20071008222058.208c6f32@the-village.bc.nu> (Alan Cox's message
	of "Mon, 8 Oct 2007 22:20:58 +0100")
Message-ID: <m1abqrt706.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

>> My very practical question:  How do I run selinux in one container,
>> and SMACK in another?
>
> In the LSM model you don't because you could have the same container
> objects visible in different contains at the same time and subject to
> different LSMs. What does it mean to pass an SELinux protected object
> over an AppArmour protected unix domain socket into a SMACK protected
> container ?

You raise a good point.  My intuitive definition would go something like
this.  In the initial LSM space we would have whatever is the primary
LSM and it would always be invoked about everything.   However it
would view a single container (no matter what user in that container)
as having a single set of permissions.  Then the LSM in the container
be asked to further validate accesses, but it would distinguish
between users in the container.

At this point it looks like if I am going to be effective at doing
anything I am going to need to step back watch SMACK get merged and
then really look at what the LSM modules are implementing.  Then
I can refactor the whole mess and move additional functionality into
the LSM to help me achieve other things.

> Really its the same problem as "I'd like to use different file permission
> systems on different process identifiers" and it would be very hard to
> get right simply because objects can pass between two different security
> models.

Yep.  Although the isolation of a container with a completely
different set of namespaces is tight enough that except for people
debugging a container from processes in the container from outside the
container object exchange essentially doesn't happen.

You do raise a very good question here.  Does an LSM implement a
different file permission system?  Or does an LSM implement a firewall
between processes?

Certainly selinux seems too programmable to be considered just a
different file permission system.  

> Pyramid tried to do the "simple" case of BSD and System 5 on the same box
> and got caught out even with that because of the different rules on stuff
> like chgrp..

Yes.  There are many hard problems here and many people have tried and
failed in the past.  That hasn't stopped me before, and I don't see
why security should be any different.

Eric
