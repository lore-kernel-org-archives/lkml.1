Return-Path: <linux-kernel-owner+w=401wt.eu-S1762422AbXHAAof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762422AbXHAAof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 20:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755078AbXHAAo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 20:44:27 -0400
Received: from zaphod.dth.net ([85.159.112.68]:45824 "EHLO zaphod.dth.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754014AbXHAAo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 20:44:26 -0400
Date: Wed, 1 Aug 2007 02:44:23 +0200
From: Danny ter Haar <dth@dth.net>
To: Len Brown <lenb@kernel.org>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: Update: ide problems: 2.6.22-git17 working, 2.6.23-rc1* is not:
Message-ID: <20070801004423.GA16572@dth.net>
References: <20070727193832.GA20289@dth.net> <46AC0F6E.2000008@googlemail.com> <20070730025412.GA22888@dth.net> <200707301330.54640.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707301330.54640.lenb@kernel.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Len Brown (lenb@kernel.org):
> Also, please test with CONFIG_X86_ACPI_CPUFREQ=n
> to remove the acpi-cpufreq driver (and thus this patch)
> from your kernel.  If it still fails, then we know
> that this driver (and this patch) are not related
> to the failure.

It wasn't enabled in any of the kernels i ran:

# grep X86_ACPI ../configs/config*
../configs/config-2.6.22-git14-c3-via5000-firewall:# CONFIG_X86_ACPI_CPUFREQ is not set
../configs/config-2.6.22-git17-c3-via5000-firewall:# CONFIG_X86_ACPI_CPUFREQ is not set
../configs/config-2.6.23-rc1-git5:# CONFIG_X86_ACPI_CPUFREQ is not set
../configs/config-2.6.23-rc1-git6:# CONFIG_X86_ACPI_CPUFREQ is not set
../configs/config-2.6.23-rc1-git9:# CONFIG_X86_ACPI_CPUFREQ is not set
../configs/config-2.6.23-rc1-mm1-c3-firewall:# CONFIG_X86_ACPI_CPUFREQ is not set

> Hmmm, okay, the "big hammer" works.  Please see
> if any of these smaller hammers work:
> 
> pnpacpi=off
> acpi=noirq
> notsc

_none_ of these options will work. The machine locks up solid.
And that's what i'm the most surprised about. The last time i withnessed
a solid kernel lockup without any panic/notification is _years_ ago.

I also tried a kernel without "CPU Frequency scaling", so it is not the
scaling up/down in Mhz of the cpu.
I've even just compiled/run a kernel with libata and even that one still 
locks up.

New round of git bisects i guess (this time powercycle instead of reboot
and wait few hours before ginving it "bisect good" )

Will report back.

Danny

-- 
