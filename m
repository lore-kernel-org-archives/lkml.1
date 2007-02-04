Return-Path: <linux-kernel-owner+w=401wt.eu-S1752460AbXBDRiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbXBDRiZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 12:38:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbXBDRiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 12:38:25 -0500
Received: from smtp.osdl.org ([65.172.181.24]:44693 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460AbXBDRiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 12:38:24 -0500
Date: Sun, 4 Feb 2007 09:34:27 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?ISO-8859-1?Q?Fr=E9d=E9ric_Riss?= <frederic.riss@gmail.com>
cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Matt Domsch <Matt_Domsch@dell.com>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Neil Brown <neilb@suse.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeff Garzik <jeff@garzik.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: 2.6.20-rc7: known regressions
In-Reply-To: <1170594788.5217.4.camel@funkylaptop>
Message-ID: <Pine.LNX.4.64.0702040928330.8424@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org> 
 <200702031058.13830.ak@suse.de> <1170499668.31373.35.camel@funkylaptop> 
 <200702031151.17220.ak@suse.de> <1170594788.5217.4.camel@funkylaptop>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463790079-472062795-1170610467=:8424"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463790079-472062795-1170610467=:8424
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT



On Sun, 4 Feb 2007, Frédéric Riss wrote:
> 
> New patch:

I didn't get how this would fix the ia64 issues? I thought ia64 needed 
the standard calling convention?

My gut feel is that EFI should be handled exactly the same way that we 
used to handle APM: never even make it look like it's callable from C, but 
make architecture-specific wrapper functions that have bog-standard 
calling conventions, and then possibly even use inline asm to actually do 
the real call (but even if you don't, at that point it would be inside one 
particular arch-specific EFI source file - nobody outside of that would 
ever call into the firmware directly).

As it is, I don't think I dare apply this right now, which means that it 
will miss 2.6.20, and we'll have to backport it to the stable tree when 
everybody agrees and has acked it. I don't like having suspend broken on 
EFI macs, but on the other hand, I would hate to have an ia64 regression 
even more..

		Linus
---1463790079-472062795-1170610467=:8424--
