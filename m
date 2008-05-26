Return-Path: <linux-kernel-owner+w=401wt.eu-S1753942AbYEZPbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbYEZPbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 11:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbYEZPb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 11:31:26 -0400
Received: from smtp-01.datacomm.ch ([212.40.2.26]:55179 "EHLO
	smtp-01.datacomm.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbYEZPbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 11:31:25 -0400
Subject: Re: >3G => iommu => suspend problems -- was Re: SB600 AHCI: Hard
	Disk Corruption
From: Patrick <ragamuffin@datacomm.ch>
To: Pavel Machek <pavel@suse.cz>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080525211016.GA32478@elf.ucw.cz>
References: <1211717435.6038.53.camel@localhost.localdomain>
	 <20080525173825.GA4132@ucw.cz>
	 <1211746106.6188.57.camel@localhost.localdomain>
	 <20080525203921.GB18781@elf.ucw.cz>  <20080525211016.GA32478@elf.ucw.cz>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 26 May 2008 17:31:21 +0200
Message-Id: <1211815881.6140.19.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can you try this one? It should prevent suspend in the broken cases,
> but allow it in mem=4G config.

Sure!

root@babar:/usr/src/linux-2.6.25# patch -p1 < /home/pat/patch-2.6.26-rc3.gart-suspend
patching file arch/x86/kernel/pci-gart_64.c
Hunk #4 succeeded at 629 with fuzz 2 (offset 11 lines).

.....make; cp bzImage /boot; reboot....

without mem=4G:
...
[17180761.682783] CPU1 is down
[17180761.682968] Class suspend failed for gart0
[17180761.683321] PM: Some devices failed to power down
[17180761.683326] Enabling non-boot CPUs ...

with mem=4G:
...
[no change]

-> perfect! Behaves as you predicted.

logs are ... here: http://zefir.890m.com/dmesg/ *


Thanks for attacking the issue really quickly.

I'm ready to do further testing and will try to find enough
time to do one test a day during the week.

Cheers


﻿
* The other host's dns entry is gone, I guess that's because it
had too much requests and was taken down...? Hope this one survives!


