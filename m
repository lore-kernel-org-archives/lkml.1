Return-Path: <linux-kernel-owner+w=401wt.eu-S1758275AbXISJgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275AbXISJgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 05:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756524AbXISJgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 05:36:25 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2168 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756406AbXISJgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 05:36:24 -0400
Date: Wed, 19 Sep 2007 10:36:14 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: 2.6.23-rc6-mm1 -- powerpc pSeries_log_error panic in rtas_call/early_enable_eeh
Message-ID: <20070919093614.GH973@shadowen.org>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070918011841.2381bd93.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Seeing the following panic booting an old powerpc LPAR:

Unable to handle kernel paging request for data at address 0x00000000
Faulting instruction address: 0xc000000000047b48
cpu 0x0: Vector: 300 (Data Access) at [c0000000006a3750]
    pc: c000000000047b48: .pSeries_log_error+0x364/0x420
    lr: c000000000047acc: .pSeries_log_error+0x2e8/0x420
    sp: c0000000006a39d0
   msr: 8000000000001032
   dar: 0
 dsisr: 42000000
  current = 0xc0000000005acab0
  paca    = 0xc0000000005ad700
    pid   = 0, comm = swapper
enter ? for help
[c0000000006a3af0] c000000000021164 .rtas_call+0x200/0x250
[c0000000006a3ba0] c000000000049d50 .early_enable_eeh+0x168/0x360
[c0000000006a3c70] c00000000002f674 .traverse_pci_devices+0x8c/0x138
[c0000000006a3d10] c000000000560ce8 .eeh_init+0x1a8/0x200
[c0000000006a3db0] c00000000055fb70 .pSeries_setup_arch+0x128/0x234
[c0000000006a3e40] c00000000054f830 .setup_arch+0x214/0x24c
[c0000000006a3ee0] c000000000546a38 .start_kernel+0xd4/0x3e4
[c0000000006a3f90] c00000000045adc4 .start_here_common+0x54/0x58
0:mon>

This machine is:

# cat /proc/cpuinfo
processor       : 0
cpu             : POWER4+ (gq)
clock           : 1703.965296MHz
revision        : 19.0

[...]
machine         : CHRP IBM,7040-681

-apw
