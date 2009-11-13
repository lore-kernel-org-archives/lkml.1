Return-Path: <linux-kernel-owner+w=401wt.eu-S932562AbZKMX2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562AbZKMX2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 18:28:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932440AbZKMX2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 18:28:14 -0500
Received: from mga06.intel.com ([134.134.136.21]:11893 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932277AbZKMX2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 18:28:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,739,1249282800"; 
   d="scan'208";a="569382152"
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de, x86@kernel.org
Subject: [RFC] x86: cleanup of NX enabling
Date: Fri, 13 Nov 2009 15:28:12 -0800
Message-Id: <1258154897-6770-1-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

Posting this patch series for review; I intend to commit it to
tip:x86/mm unless someone objects over the next few days.

This came about based on Kees' original patch to give better dmesg
information about the status of NX availability.

Jeremy: I'm not 100% this is safe for Xen, as Xen takes its own path
for initialization, so if you could take a quick look, it would be
most appreciated.

 arch/x86/include/asm/proto.h       |    3 +-
 arch/x86/kernel/acpi/sleep.c       |    9 ++----
 arch/x86/kernel/cpu/common.c       |    2 +-
 arch/x86/kernel/head_32.S          |   18 +++++++----
 arch/x86/kernel/machine_kexec_32.c |    6 +--
 arch/x86/kernel/setup.c            |   17 ++++------
 arch/x86/mm/init.c                 |    4 --
 arch/x86/mm/pageattr.c             |    6 ++++
 arch/x86/mm/setup_nx.c             |   59 +++++++++++++++--------------------
 arch/x86/xen/enlighten.c           |    4 +--
 10 files changed, 58 insertions(+), 70 deletions(-)
