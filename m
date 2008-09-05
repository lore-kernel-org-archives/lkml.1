Return-Path: <linux-kernel-owner+w=401wt.eu-S1753702AbYIESWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702AbYIESWd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 14:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbYIESWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 14:22:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57485 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751251AbYIESWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 14:22:24 -0400
Date: Fri, 5 Sep 2008 11:22:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Marc Haber <mh+linux-kernel@zugschlus.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.26.3 mount process looping on ext3 rw remount
Message-Id: <20080905112221.8be36263.akpm@linux-foundation.org>
In-Reply-To: <20080905113901.GA2756@torres.zugschlus.de>
References: <20080823084228.GA21293@torres.zugschlus.de>
	<20080825183528.30b66f45.akpm@linux-foundation.org>
	<20080905113901.GA2756@torres.zugschlus.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Sep 2008 13:39:02 +0200 Marc Haber <mh+linux-kernel@zugschlus.de> wrote:

> On Mon, Aug 25, 2008 at 06:35:28PM -0700, Andrew Morton wrote:
> > Please try to get a kernel profile while it's happening.  oprofile
> > maybe, or just the plain old timer-based profiler.  There's some info
> > in Documentation/basic_profiling.txt.
> 
> I'll boot my next kernel with profile=2.
> 
> > Actually, a simple alternative is to hit sysrq-P five or ten times. 
> > Most of the resulting stack traces will point back at where the CPU is
> > stuck.
> 
> Where are they written to? "P" in a sysrqd telnet session does not
> result in anything being written to the kernel log or to dmesg.

alt-sysrq-p from the attached keyboard.

When operating remotely, use `echo p > /proc/sysrq-trigger'.

The output will be in /var/log/messages and is accessible via
`dmesg -s 1000000'.

Please avoid email client wordwrapping when sending these logs.  99% of
people do this and it makes the text very hard to read.

> > This gets a bit hit-or-miss if you have multiple CPUs, because the
> > sysrq-p trace can land on the wrong CPU.  We recently added a sysrq-l
> > which will generate a trace on all CPUS.
> 
> "l" results in the SysRq HELP being written to the kernel log, so I
> guess that "recently" means "not yet in 2.6.26.3".

ok
