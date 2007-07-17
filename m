Return-Path: <linux-kernel-owner+w=401wt.eu-S1762797AbXGQLwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762797AbXGQLwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 07:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755366AbXGQLvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 07:51:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47797 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232AbXGQLvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 07:51:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: david@lang.hm
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec =?iso-8859-1?q?base=09hibernation?=
Date: Tue, 17 Jul 2007 13:59:31 +0200
User-Agent: KMail/1.9.5
Cc: "Huang, Ying" <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
References: <1184167831.12556.13.camel@caritas-dev.intel.com> <1184491804.1898.121.camel@caritas-dev.intel.com> <Pine.LNX.4.64.0707170101010.19248@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0707170101010.19248@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707171359.33317.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 17 July 2007 10:13, david@lang.hm wrote:
> Ying, as the kexec guru in this thread I have a question for you about how 
> kexec works (and possibly where you are going with this)
> 
> for the power-off hibernate with ACPI disabled the hibernation seems 
> fairly straightforward (although there are still some missing pieces)
> 
> however, since the resume designed for ACPI won't work would the following 
> approach work
> 
> 1. boot one kernel
> 2. setup a kexec the same way you would for hibernate
> 3. kexec to the new kernel
> 4. overwrite the memory of the first kernel
> 5. kexec 'back' to the main kernel that has now been overwritten by what was saved?
> 
> as part of this question, when you do a kexec, how does the kernel that 
> you are doing the kexec to know what to run next?
> 
> it needs to do some initialization first before it starts running normal 
> things, and at that point it the move back doesn't look for init like a 
> normal kernel boot (or the system would effectivly boot instead of picking 
> up where it left off)
> 
> is this 'restart point' flexible enough that either the pre-hibernate 
> kerenl or the small hibernate kernel could tell the pre-hibernate kernel 
> to go into suspend-to-ram mode before doing anything else?
> 
> Rafael,
>    if ACPI is disabled and not used, is there any memory in the origional 
> kernel that _must not_ be saved in the hibernate image? I recognise that 
> for efficancy it would save time to not save free memory, but if I'm 
> willing to waste some resources would it hurt to save everything?

On some systems there are valid 'struct page' structures that correspond to
memory holes and the kernel will oops if you try to save the contents of
these pages.  Unfortunately, only the early initialization platform code can
tell you which they are.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
