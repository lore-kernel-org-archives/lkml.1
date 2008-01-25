Return-Path: <linux-kernel-owner+w=401wt.eu-S1760740AbYAYVS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760740AbYAYVS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 16:18:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757148AbYAYVSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 16:18:39 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:15844 "EHLO
	outbound3-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756757AbYAYVSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 16:18:38 -0500
X-Greylist: delayed 1457 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jan 2008 16:18:37 EST
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Avi Kivity" <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH][RFC] SVM: Add Support for Nested Paging in AMD Fam16
 CPUs
Date: Fri, 25 Jan 2008 21:53:05 +0100
Message-ID: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
X-OriginalArrivalTime: 25 Jan 2008 20:53:16.0802 (UTC)
 FILETIME=[4F2A2620:01C85F94]
MIME-Version: 1.0
X-WSS-ID: 6B8493E10QK8882748-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,                                                                                                                              

here is the first release of patches for KVM to support the Nested Paging (NPT)
feature of AMD QuadCore CPUs for comments and public testing. This feature
improves the guest performance significantly. I measured an improvement of
around 17% using kernbench in my first tests.

This patch series is basically tested with Linux guests (32 bit legacy
paging, 32 bit PAE paging and 64 bit Long Mode). Also tested with Windows Vista
32 bit and 64 bit. All these guests ran successfully with these patches. The
patch series only enables NPT for 64 bit Linux hosts at the moment.

Please give these patches a good and deep testing. I hope we have this patchset
ready for merging soon.

Joerg

Here is the diffstat:

 arch/x86/kvm/mmu.c         |   81 +++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/mmu.h         |    6 +++
 arch/x86/kvm/svm.c         |   94 +++++++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx.c         |    7 +++
 arch/x86/kvm/x86.c         |    1 +
 include/asm-x86/kvm_host.h |    4 ++
 6 files changed, 182 insertions(+), 11 deletions(-)




