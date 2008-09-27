Return-Path: <linux-kernel-owner+w=401wt.eu-S1753801AbYI0Spx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbYI0Spx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 14:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752958AbYI0Spo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 14:45:44 -0400
Received: from khc.piap.pl ([195.187.100.11]:45059 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733AbYI0Spo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 14:45:44 -0400
To: "Brandeburg\, Jesse" <jesse.brandeburg@intel.com>
Cc: "Tim Gardner" <timg@tpi.com>, "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       "Jiri Kosina" <jkosina@suse.cz>, "LKML" <linux-kernel@vger.kernel.org>,
       <agospoda@redhat.com>, "Ronciak\, John" <john.ronciak@intel.com>,
       "Allan\, Bruce W" <bruce.w.allan@intel.com>,
       "Graham\, David" <david.graham@intel.com>, <kkiel@suse.de>,
       <tglx@linutronix.de>, <chris.jones@canonical.com>,
       <arjan@linux.jf.intel.com>
Subject: Re: e1000e NVM corruption issue status
References: <987CEB09A2567F4A963E1E226364E2D33A685B4B@orsmsx418.amr.corp.intel.com>
	<48DCCC5F.8040609@linux.intel.com>
	<200809261052.38966.jbarnes@virtuousgeek.org>
	<200809261123.52198.jbarnes@virtuousgeek.org>
	<48DD2F98.8070509@tpi.com> <m34p42mumu.fsf@maximus.localdomain>
	<36D9DB17C6DE9E40B059440DB8D95F5206446B4E@orsmsx418.amr.corp.intel.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 27 Sep 2008 20:45:41 +0200
In-Reply-To: <36D9DB17C6DE9E40B059440DB8D95F5206446B4E@orsmsx418.amr.corp.intel.com> (Jesse Brandeburg's message of "Fri\, 26 Sep 2008 15\:23\:39 -0700")
Message-ID: <m3wsgx77hm.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Brandeburg, Jesse" <jesse.brandeburg@intel.com> writes:

> ICH 8/9/10 machines with Intel gigabit part integrated (82566/82567)
> share the system Flash space with all the other system devices, BIOS,
> etc.  The gigabit region is the currently only "unprotected" region I
> know of.  It is never directly memory mapped, but the registers that
> program to it are memory mapped from our BAR1, like Tim said, possibly
> only requiring an errant write of a few bits of ones, to erase it (I've
> been trying to confirm that)

I don't know the ICH 8/9/10 very well but it seems typical, i.e., the
flash is a X Mbit device usually mapped at some really high address
and then copied/decompressed to RAM ("shadow ROM" at the usual
locations 0xC0000 for VGA, 0xF0000 or so for system BIOS, something
between the two for Ethernet PXE).

Is the protection you write about the hardware flash region
protection? It can be easily removed by another command (another
write).

Anyway the problem in question is EEPROM, not flash?


I'm sure that simply erasing the PXE flash region would not prevent
the machine from booting. The BIOS requires a valid signature (55AA or
so) at the start of a BIOS extension block, and there is a checksum.

I also think that blindly erasing some regions of flash, or blindly
writing to it wouldn't kill the machine completely - there is a
boot block which is almost certainly protected (requires a command to
unblock). The boot block should notice the main BIOS image is
corrupted and should allow reflashing (using a DOS diskette and
perhaps without VGA output).
-- 
Krzysztof Halasa
