Return-Path: <linux-kernel-owner+w=401wt.eu-S1754061AbYGVIBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbYGVIBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 04:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbYGVIBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 04:01:17 -0400
Received: from mail.gmx.net ([213.165.64.20]:39503 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751706AbYGVIBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 04:01:15 -0400
X-Authenticated: #23500402
X-Provags-ID: V01U2FsdGVkX18i+9Il/EAir5ISCYsZJmIKbCnl8Wp74PG9WrHqom
	r8NAn4Xfpvqy2A
Date: Tue, 22 Jul 2008 10:01:12 +0200
From: Andre Prendel <andre_prendel@gmx.de>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Andre Prendel <andre_prendel@gmx.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       kernel-testers@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Zhao, Yakui" <yakui.zhao@intel.com>
Subject: Re: ACPI Error under 2.6.26-rc*
Message-ID: <20080722080112.GA4653@linux.int.dgn.ag>
References: <20080709083829.GA5748@linux.int.dgn.ag> <200807102255.23090.rjw@sisk.pl> <1215739210.1617.28.camel@rzhang-dt> <1215739682.1617.32.camel@rzhang-dt> <20080714080914.GA4965@linux.int.dgn.ag> <1216026701.1617.82.camel@rzhang-dt> <20080715074130.GA4724@linux.int.dgn.ag> <1216111260.1617.131.camel@rzhang-dt> <20080717084102.GA4597@linux.int.dgn.ag> <1216693359.1617.258.camel@rzhang-fc9>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1216693359.1617.258.camel@rzhang-fc9>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 10:22:39AM +0800, Zhang Rui wrote:
> On Thu, 2008-07-17 at 16:41 +0800, Andre Prendel wrote:
> > On Tue, Jul 15, 2008 at 04:41:00PM +0800, Zhang Rui wrote:
> > > > > It seems that OS failed to get the correct RSDT address
> > > > (0x1fff0000),
> > > > > although the RSDP is found correctly. (﻿ACPI: RSDP 000FA340,
> > 0014)
> > > > >
> > > > > please run "./acpidump --addr 0xFA340 --length 0x14 > rsdp_xxx",
> > > > > and attach the rsdp for all of the three cases (good, ACPI
> > Error,
> > > > ACPI
> > > > > Exception).
> > > > Hello Rui,
> > > >
> > > > here is the output of the three cases. The dump files are attached
> > > > too.
> > > >
> > > > ----
> > > > good
> > > > ----
> > > > andre@ubuntu:~/src/acpi/pmtools-20071116/acpidump$ hexdump
> > rsdp_good
> > > > 0000000 5352 2044 5450 2052 418c 494d 2020 0020
> > > > 0000010 0000 1fff                            
> > > > 0000014
> > > >
> > > > -----
> > > > error
> > > > -----
> > > > andre@ubuntu:~/src/acpi/pmtools-20071116/acpidump$ hexdump
> > rsdp_error
> > > > 0000000 5352 2044 5450 2052 418a 494d 2020 0020
> > > > 0000010 0000 21ff                            
> > > > 0000014
> > > >
> > > > ---------
> > > > exception
> > > > ---------
> > > > andre@ubuntu:~/src/acpi/pmtools-20071116/acpidump$ hexdump
> > > > rsdp_exception
> > > > 0000000 5352 2044 5450 2052 417c 494d 2020 0020
> > > > 0000010 0000 2fff                            
> > > > 0000014
> > >
> > > Weird.
> > > The dmesg shows that the memory map gotten from e820 table is
> > changed.
> > > And the file attached shows that rsdp points to different rsdt
> > address.
> > > >
> > > > Now I see the ACPI Error under the 2.6.25.10 kernel sometimes too,
> > but
> > > > power off works well. So I also attach the two configs. Maybe the
> > > > different config is the reason why power off works under
> > 2.6.25.10.
> > > so you may get different e820 table when running 2.6.25.10 as well?
> > > could you please attach the dmesg output of a 2.6.25.10 kernel which
> > has
> > > the ACPI error?
> > 
> > Attached. Yes, the e820 table differs, but power off still works.
> 
> Hmm, there seems to be two bugs here.
> 1. invalid e820 tables, which seems like a BIOS bug, please try to
> upgrade your BIOS.
> 2. poweroff doesn't work.
>    Hmm, please try boot option "acpi=off" in both 2.6.25 and 2.6.26.
>    I guess power off works on 2.6.25 while it fails on 2.6.26, right?

Hello Rui,

I have found the power off problem. After bisecting the problem without
success I compared the configs from 2.6.25.10 and 2.6.26-rc*. I have
seen a difference in the APM section. In the 2.6.26-rc* config
CONFIG_APM_DO_ENABLE was not enabled. I dont know how this could happen. AFAIR
I used the working 2.6.25 config and made just a "make oldconfig". So I have
enabled CONFIG_APM_DO_ENABLE, build the kernel and now power off works
fine. Further the ACPI errors/exceptions do not appear with 2.6.26 (stable)
and the new config. Maybe this is why CONFIG_APM_DO_ENABLE is enabled. I dont
know the relation between this option and ACPI.

-----------------------
dmesg (extract)
-----------------------
Linux version 2.6.26-default (andre@ubuntu) (gcc version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #13 Mon Jul 21 22:48:01 CEST 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001fff0000 (usable)
 BIOS-e820: 000000002fff0000 - 000000002fff8000 (ACPI data)
 BIOS-e820: 000000002fff8000 - 0000000030000000 (ACPI NVS)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffee0000 - 00000000fff00000 (reserved)
 BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
[...]
ACPI: Interpreter disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI: disabled
[...]

The bios problem still exists so maybe I will do an upgrade.
 
> thanks,
> rui

Thanks,
Andre
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-testers" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
