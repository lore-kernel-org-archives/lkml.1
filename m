Return-Path: <linux-kernel-owner+w=401wt.eu-S1761390AbXHPG1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761390AbXHPG1F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 02:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758025AbXHPG0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 02:26:53 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54786 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757793AbXHPG0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 02:26:52 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46C3EE1F.40309@s5r6.in-berlin.de>
Date: Thu, 16 Aug 2007 08:26:39 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Gregor Jasny <gjasny@googlemail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux1394-devel@lists.sourceforge.net
Subject: Re: Corrupted filesystem with new Firewire stack
References: <9d2cd630708151447u7e415712u17e974859fbd5481@mail.gmail.com>
In-Reply-To: <9d2cd630708151447u7e415712u17e974859fbd5481@mail.gmail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(full quote for linux1394-devel)

Gregor Jasny wrote at lkml:
> today I got the "status write for unknown orb" during early boot
> sequence. This corrupted somehow my root filesystem which is
> completely located at the external disk.
> 
> Aug 15 23:06:02 Mini kernel: firewire_sbp2: logged in to sbp2 unit fw1.0 (0 retries)
> Aug 15 23:06:02 Mini kernel: firewire_sbp2:  - management_agent_address:    0xfffff0030000
> Aug 15 23:06:02 Mini kernel: firewire_sbp2:  - command_block_agent_address: 0xfffff0100000
> Aug 15 23:06:02 Mini kernel: firewire_sbp2:  - status write address:        0x000100000000
> ...
> Aug 15 23:06:02 Mini kernel: Freeing unused kernel memory: 252k freed
> Aug 15 23:06:02 Mini kernel: firewire_sbp2: status write for unknown orb
> Aug 15 23:06:02 Mini kernel: firewire_sbp2: sbp2_scsi_abort
> 
> After this error with timeout the kernel complained about missing
> symbols in the intel agp module and udev behave strange.

There were some similar reports involving that "status write for unknown
orb".  I haven't found a way to reproduce it; I noticed it only once in
the logs here so far.

> After the next reboot I found the following lines in the kernel logfile:
> 
> Aug 15 23:09:52 Mini kernel: firewire_core: created new fw device fw1 (0 config rom retries)
> Aug 15 23:09:52 Mini kernel: firewire_core: phy config: card 0, new root=ffc1, gap_count=5
> Aug 15 23:09:52 Mini kernel: firewire_ohci: context_stop: still active (0x00000411)
> Aug 15 23:09:52 Mini kernel: firewire_sbp2: management write failed, rcode 0x11
> 
> Sometimes rcode is 0x12:
> Aug 13 22:24:13 Mini kernel: firewire_core: phy config: card 0, new root=ffc0, gap_count=5
> Aug 13 22:24:13 Mini kernel: firewire_sbp2: management write failed, rcode 0x12
> Aug 13 22:24:13 Mini kernel: firewire_sbp2: reconnected to unit fw1.0 (1 retries)

As long as it ends in "reconnected to...", failure messages like this
can typically be ignored.  It cannot be predicted which failures are
transient and which aren't, hence all are logged.

> The system is an early Mac Mini with C2D CPU. The external disk is a
> Formax Oxygen 250 with Oxford OXFW_911 chipset. The Kernel was a
> vanilla 2.6.22.2 with the mactel patches applied.

Among else I too have an Intel Mac mini (running x86-64 Linux though)
and a OXFW911 enclosure with a NTFS formatted disk in it; I'll swap the
disk and try stress tests with a native filesystem.

> Is there anything I can do to help debugging this problem?

Alas this kind of bug is harder to debug remotely, and the root FS isn't
exactly ideal for respective tests...  I'll try to remember to Cc you on
potentially related patches though.
-- 
Stefan Richter
-=====-=-=== =--- =----
http://arcgraph.de/sr/
