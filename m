Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbYDVMvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbYDVMvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 08:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYDVMvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 08:51:43 -0400
Received: from sandeen.net ([209.173.210.139]:29523 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329AbYDVMvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 08:51:42 -0400
Message-ID: <480DDF5C.6090808@sandeen.net>
Date: Tue, 22 Apr 2008 07:51:40 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: David Chinner <dgc@sgi.com>, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] xfs: do not pass unused params to xfs_flush_pages
References: <20080419142329.GA5339@elte.hu> <200804220503.16888.vda.linux@googlemail.com> <480D586C.1030305@sandeen.net> <200804221057.33324.vda.linux@googlemail.com>
In-Reply-To: <200804221057.33324.vda.linux@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Vlasenko wrote:
> On Tuesday 22 April 2008 05:15, Eric Sandeen wrote:


>>> Compile-tested only.
>> FWIW this one actually does not seem to reduce stack usage anywhere.
> 
> I hope this will not deteriorate into a contest whether
> every particular patch reduces stack usage or not, but:

Sorry if you took it that way; since the patch was in response to Dave's
mention of accepting stack-reducing patches, I thought it was worth
checking and highlighting whether it seemed to help.  It wasn't supposed
to be an attack or argument.

> You do not see reduced stack usage in "make checkstack",
> because "make checkstack" shows only stack usage caused by
> local variables (it analyses sub %esp,NN instructions which
> make room for them). Parameters also take up stack, but
> they are pushed on stack with push instruction,
> and so are invisible in "make checkstack" output.

Hm, I had assumed that the %esp subtraction also made room for the
arguments pushed onto the stack.  Is there no way to analyze that part?

Thanks,
-Eric
