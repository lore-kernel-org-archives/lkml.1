Return-Path: <linux-kernel-owner+w=401wt.eu-S1946445AbXBCKvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946445AbXBCKvl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 05:51:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946446AbXBCKvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 05:51:41 -0500
Received: from ns.suse.de ([195.135.220.2]:48508 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946445AbXBCKvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 05:51:40 -0500
From: Andi Kleen <ak@suse.de>
To: =?utf-8?q?Fr=C3=A9d=C3=A9ric_Riss?= <frederic.riss@gmail.com>
Subject: Re: 2.6.20-rc7: known regressions
Date: Sat, 3 Feb 2007 11:51:16 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Matt Domsch <Matt_Domsch@dell.com>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Neil Brown <neilb@suse.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeff Garzik <jeff@garzik.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Francois Romieu <romieu@fr.zoreil.com>
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org> <200702031058.13830.ak@suse.de> <1170499668.31373.35.camel@funkylaptop>
In-Reply-To: <1170499668.31373.35.camel@funkylaptop>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200702031151.17220.ak@suse.de>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> +#ifdef CONFIG_X86_32
> +#define efilinkage asmlinkage
> +#else
> +#define efilinkage
> +#endif

No ifdefs, this should be somewhere in the headers for the EFI supporting
architectures

But I suspect you could actually get away with just using asmlinkage
(after reviewing the ia64 asmlinkage I think it's ok)

x86-64 when it is ever implemented will always need asm stubs though
because it uses completely incompatible calling conventions.

> +
> +typedef efilinkage efi_status_t efi_get_time_t (efi_time_t *tm,
> +						efi_time_cap_t *tc);

I assume you have double checked it actually works? (i vaguely recall some
issues with applying attributes to typedefs). If not you would need
to put them to the declarations.

-Andi
