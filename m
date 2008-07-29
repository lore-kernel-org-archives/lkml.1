Return-Path: <linux-kernel-owner+w=401wt.eu-S1755991AbYG2GVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbYG2GVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 02:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbYG2GUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 02:20:52 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:47919 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbYG2GUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 02:20:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=uUlpoOO+EhKo3WY+faCZahZIchozuDI8tHGDLkvXAd6ewM4Cc+9N/s2xYv4UMnBaX2
         ZsYrlVeNSQhJ5JQK9MwrlPnxX/RzWirb0BTn/6ZB/v1WmtKo6BUJyukbskBBQrUxMcaB
         Bv+kzX4AOStVst5fgbTbeq+JLE7NzrFHDwNlg=
Message-ID: <7c86c4470807282320o2d072c7dp7a327f133d5969c5@mail.gmail.com>
Date: Mon, 28 Jul 2008 23:20:50 -0700
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
Subject: Re: [patch 00/19] perfmon2 minimal v3: introduction
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080729014730.76b879a4.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4868dbf6.0af5660a.1972.52f4@mx.google.com>
	 <20080729014730.76b879a4.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,


On Mon, Jul 28, 2008 at 8:47 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> On Mon, 30 Jun 2008 06:13:26 -0700 (PDT) eranian@googlemail.com wrote:
>>
>> The following patches implement a minimal perfmon2 subsystem which provides
>> access to the hardware performance counters of modern processors.
>
> First up, I cannot speak to the actual function of the patches, but just
> to the mechanics of getting them into the kernel.  One good thing is that
> with CONFIG_PERFMON turned off, it looks like the impact is very close to
> zero. Two obvious things that would help these being accepted are:
>
Yes, when CONFIG_PERFMON is off, there should be no penalty at all.
The hooks are removed via empty inline functions. The extra field in
task_struct is removed. In x86-specific code, the low-level interrupt
code is removed. The TIF flags are unused, thus no impact on context
switch because the thread_info cacheline is checked regardless of perfmon2.


>        ordering - in the current incarnation, the patches produce places
> where the kernel will not build.  We like things to be ordered so that
> git bisection does not fail if at all possible - that means that an
> allmod/yesconfig should build after the application of each patch.
> Currently this is not so.  It could be mode to do so trivially by
> delaying the "global" Kconfig/Makefile updates until later in the
> sequence.  And you really should introduce the system calls *before*
> wiring them up.

I will restructure the patch series so it can be built at any one level of
of th patch stack.

>
>        quite a few of the macros (especially for the dummy (non
> CONFIG_PERFMON) versions of functions) should be "static inline"
> functions unless they absolutely must be macros.  Andrew Morton said it
> best - "write in C not C preprocessor".
>
I will fix that as well.

> I can see that this infrastructure could be very useful and I appreciate
> that it has been cut down for this initial merge.  These patches (even as
> they are) compare favourably to some other new infrastructure that has
> been introduced.

I think I can break it down a bit more especially for x86_64.

As discussed with people on LKML and with Andi Kleen last week at OLS, I will
see what can be done with the syscalls to make them a bit more extensible.

Thanks.
