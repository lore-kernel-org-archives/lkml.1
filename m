Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbXJHVQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbXJHVQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 17:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbXJHVQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 17:16:27 -0400
Received: from [81.2.110.250] ([81.2.110.250]:34502 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752751AbXJHVQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 17:16:25 -0400
Date: Mon, 8 Oct 2007 22:20:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory
 Access Control Kernel
Message-ID: <20071008222058.208c6f32@the-village.bc.nu>
In-Reply-To: <m1hcl11j31.fsf@ebiederm.dsl.xmission.com>
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
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> My very practical question:  How do I run selinux in one container,
> and SMACK in another?

In the LSM model you don't because you could have the same container
objects visible in different contains at the same time and subject to
different LSMs. What does it mean to pass an SELinux protected object
over an AppArmour protected unix domain socket into a SMACK protected
container ?

If you want consistency then you probably need to put the container id
into the LSM calls and provide the ability in one system to do container
specific checks. Right now I suspect the way to do it is to complete the
work to convert SMACK rulesets into SELinux rulesets with tools.

Really its the same problem as "I'd like to use different file permission
systems on different process identifiers" and it would be very hard to
get right simply because objects can pass between two different security
models.

Pyramid tried to do the "simple" case of BSD and System 5 on the same box
and got caught out even with that because of the different rules on stuff
like chgrp..
