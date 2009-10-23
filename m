Return-Path: <linux-kernel-owner+w=401wt.eu-S1751837AbZJWNSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbZJWNSt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 09:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbZJWNSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 09:18:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50259 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbZJWNSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 09:18:48 -0400
Subject: Re: [performance problem] CONFIG_DYNAMIC_FTRACE: Increased kernel
 build times
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ingo Molnar <mingo@elte.hu>
Cc: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20091023074533.GA10067@elte.hu>
References: <20091023074533.GA10067@elte.hu>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Fri, 23 Oct 2009 09:18:51 -0400
Message-Id: <1256303931.20866.826.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-23 at 09:45 +0200, Ingo Molnar wrote:
> Steve,
> 
> i did an 64-bit allyesconfig build test (with debug_info disabled), with 
> and without CONFIG_DYNAMIC_FTRACE set.
> 
> The build time results are:
> 
>   -CONFIG_DYNAMIC_FTRACE:   266.30
>   +CONFIG_DYNAMIC_FTRACE:   296.07 (+11.2%)
> 
> So we get more than 10% build time overhead.
> 
> That's quite high - higher than what i remember having measured 
> originally when the first iteration of the mcount code went in.
> 
> This extra overhead comes from the mcount post-processing script 
> (scripts/recordmcount.pl) that runs objcopy as well and is written in 
> Perl. I think this whole angle needs to be improved - 10% is way too 
> high of a price to pay.

Yeah, I know this is quite a hit, and to fix this is on my todo list.
What I plan on doing is checking if libelf is installed, and if it is,
then doing a C program that does the linking and checking. If not, it
defaults back to the perl code.

But I'm bug hunting right now, and that takes a higher priority.

-- Steve

