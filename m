Return-Path: <linux-kernel-owner+w=401wt.eu-S1755736AbZFKP0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736AbZFKP0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 11:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbZFKP0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 11:26:42 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:14256 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbZFKP0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 11:26:41 -0400
From: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
To: davej@codemonkey.org.uk
Cc: Naga Chumbalkar <nagananda.chumbalkar@hp.com>, andreas.herrmann3@amd.com,
       linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
       mark.langsdorf@amd.com, trenn@suse.de
Message-Id: <20090611152558.8510.75249.sendpatchset@linux-fd7s.americas.hpqcorp.net>
Subject: [PATCH 0/2] powernow-k8: fix incorrect value reported in cpuinfo_cur_freq
Date: Thu, 11 Jun 2009 15:26:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "cpuinfo_cur_freq" value reported in /sys is incorrect.

For example, on a 1P quad-core AMD platform (cores: 0,1,2,3) if you want the
"cpuinfo_cur_freq" for core2, you will actually get the value for core0. The
bug is apparent when all the cores are not at the same frequency.

Prior to 2.6.27.8, "cpuinfo_cur_freq" used to return the correct value because
query_current_values_with_pending_wait() obtained the P-state for core2 from
HW, and overwrote the "currpstate" for core0 with it.

However, that got broken with the commit:
a266d9f1253a38ec2d5655ebcd6846298b0554f4

This patch fixes the regression by:
- special-casing the AMD erratum 311 (discussed in the above commit) to AMD
Family 11h processors only
- cleaning up the way powernowk8_get() obtains the per-CPU data

 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   31 +++++++++++-----------------
 1 files changed, 12 insertions(+), 19 deletions(-)

Thanks,
- naga -


