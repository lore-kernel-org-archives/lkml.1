Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835AbZHIKDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbZHIKDv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 06:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753802AbZHIKDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 06:03:51 -0400
Received: from bar.sig21.net ([80.81.252.164]:58796 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753788AbZHIKDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 06:03:50 -0400
Date: Sun, 9 Aug 2009 12:03:48 +0200
From: Johannes Stezenbach <js@sig21.net>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: x86 MCE malfunction on Thinkpad T42p
Message-ID: <20090809100348.GA7186@sig21.net>
References: <20090807170942.GB9177@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090807170942.GB9177@sig21.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.8 (---)
X-Spam-21-Report: No, score=-3.8 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.568,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 07:09:42PM +0200, Johannes Stezenbach wrote:
> 
> I'm currently running linux-2.6.31-rc5-246-g90bc1a6 on
> an old Thinkpad T42p.  During boot I get the following:
...
> I guess I should try to boot with "lapic"?  But I think
> MCE worked without "lapic" in earlier kernels. On a 2.6.29.1
> kernel dmesg said:
> 
>    Local APIC disabled by BIOS -- you can enable it with "lapic"
>    ...
>    Intel machine check architecture supported.
>    Intel machine check reporting enabled on CPU#0.
> 
> 2.6.29.1 doesn't log any MCE events, so I doubt this is a HW problem.

I booted with "lapic", then the backtrace is gone
but it still logs machine check events which I think
are bogus since 2.6.29.1 does not log any.  I also
tried 2.6.30, no machine check messages in dmesg.  But
I noticed that mcelog complains about missing /dev/mcelog,
it seems that /dev/mcelog support for 32bit kernels is new.
However, I guess the old kernels should still have printed
a messge to dmesg, right?  "Uncorrected error" + "Processor
context corrupt" sounds pretty serious, but the machine
runs without problems.


These are from 2.6.31-rc5 by running mcelog (dmesg
just says "Machine check events logged"):


HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
MCE 0
CPU 0 BANK 1 
TIME 1249725930 Sat Aug  8 12:05:30 2009
MCG status:
MCi status:
Error overflow
Uncorrected error
Error enabled
Processor context corrupt
MCA: MEMORY CONTROLLER AC_CHANNEL0_ERR
Transaction: Address/Command error
STATUS f2000000000000b0 MCGSTATUS 0
MCGCAP 5 APICID 0 SOCKETID 0 
CPUID Vendor Intel Family 6 Model 13
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
MCE 1
CPU 0 BANK 1 
TIME 1249728066 Sat Aug  8 12:41:06 2009
MCG status:
MCi status:
Error overflow
Uncorrected error
Error enabled
Processor context corrupt
MCA: Unknown Error 20
STATUS f200000000000020 MCGSTATUS 0
MCGCAP 5 APICID 0 SOCKETID 0 
CPUID Vendor Intel Family 6 Model 13
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
MCE 2
CPU 0 BANK 1 
TIME 1249747923 Sat Aug  8 18:12:03 2009
MCG status:
MCi status:
Error overflow
Uncorrected error
Error enabled
Processor context corrupt
MCA: Unknown Error 30
STATUS f200000000000030 MCGSTATUS 0
MCGCAP 5 APICID 0 SOCKETID 0 
CPUID Vendor Intel Family 6 Model 13
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
MCE 3
CPU 0 BANK 1 
TIME 1249765938 Sat Aug  8 23:12:18 2009
MCG status:
MCi status:
Error overflow
Uncorrected error
Error enabled
Processor context corrupt
MCA: Unknown Error 20
STATUS f200000000000020 MCGSTATUS 0
MCGCAP 5 APICID 0 SOCKETID 0 
CPUID Vendor Intel Family 6 Model 13


Johannes
