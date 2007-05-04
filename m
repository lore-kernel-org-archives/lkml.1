Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbXEDODP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbXEDODP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 10:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755308AbXEDODP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 10:03:15 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50331 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283AbXEDODO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 10:03:14 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/3] Replace paravirt_probe with "platform type" boot header field
References: <1178283582.23670.67.camel@localhost.localdomain>
Date: Fri, 04 May 2007 08:01:39 -0600
In-Reply-To: <1178283582.23670.67.camel@localhost.localdomain> (Rusty
	Russell's message of "Fri, 04 May 2007 22:59:42 +1000")
Message-ID: <m1zm4ksn5o.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> writes:

> [ This patch won't apply, even to -mm: it comes after the documentation
> patch.  But it's hopefully readable ]
>
> 1) This code assumes that 0x23C is going to be the "platform type"
>    field of the next version of the Linux boot header format.
>
> 2) This doesn't actually assume that P=V, but unlike the paravirt
>    probe code doesn't assume that V=P+PAGE_OFFSET either.
>
> The following patch actually fixes up lguest to boot with P=V.

We should place that initial branch right after startup_32,
we don't need the startup_paravirt at all now.

ENTRY(startup_32)
#ifdef CONFIG_LGUEST_GUEST
        cmpl	$1, 0x23c(%esi)
	je      lguest_init
#endif

...

Although it might make sense to do:
ENTRY(startup_32)
	cmpl	$0, 0x23c(%esi)
        jnz	startup_subarch

To get the branches out of the main flow of execution but
that is minor.  This isn't a performance critical path.

Eric
