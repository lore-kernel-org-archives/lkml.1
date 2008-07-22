Return-Path: <linux-kernel-owner+w=401wt.eu-S1756282AbYGVCYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282AbYGVCYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 22:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754837AbYGVCYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 22:24:13 -0400
Received: from mga14.intel.com ([143.182.124.37]:10694 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967AbYGVCYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 22:24:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,228,1215414000"; 
   d="scan'208";a="23057331"
Subject: Re: ACPI Error under 2.6.26-rc*
From: Zhang Rui <rui.zhang@intel.com>
To: Andre Prendel <andre_prendel@gmx.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       kernel-testers@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Zhao, Yakui" <yakui.zhao@intel.com>
In-Reply-To: <20080717084102.GA4597@linux.int.dgn.ag>
References: <20080709083829.GA5748@linux.int.dgn.ag>
	 <200807102255.23090.rjw@sisk.pl> <1215739210.1617.28.camel@rzhang-dt>
	 <1215739682.1617.32.camel@rzhang-dt>
	 <20080714080914.GA4965@linux.int.dgn.ag>
	 <1216026701.1617.82.camel@rzhang-dt>
	 <20080715074130.GA4724@linux.int.dgn.ag>
	 <1216111260.1617.131.camel@rzhang-dt>
	 <20080717084102.GA4597@linux.int.dgn.ag>
Content-Type: text/plain; charset=utf-8
Date: Tue, 22 Jul 2008 10:22:39 +0800
Message-Id: <1216693359.1617.258.camel@rzhang-fc9>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-17 at 16:41 +0800, Andre Prendel wrote:
> On Tue, Jul 15, 2008 at 04:41:00PM +0800, Zhang Rui wrote:
> > > > It seems that OS failed to get the correct RSDT address
> > > (0x1fff0000),
> > > > although the RSDP is found correctly. (﻿ACPI: RSDP 000FA340,
> 0014)
> > > >
> > > > please run "./acpidump --addr 0xFA340 --length 0x14 > rsdp_xxx",
> > > > and attach the rsdp for all of the three cases (good, ACPI
> Error,
> > > ACPI
> > > > Exception).
> > > Hello Rui,
> > >
> > > here is the output of the three cases. The dump files are attached
> > > too.
> > >
> > > ----
> > > good
> > > ----
> > > andre@ubuntu:~/src/acpi/pmtools-20071116/acpidump$ hexdump
> rsdp_good
> > > 0000000 5352 2044 5450 2052 418c 494d 2020 0020
> > > 0000010 0000 1fff                            
> > > 0000014
> > >
> > > -----
> > > error
> > > -----
> > > andre@ubuntu:~/src/acpi/pmtools-20071116/acpidump$ hexdump
> rsdp_error
> > > 0000000 5352 2044 5450 2052 418a 494d 2020 0020
> > > 0000010 0000 21ff                            
> > > 0000014
> > >
> > > ---------
> > > exception
> > > ---------
> > > andre@ubuntu:~/src/acpi/pmtools-20071116/acpidump$ hexdump
> > > rsdp_exception
> > > 0000000 5352 2044 5450 2052 417c 494d 2020 0020
> > > 0000010 0000 2fff                            
> > > 0000014
> >
> > Weird.
> > The dmesg shows that the memory map gotten from e820 table is
> changed.
> > And the file attached shows that rsdp points to different rsdt
> address.
> > >
> > > Now I see the ACPI Error under the 2.6.25.10 kernel sometimes too,
> but
> > > power off works well. So I also attach the two configs. Maybe the
> > > different config is the reason why power off works under
> 2.6.25.10.
> > so you may get different e820 table when running 2.6.25.10 as well?
> > could you please attach the dmesg output of a 2.6.25.10 kernel which
> has
> > the ACPI error?
> 
> Attached. Yes, the e820 table differs, but power off still works.

Hmm, there seems to be two bugs here.
1. invalid e820 tables, which seems like a BIOS bug, please try to
upgrade your BIOS.
2. poweroff doesn't work.
   Hmm, please try boot option "acpi=off" in both 2.6.25 and 2.6.26.
   I guess power off works on 2.6.25 while it fails on 2.6.26, right?

thanks,
rui


