Return-Path: <linux-kernel-owner+w=401wt.eu-S1752071AbYBVFIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbYBVFIO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 00:08:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751108AbYBVFHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 00:07:51 -0500
Received: from fms-01.valinux.co.jp ([210.128.90.1]:35774 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750746AbYBVFHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 00:07:50 -0500
From: Isaku Yamahata <yamahata@valinux.co.jp>
To: linux-kernel@vger.kernel.org
Cc: linux-ia64@vger.kernel.org, yamahata@valinux.co.jp
Subject: [PATCH 00/11] Xen arch portability patches
Date: Fri, 22 Feb 2008 14:07:37 +0900
Message-Id: <12036568683779-git-send-email-yamahata@valinux.co.jp>
X-Mailer: git-send-email 1.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi. Recently the Xen-IA64 community started to make efforts to merge 
xen/ia64 Linux to upstream. The first step is to merge up domU portion.
This patchset is preliminary for xen/ia64 linux making the current
xen/x86 domU code more arch generic and adding missing definitions and
files.

Diffstat:
 arch/x86/xen/Makefile                |    4 +-
 arch/x86/xen/grant-table.c           |   91 +++++++++++++
 drivers/xen/Makefile                 |    3 +-
 {arch/x86 => drivers}/xen/events.c   |   34 ++++--
 {arch/x86 => drivers}/xen/features.c |    0 
 drivers/xen/grant-table.c            |   37 +-----
 drivers/xen/xenbus/xenbus_client.c   |    6 +-
 drivers/xen/xencomm.c                |  232 ++++++++++++++++++++++++++++++++++
 include/asm-x86/xen/hypervisor.h     |   10 ++
 include/asm-x86/xen/interface.h      |   24 ++++
 include/{ => asm-x86}/xen/page.h     |    0 
 include/xen/events.h                 |    1 +
 include/xen/grant_table.h            |    6 +
 include/xen/interface/callback.h     |  119 +++++++++++++++++
 include/xen/interface/grant_table.h  |   11 ++-
 include/xen/interface/vcpu.h         |    5 +
 include/xen/interface/xen.h          |   22 +++-
 include/xen/interface/xencomm.h      |   41 ++++++
 include/xen/page.h                   |  181 +--------------------------
 include/xen/xencomm.h                |   77 +++++++++++
 20 files changed, 673 insertions(+), 231 deletions(-)
