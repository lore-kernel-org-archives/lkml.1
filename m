Return-Path: <linux-kernel-owner+w=401wt.eu-S1756222AbYC1Lko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222AbYC1Lko (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 07:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753809AbYC1LkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 07:40:20 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:44520 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752742AbYC1LkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 07:40:19 -0400
From: Isaku Yamahata <yamahata@valinux.co.jp>
To: jeremy@goop.org
Cc: chrisw@sous-sol.org, sct@redhat.com,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       xen-ia64-devel@lists.xensource.com, eddie.dong@intel.com,
       yamahata@valinux.co.jp
Subject: [PATCH 00/12] Xen arch portability patches (take 4)
Date: Fri, 28 Mar 2008 20:40:06 +0900
Message-Id: <12067044183207-git-send-email-yamahata@valinux.co.jp>
X-Mailer: git-send-email 1.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeremy.
According to your suggestion, I recreated patches for Ingo's x86.git tree.
And this patch series includes Eddie's modification.
Please review and forward them. (or push back to respin.)


Recently the xen-ia64 community started to make efforts to merge
xen/ia64 Linux to upstream. The first step is to merge up domU portion.
This patchset is preliminary for xen/ia64 domU linux making the current
xen/x86 domU code more arch generic and adding missing definitions and
files.

Changes from the last version.
- revised commit log messages.
- split up the modifications to events.c into three patches.
- minor changes caused by rebase.

Diffstat:
 arch/x86/xen/Makefile                |    4 +-
 arch/x86/xen/grant-table.c           |   91 +++++++++++++
 arch/x86/xen/xen-ops.h               |    2 +-
 drivers/xen/Makefile                 |    3 +-
 {arch/x86 => drivers}/xen/events.c   |   34 ++++--
 {arch/x86 => drivers}/xen/features.c |    0 
 drivers/xen/grant-table.c            |   37 +-----
 drivers/xen/xenbus/xenbus_client.c   |    6 +-
 drivers/xen/xencomm.c                |  232 ++++++++++++++++++++++++++++++++++
 include/asm-x86/xen/hypervisor.h     |   13 ++
 include/asm-x86/xen/interface.h      |   24 ++++
 include/{ => asm-x86}/xen/page.h     |    0 
 include/xen/events.h                 |    1 +
 include/xen/grant_table.h            |    6 +
 include/xen/interface/grant_table.h  |   11 ++-
 include/xen/interface/vcpu.h         |    5 +
 include/xen/interface/xen.h          |   22 +++-
 include/xen/interface/xencomm.h      |   41 ++++++
 include/xen/page.h                   |  169 +------------------------
 include/xen/xen-ops.h                |    8 ++
 include/xen/xencomm.h                |   77 +++++++++++
 21 files changed, 565 insertions(+), 221 deletions(-)


