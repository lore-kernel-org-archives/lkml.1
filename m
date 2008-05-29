Return-Path: <linux-kernel-owner+w=401wt.eu-S1758638AbYE2Sod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638AbYE2Sod (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbYE2SoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:44:06 -0400
Received: from smtp-02.datacomm.ch ([212.40.2.27]:39442 "EHLO
	smtp-02.datacomm.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbYE2SoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:44:04 -0400
Subject: Re: >3G => iommu => suspend problems -- was Re: SB600 AHCI: Hard
	Disk Corruption
From: Patrick <ragamuffin@datacomm.ch>
To: Pavel Machek <pavel@suse.cz>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080527112236.GA13957@elf.ucw.cz>
References: <1211717435.6038.53.camel@localhost.localdomain>
	 <20080525173825.GA4132@ucw.cz>
	 <1211746106.6188.57.camel@localhost.localdomain>
	 <20080525203921.GB18781@elf.ucw.cz> <20080525211016.GA32478@elf.ucw.cz>
	 <1211815881.6140.19.camel@localhost.localdomain>
	 <20080527112236.GA13957@elf.ucw.cz>
Content-Type: text/plain
Date: Thu, 29 May 2008 20:44:01 +0200
Message-Id: <1212086641.4625.56.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This goes on top of the second patch... it makes it work.
> 
> 								Pavel
> 

All right. It works! :-) Thank you very much!

I'll describe how I tested:
So far you sent 3 Patches to the list. As I couldn't apply the second
one to my v2.6.26-rc4 tree i had to get git and then your tree. Now I
have a git working tree with two branches *master* and *pavel*,
corresponding to torvalds/linux-2.6 and pavel/work respectively.
I made *pavel* the current branch and issued the following command:

git diff v2.6.26-rc4 	arch/x86/kernel/aperture_64.c \
			arch/x86/kernel/k8.c \
			arch/x86/kernel/pci-gart_64.c \
			drivers/char/agp/generic.c \
			include/asm-x86/gart.h \
	> /home/pat/suspend-vs-iommu.patch

The result is on http://zefir.890m.com/dmesg/

I applied this patch to my old v2.6.26-rc4 tree and recompiled a new
kernel there *, put it in place and rebooted. I suspended several times
since then and put a kernel log of one normal boot process with suspend
from console while X is running (radeonhd) on the site mentioned before.

I'm running debian testing / ubuntu hardy mixed system and used
kernel .config from linux-headers-2.6.25-2-amd64.deb (debian unstable)
with "make oldconfig" and defaults on new options.

The diff is nearly 500 lines long, but i it could be narrowed, I guess.
For me it works perfectly like this though. If you want me to do any
further tests, just say so. I'm trying to get to know git a bit better
and hope to be able to help again sometime. It's great fun!  :-)

Cheers



* I get 
"ACPI: Unable to turn cooling device [ffff81012fa5cdd0] 'off'" every two
seconds and "fancontrol" isn't working any more... going to send a
acpidump to the acpi group. Maybe i'll find out myself as well...
investigating. Not sure if it's caused by the patch.


