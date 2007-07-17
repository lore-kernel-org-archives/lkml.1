Return-Path: <linux-kernel-owner+w=401wt.eu-S1756743AbXGQIWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743AbXGQIWE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 04:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118AbXGQIVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 04:21:49 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:32814
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbXGQIVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 04:21:47 -0400
Date: Tue, 17 Jul 2007 01:13:49 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Huang, Ying" <ying.huang@intel.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base	hibernation
In-Reply-To: <1184491804.1898.121.camel@caritas-dev.intel.com>
Message-ID: <Pine.LNX.4.64.0707170101010.19248@asgard.lang.hm>
References: <1184167831.12556.13.camel@caritas-dev.intel.com> 
 <200707141159.47289.rjw@sisk.pl>  <1184410554.1898.84.camel@caritas-dev.intel.com>
  <200707142116.10237.rjw@sisk.pl> <1184491804.1898.121.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ying, as the kexec guru in this thread I have a question for you about how 
kexec works (and possibly where you are going with this)

for the power-off hibernate with ACPI disabled the hibernation seems 
fairly straightforward (although there are still some missing pieces)

however, since the resume designed for ACPI won't work would the following 
approach work

1. boot one kernel
2. setup a kexec the same way you would for hibernate
3. kexec to the new kernel
4. overwrite the memory of the first kernel
5. kexec 'back' to the main kernel that has now been overwritten by what was saved?

as part of this question, when you do a kexec, how does the kernel that 
you are doing the kexec to know what to run next?

it needs to do some initialization first before it starts running normal 
things, and at that point it the move back doesn't look for init like a 
normal kernel boot (or the system would effectivly boot instead of picking 
up where it left off)

is this 'restart point' flexible enough that either the pre-hibernate 
kerenl or the small hibernate kernel could tell the pre-hibernate kernel 
to go into suspend-to-ram mode before doing anything else?

Rafael,
   if ACPI is disabled and not used, is there any memory in the origional 
kernel that _must not_ be saved in the hibernate image? I recognise that 
for efficancy it would save time to not save free memory, but if I'm 
willing to waste some resources would it hurt to save everything?

David Lang
