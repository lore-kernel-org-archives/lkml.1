Return-Path: <linux-kernel-owner+w=401wt.eu-S1754945AbYHDKK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbYHDKK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 06:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752748AbYHDKKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 06:10:47 -0400
Received: from qb-out-0506.google.com ([72.14.204.233]:26698 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbYHDKKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 06:10:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=koZI4NYxFu77CbOg4onDDWeTFnsBoHV4E01Qc92O6tNEWdo4ZcsC+6RvnKR9D+BW5c
         tmuzBIvUhFgrn2wTD467VrhYj05XTZ/YPowEAWCghEANCkr7hm0kT4viCJ+JqlHiaz2+
         pA0/7Zuu+g6r9NTKWk0JuLbt1j0g+5IbTYwVQ=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 00/04] dyn_array and nr_irqs support v3 -- addon
Date: Mon,  4 Aug 2008 03:09:57 -0700
Message-Id: <1217844601-4298-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use pre_allocate array and list to index struct with irq_no to avoid
wasting struct between irq

01: x86_64: use get_irq_desc together with dyn_array
02: x86: add get_irq_cfg in io_apic_64.c
03: x86: put timer_rand_state pointer into irq_desc
04: x86: put irq_2_pin pointer into irq_cfg - 64bit

got:
dyn_array irq_2_pin_head+0x0/0x8 size:0x10 nr:32 align:0x10
dyn_array irq_cfgx+0x0/0x8 size:0x120 nr:32 align:0x1000
dyn_array irq_desc+0x0/0x8 size:0x200 nr:32 align:0x1000
dyn_array irq_2_iommu+0x0/0x8 size:0x10 nr:96 align:0x1000
dyn_array total_size: 0x8200
dyn_array irq_2_pin_head+0x0/0x8  ==> [0x28028000 - 0x28028200]
dyn_array irq_cfgx+0x0/0x8  ==> [0x28029000 - 0x2802b400]
dyn_array irq_desc+0x0/0x8  ==> [0x2802c000 - 0x28030000]
dyn_array irq_2_iommu+0x0/0x8  ==> [0x28030000 - 0x28030600]
per_cpu_dyn_array per_cpu__kstat+0x48/0x50 size:0x4 nr:96 align:0x8

irq_cfg/irq_desc will increase by 32 automatically, and the use one by one.

to do:
1. will work ong irq_2_iommu: put it in irq_desc or irq_cfg?
2. will update Eric's patch to move kstat_irqs from per cpu to irq_desc...
3. after that will clean up nr_irqs, and try to kill it

Thanks

Yinghai Lu

