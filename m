Return-Path: <linux-kernel-owner+w=401wt.eu-S1755956AbZA3KTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbZA3KTO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 05:19:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754851AbZA3KRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 05:17:53 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54368 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725AbZA3KRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 05:17:49 -0500
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, lnxninja@linux.vnet.ibm.com
Subject: Genapic cleanup & NUMAQ/es7000 removal
Date: Fri, 30 Jan 2009 11:17:06 +0100
Message-Id: <1233310639-27916-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just to demonstrate the clean up possibilities by removing es7000
and numaq here's a sample patch series. It doesn't actually remove
the es7000/numaq code, but just marks them broken and then
removes all the hooks only used by them. I'm not actually sure
I caught all the now unused hooks, there are probably now more.
Also I think there's still some other NUMAQ only code in smpboot.c
that could be exercised.

This removes 6 hooks and 2 fields out of struct genapic (out of 26
hooks, a reduction of ~23%!) 

The first three patches are independent cleanups that should
be applied anyways.

This gives a nice generic cleanup:

 Kconfig                     |    4 +-
 include/asm/bigsmp/apic.h   |    4 --
 include/asm/genapic.h       |   17 ++----------
 include/asm/setup.h         |    3 --
 include/asm/smpboot_hooks.h |   10 +++----
 kernel/apic.c               |    2 -
 kernel/bigsmp_32.c          |   12 --------
 kernel/es7000_32.c          |   32 ----------------------
 kernel/genapic_flat_64.c    |   16 -----------
 kernel/genx2apic_cluster.c  |    8 -----
 kernel/genx2apic_phys.c     |    8 -----
 kernel/genx2apic_uv_x.c     |    8 -----
 kernel/io_apic.c            |   11 -------
 kernel/numaq_32.c           |   62 --------------------------------------------
 kernel/probe_32.c           |    8 -----
 kernel/setup.c              |   11 -------
 kernel/smpboot.c            |   54 ++------------------------------------
 kernel/summit_32.c          |   12 --------
 18 files changed, 13 insertions(+), 269 deletions(-)

-Andi
