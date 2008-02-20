Return-Path: <linux-kernel-owner+w=401wt.eu-S934179AbYBTVer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934179AbYBTVer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 16:34:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762851AbYBTVeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 16:34:22 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:12263 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760966AbYBTVeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 16:34:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=YqZzBa+npCfPVh4i4+rPsB4Bxd7aqynV2+3a6A6wutKiUZVc8lyErvamqH4nNvND3eG6llhDKFzbIj/YP5rKc2Atedq81flnPGRl3+FXp9TbpKmVbh5gnZrEfJBJzI6rcLfYVu2Q8lZTdkg7micNFrZPqaEICZt5dTxrNJINlVA=
Date: Wed, 20 Feb 2008 22:31:56 +0100
From: Diego Calleja <diegocg@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: BUG?: "Cannot map mmconfig aperture"
Message-Id: <20080220223156.578e0a5d.diegocg@gmail.com>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get the following new message in my dmesg:

[    0.155476] ACPI: bus type pci registered
[    0.155567] PCI: Found Intel Corporation 945G/GZ/P/PL Express Memory Controller Hub with MMCONFIG support.
[    0.161149] PCI: Cannot map mmconfig aperture for segment 0
[    0.161181] PCI: Using configuration type 1
[    0.165980] ACPI: EC: Look up EC in DSDT

when previously i'd have:

[    0.156577] PCI: Found Intel Corporation 945G/GZ/P/PL Express Memory Controller Hub with MMCONFIG support.
[    0.166403] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.166407] PCI: Using configuration type 1
[    0.171548] ACPI: EC: Look up EC in DSDT


No idea if this is a regression or not, or what it means, the system works well.
git-bisect says the problem cames from:

commit c31c7d4844ea4817692ae16bf70f9c96c05a50eb
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Mon Feb 18 20:54:14 2008 +0100

    x86: CPA, fix alias checks
