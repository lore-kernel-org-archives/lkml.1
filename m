Return-Path: <linux-kernel-owner+w=401wt.eu-S1765115AbXHFNsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765115AbXHFNsL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 09:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761539AbXHFNr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:47:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761706AbXHFNrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:47:55 -0400
Message-ID: <46B72688.8070303@redhat.com>
Date: Mon, 06 Aug 2007 09:47:52 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Few interrupts with NO_HZ
References: <Pine.LNX.4.64.0708061247150.13469@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0708061247150.13469@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> Hi,
> 
> 
> this more of an informational question. So:
> 
> kernel version is 2.6.22.1 on i686
> 
> /proc/uptime 
> 9917.81 9140.90 (2h45m)
> 
> /proc/cpuinfo:
>            CPU0
>   0:        282   IO-APIC-edge      timer
> 
> this is kinda neat, I expected much more interrupts than just 282 since 
> boot. What kernel code actually uses the irq0 timer?

If you don't have an HPET (and most single-processor systems do not) the kernel 
is probably using the PIT to wake the processor from low-power sleep states, 
since the LAPIC timer is disabled in these states.  If your box is mostly idle, 
you might want to use powertop to figure out why it's entering low power states 
so infrequently.

	-- Chris
