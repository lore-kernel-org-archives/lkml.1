Return-Path: <linux-kernel-owner+w=401wt.eu-S1763449AbXKJCM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763449AbXKJCM4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 21:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753557AbXKJCMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 21:12:49 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:42912 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbXKJCMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 21:12:48 -0500
Date: Fri, 9 Nov 2007 21:12:47 -0500
Message-Id: <200711100212.lAA2Cll0015004@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org
Subject: WARNING: at lib/kref.c:33 kref_get() (-mm 2007-11-06-02-32++)
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Setup: FC6 system with MM snapshot broken-out-2007-11-06-02-32 and these two
patches added:

r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch

Booting the machine, waiting a few minutes (not logging in or doing anything
else).  I get:

WARNING: at lib/kref.c:33 kref_get()
 [<c020282a>] show_trace_log_lvl+0x12/0x25
 [<c0203024>] show_trace+0xd/0x10
 [<c0203120>] dump_stack+0x15/0x17
 [<c02c7f85>] kref_get+0x26/0x30
 [<c02c731b>] kobject_get+0x12/0x17
 [<c02c7770>] kobject_add+0x97/0x162
 [<c02164e5>] uids_user_create+0x41/0x5d
 [<c0216850>] alloc_uid+0xc9/0x171
 [<c0219b50>] set_user+0x1f/0x93
 [<c021b445>] sys_setuid+0x4b/0xcb
 [<c02021fe>] sysenter_past_esp+0x5f/0x91
 =======================

There's no other indication where the setuid(2) came from, perhaps cron?

Erez.
