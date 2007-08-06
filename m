Return-Path: <linux-kernel-owner+w=401wt.eu-S932775AbXHFOfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775AbXHFOfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 10:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932280AbXHFOfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 10:35:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932234AbXHFOfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 10:35:33 -0400
Message-ID: <46B731B2.3040409@redhat.com>
Date: Mon, 06 Aug 2007 10:35:30 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Few interrupts with NO_HZ
References: <Pine.LNX.4.64.0708061247150.13469@fbirervta.pbzchgretzou.qr> <46B72688.8070303@redhat.com> <Pine.LNX.4.64.0708061626010.13469@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0708061626010.13469@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Aug 6 2007 09:47, Chris Snook wrote:
>>> this more of an informational question. So:
>>> kernel version is 2.6.22.1 on i686
>>> /proc/uptime 9917.81 9140.90 (2h45m)
>>> /proc/cpuinfo:
>>>            CPU0
>>>   0:        282   IO-APIC-edge      timer
>>>
>>> this is kinda neat, I expected much more interrupts than just 282
>>> since boot. What kernel code actually uses the irq0 timer?
>> If you don't have an HPET (and most single-processor systems do not)
> 
> This is an AMD Athlon with 'Thoroughbred' core; it does not seem to
> have C-states at all (or: exactly one). It clearly is not idle all the
> time, sometimes I run povray. (And 282 has not changed since the
> morning.)
> 
> 
> 	Jan

In that case, it's probably the early bootstrap code that runs before the TSC is 
calibrated.  PIT sucks, but it sucks very reliably, so it's a good basis for 
calibrating the other timekeeping devices.  Once you have something better set 
up, you don't need it anymore if you're not doing C-state transitions.

	-- Chris
