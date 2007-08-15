Return-Path: <linux-kernel-owner+w=401wt.eu-S934227AbXHOVrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934227AbXHOVrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 17:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757213AbXHOVrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 17:47:40 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:3691 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756874AbXHOVrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 17:47:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=T9sEMtL+kDKoLyBYcnxlFX+aVs573B3LpQKaPVw+AaurQxWSvStrc9SRYT9vmajxF3aASCCZPB5W1obNH0okGglfsVgwLBgMsiSq6/gbfl2GOCCKrGK/WRErYkRYDf2nAFoiLKcOzC/Rl0IrBgwnJSSS3jqJo7iE5YTYevEUNv8=
Message-ID: <9d2cd630708151447u7e415712u17e974859fbd5481@mail.gmail.com>
Date: Wed, 15 Aug 2007 23:47:36 +0200
From: "Gregor Jasny" <gjasny@googlemail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Corrupted filesystem with new Firewire stack
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

today I got the "status write for unknown orb" during early boot
sequence. This corrupted somehow my root filesystem which is
completely located at the external disk.

Aug 15 23:06:02 Mini kernel: firewire_sbp2: logged in to sbp2 unit
fw1.0 (0 retries)
Aug 15 23:06:02 Mini kernel: firewire_sbp2:  -
management_agent_address:    0xfffff0030000
Aug 15 23:06:02 Mini kernel: firewire_sbp2:  -
command_block_agent_address: 0xfffff0100000
Aug 15 23:06:02 Mini kernel: firewire_sbp2:  - status write address:
     0x000100000000
...
Aug 15 23:06:02 Mini kernel: Freeing unused kernel memory: 252k freed
Aug 15 23:06:02 Mini kernel: firewire_sbp2: status write for unknown orb
Aug 15 23:06:02 Mini kernel: firewire_sbp2: sbp2_scsi_abort

After this error with timeout the kernel complained about missing
symbols in the intel agp module and udev behave strange.

After the next reboot I found the following lines in the kernel logfile:

Aug 15 23:09:52 Mini kernel: firewire_core: created new fw device fw1
(0 config rom retries)
Aug 15 23:09:52 Mini kernel: firewire_core: phy config: card 0, new
root=ffc1, gap_count=5
Aug 15 23:09:52 Mini kernel: firewire_ohci: context_stop: still active
(0x00000411)
Aug 15 23:09:52 Mini kernel: firewire_sbp2: management write failed, rcode 0x11

Sometimes rcode is 0x12:
Aug 13 22:24:13 Mini kernel: firewire_core: phy config: card 0, new
root=ffc0, gap_count=5
Aug 13 22:24:13 Mini kernel: firewire_sbp2: management write failed, rcode 0x12
Aug 13 22:24:13 Mini kernel: firewire_sbp2: reconnected to unit fw1.0
(1 retries)

The system is an early Mac Mini with C2D CPU. The external disk is a
Formax Oxygen 250 with Oxford OXFW_911 chipset. The Kernel was a
vanilla 2.6.22.2 with the mactel patches applied.

Is there anything I can do to help debugging this problem?

Thanks,
Gregor
