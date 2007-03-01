Return-Path: <linux-kernel-owner+w=401wt.eu-S932985AbXCAHPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932985AbXCAHPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 02:15:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933004AbXCAHPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 02:15:50 -0500
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:45667 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932985AbXCAHPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 02:15:49 -0500
Subject: [PATCH RFC 0/5] hard_smp_processor_id overhaul
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: fastboot@lists.osdl.org, ebiederm@xmission.com, ak@suse.de,
       akpm@linux-foundation.org, judith@linux-foundation.org
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Thu, 01 Mar 2007 16:16:13 +0900
Message-Id: <1172733373.1498.264.camel@sebastian.intellilink.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With the advent of kdump, the assumption that the boot CPU when running
an UP kernel is always the CPU with a hardware ID of 0 (usually referred
to as BSP on some architectures) does not hold true anymore. The reason
being that the dump capture kernel boots on the crashed CPU (the CPU
that invoked crash_kexec).

As a consequence, the hardcoding of hard_smp_processor_id() to 0 on UP
systems (see "linux/smp.h") is not correct.

This patch-set does the following:

1- Remove hardcoding of hard_smp_processor_id on UP systems.

2- Ask the hardware when possible to obtain the hardware processor id on
i386, x86_64, and ia64, independently of whether CONFIG_SMP is set or
not.

3- Move definition of hard_smp_processor_id for the UP case to asm/smp.h
on alpha, m32r, powerpc, s390, sparc, sparc64, and um architectures. I
guess that hardware features could be used to implement
hard_smp_processor_id even in the UP case, but since I am not an expert
in this architectures I just move the definition.

The patches have been tested on i386, x86_64, and ia64.

