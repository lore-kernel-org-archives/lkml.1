Return-Path: <linux-kernel-owner+w=401wt.eu-S2992765AbXDDIvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992765AbXDDIvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 04:51:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992762AbXDDIvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 04:51:11 -0400
Received: from ns.oss.ntt.co.jp ([222.151.198.98]:51016 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992765AbXDDIvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 04:51:10 -0400
Subject: [PATCH 0/4] hard_smp_processor_id overhaul (v.2)
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, ak@suse.de, benh@kernel.crashing.org,
       davem@davemloft.net, ebiederm@xmission.com, heiko.carstens@de.ibm.com,
       horms@verge.net.au, ink@jurassic.park.msu.ru, jdike@addtoit.com,
       paulus@samba.org, rth@twiddle.net, schwidefsky@de.ibm.com,
       takata@linux-m32r.org, tony.luck@intel.com, vgoyal@in.ibm.com
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Wed, 04 Apr 2007 17:51:07 +0900
Message-Id: <1175676667.26920.128.camel@sebastian.intellilink.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This new version (v.2) fixes generic arch i386 up build, has (hopefully)
clearer explanations, and does not break git bisect searches.
---
With the advent of kdump, the assumption that the boot CPU when running
an UP kernel is always the CPU with a particular hardware ID (often 0)
(usually referred to as BSP on some architectures) is not valid anymore.
The reason being that the dump capture kernel boots on the crashed CPU
(the CPU that invoked crash_kexec), which may be or may not be that
particular CPU.

As a consequence, the hardcoding of hard_smp_processor_id() to 0 on UP
systems (see "linux/smp.h") is not correct.

This patch-set does the following:

1- Remove hardcoding of hard_smp_processor_id on UP systems (patch 1).

2- Move definition of hard_smp_processor_id for the UP case to
architecture specific code ("asm/smp.h") where it belongs, so that each
architecture can provide its own implementation (patch 1).

3- Ask the hardware when possible to obtain the hardware processor id on
i386 (patch 2), x86_64 (patch 3), and ia64 (patch 4), independently of
whether CONFIG_SMP is set or not.

I guess that something similar could be done for the rest of the
architectures, but since I am not an expert in all of them I am just
moving the definition of hard_smp_processor_id to "asm/smp.h" for those.
Of course, help from the respective maintainers to fill this gap would
be greatly appreciated.

The patches have been tested on i386, x86_64, and ia64.

