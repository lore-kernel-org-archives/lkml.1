Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbXLGAZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbXLGAZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 19:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbXLGAZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 19:25:30 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41595 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752226AbXLGAZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 19:25:29 -0500
Date: Thu, 6 Dec 2007 16:25:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Marco Gatti <marco@pianoinflames.de>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Bug: get EXT3-fs error Allocating block in system zone
Message-Id: <20071206162500.1f76a234.akpm@linux-foundation.org>
In-Reply-To: <4755BEA1.4090604@pianoinflames.de>
References: <4755BEA1.4090604@pianoinflames.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Dec 2007 21:54:57 +0100
Marco Gatti <marco@pianoinflames.de> wrote:

> Hello,
> 
> I have a brand new Fujitsu-Siemens Celsius W360 pc with a FSC D2587-A1 
> motherboard. It has a intel q35 chipset. In bios I have the sata 
> controller in pure AHCI mode (legacy pata disabled). On windows 
> everthing works fine. So mem is ok, too, tested with memtest+ overnight. 
> No failures with hdd or motherboard on windows. There's latest avaiable 
> BIOS version on the machine.
> 
> Specific system data see below.
> 
> I first tried self compiled kernel 2.6.24-rc3 and now at the end 
> 2.6.23.9 to have a stable version. I got compiled e1000 module for 
> network card onboard under latest gentoo stable version.
> 
> I first got acpi failure on boot, pci=nommconf worked first time, than I 
> patched with q35.pci.patch from 
> http://bugs.gentoo.org/show_bug.cgi?id=198810 and boot worked without 
> nommconf.

http://bugs.gentoo.org/attachment.cgi?id=135761&action=view

It disables PCI BARs during sizing.  ISTR Linus opining that this was the
wrong thing to do?

ISTR him having opinions on mmconfig too ;)

We should not require people to use obscure boot options to get their
machines working.

> But the effect is under every circumstances described above that I got 
> after an unspecific time EXT3-fs errors. I tried to use different 
> partitions, one for root and data, got errors on both.
> 
> Dec  3 15:05:34 adira EXT3-fs error (device sdb4): ext3_new_block: 
> Allocating block in system zone - blocks from 74907667, length 1
> 
> I tried different hard disks, different sizes of partitions, always the 
> same issue. I always saw that mem is fully cached (I have 8GB RAM!). 
> After that, the ext3 has severe faults fsck.ext3 repaired them, but an 
> amount of data was lost.
> 
> I also tried with different file systems (reiserfs3, xfs), also kernel 
> trace errors, so I got back to ext3.
> 
> Can't believe that it's a pure fs-error. Is it an ahci.c issue? Or a 
> problem with acpi and memory management?

At a guess I'd say the disk system is being bad.  it might be a hardware
failure too - it's a new system.

> Any ideas for fixing this?
> 

Nope, sorry.
