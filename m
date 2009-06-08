Return-Path: <linux-kernel-owner+w=401wt.eu-S1755543AbZFHUy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbZFHUy1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 16:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbZFHUyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 16:54:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37116 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbZFHUyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 16:54:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Bug #13306] hibernate slow on _second_ run
Date: Mon, 8 Jun 2009 22:54:29 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
References: <4to6E2myxvG.A.muC.aIbIKB@chimera> <200906032351.01900.rjw@sisk.pl> <1244125570.22576.78.camel@johannes.local>
In-Reply-To: <1244125570.22576.78.camel@johannes.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906082254.30138.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 June 2009, Johannes Berg wrote:
> Alright, I have managed to trace this.
> 
> http://johannes.sipsolutions.net/files/hibernate-delay-dmesg.txt
> 
> has the dmesg, you can clearly see the delay:
> [50265.143330] ACPI: Waking up from system sleep state S4
> [50265.679141] HDA Intel 0000:00:08.0: restoring config space at offset 0x1 (was 0xb00006, writing 0xb00002)
> [50265.689525] forcedeth 0000:00:0a.0: restoring config space at offset 0x1 (was 0xb00003, writing 0xb00007)
> [50265.699775] ahci 0000:00:0b.0: restoring config space at offset 0x1 (was 0xb00403, writing 0xb00407)
> [50286.294910] pci 0000:00:03.2: PME# disabled

Quite frankly, it looks like resume_device_irqs() itself causes the delay to happen.

The next step would be to put a couple of printk()s in there and see which part
of it triggers the delay.

Best,
Rafael
