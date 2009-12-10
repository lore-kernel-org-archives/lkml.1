Return-Path: <linux-kernel-owner+w=401wt.eu-S1758910AbZLJABW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910AbZLJABW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 19:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758813AbZLJABW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 19:01:22 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:55764 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758801AbZLJABV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 19:01:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ekjK8EqTSFkJxuaHWahNgwWFEbB1vcNfv38WCGubLLjCqyijzfYt2Dg6oS4ATw1PoT
         v6QAidJFb2G5jtTRg+XHPjGwOMlk8iX4gRToIXmGyII0iyGjo8drG6trS6zpohF/uWvO
         z3Awb9/CYHdXyfEHFtd/FioUzsF9tHs1tX+co=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org, torvalds@linux-foundation.org,
       jeremy@goop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] x86: Merge pt_regs using syscalls
Date: Wed,  9 Dec 2009 19:01:50 -0500
Message-Id: <1260403316-5679-1-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set converts the 32-bit syscalls that need pt_regs to
match the same prototype as 64-bit, using regparm(3) and adding 
the pt_regs pointer as an extra argument.  This allows these
syscalls to be merged.

[PATCH 1/6] x86, 32-bit: Add new pt_regs stubs
[PATCH 2/6] x86: Merge sys_iopl
[PATCH 3/6] x86: Merge sys_execve
[PATCH 4/6] x86: Merge sys_sigaltstack
[PATCH 5/6] x86, 32-bit: Convert sys_vm86 & sys_vm86old
[PATCH 6/6] x86: Merge sys_clone

 arch/x86/include/asm/syscalls.h |   32 ++++++--------------
 arch/x86/kernel/entry_32.S      |   61 ++++++++++++++++++++++++++++++++-------
 arch/x86/kernel/ioport.c        |   28 +++--------------
 arch/x86/kernel/process.c       |   35 ++++++++++++++++++++++
 arch/x86/kernel/process_32.c    |   40 -------------------------
 arch/x86/kernel/process_64.c    |   28 ------------------
 arch/x86/kernel/signal.c        |   12 +-------
 arch/x86/kernel/vm86_32.c       |   11 +++----
 8 files changed, 106 insertions(+), 141 deletions(-)
