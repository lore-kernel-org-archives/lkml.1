Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965AbYFNVpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbYFNVpR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 17:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754695AbYFNVpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 17:45:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49230 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754654AbYFNVpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 17:45:01 -0400
Date: Sat, 14 Jun 2008 14:42:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: 2.6.26-rc6-git2: Reported regressions from 2.6.25
In-Reply-To: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
Message-ID: <alpine.LFD.1.10.0806141423500.2949@woody.linux-foundation.org>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 14 Jun 2008, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10912
> Subject		: Regressions in the last kernels
> Submitter	: werner <werner@sys-linux.yi.org>
> Date		: 2008-06-14 18:26 (1 days old)
> References	: http://marc.info/?l=linux-kernel&m=121346933911641&w=4

I don't believe this is a regression, at least the 8GB thing. The 
HIGHMEM64G config option has had a

	depends on !M386 && !M486

for quite a while now. It certainly was in 2.6.25 already.

So if you want PAE support, we do require that you ask for a kernel that 
has cmpxchg8b support (needed for the atomic 64-bit clearing of a PAE page 
table entry). Not to mention a CPU that supports PAE. And that is simply 
incompatible with "I want it to work on an i486 too".

So saying "I want a kernel that uses PAE _and_ works on an i486" is simply 
nonsensical. If we ever supported it, it was a mistake, and wouldn't have 
actually worked on an i486 anyway.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10908
> Subject		: IPF Montvale machine panic when running a network-relevent testing
> Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> Date		: 2008-06-13 8:19 (2 days old)
> References	: http://marc.info/?l=linux-kernel&m=121334523711437&w=4

I think this got fixed by ec0a196626bd12e0ba108d7daa6d95a4fb25c2c5: "tcp: 
Revert 'process defer accept as established' changes".

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10903
> Subject		: ssh connections hang with 2.6.26-rc5
> Submitter	: Didier Raboud <didier@raboud.com>
> Date		: 2008-06-13 02:39 (2 days old)

I think this is likely fixed by the same revert as above.

David?

		Linus
