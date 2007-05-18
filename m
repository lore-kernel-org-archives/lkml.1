Return-Path: <linux-kernel-owner+w=401wt.eu-S1759203AbXERAf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759203AbXERAf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 20:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbXERAfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 20:35:22 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50196 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754995AbXERAfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 20:35:22 -0400
Date: Fri, 18 May 2007 01:39:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Francis Russell <francisrussell@btopenworld.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: pata_via appears to incorrectly detects 40-pin cable
Message-ID: <20070518013955.41df5765@the-village.bc.nu>
In-Reply-To: <990930.5739.qm@web86408.mail.ird.yahoo.com>
References: <990930.5739.qm@web86408.mail.ird.yahoo.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007 19:01:43 +0000 (GMT)
Francis Russell <francisrussell@btopenworld.com> wrote:

> I'm testing Linux kernel version 2.6.22-rc1 using Debian Testing on an Acer Ferrari 3400 Laptop. This has a VIA IDE controller with the internal HDD and DVD writer attached. The via_pata module and SCSI disk support is compiled into the kernel and the old ATA subsystem is not. At bootup the log messages state that the main HDD is detected as being connected using a 40-pin cable which causes its speed to be limited to UDMA33 rather then UDMA100, the limit of the HD.  This works fine under the old ATA system.

The old drivers won't bother to tell you if they are limiting to UDMA33,
but they do also contain some BIOS mode snooping hacks which are unsafe
for hotplug, suspend/resume etc and libata doesn't use.

Does the laptop actually have 80 wire cables - did you see UDMA100
actually being used. If so can you send me an lspci -vxx and a dmesg.
Probably we need to add it to the list of devices using short 40 wire
cable tricks.

Alan
