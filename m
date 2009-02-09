Return-Path: <linux-kernel-owner+w=401wt.eu-S1755049AbZBIMSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbZBIMSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 07:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbZBIMSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 07:18:30 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:38098 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753335AbZBIMSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 07:18:30 -0500
Subject: mm_alloc()'ed structure leak
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 09 Feb 2009 12:18:18 +0000
Message-Id: <1234181898.16083.26.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2009 12:18:23.0568 (UTC) FILETIME=[80BF7D00:01C98AB0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've noticed on recent kernels (currently 2.6.29-rc3) a memory leak
reported by kmemleak for an mm_struct allocated in mm_alloc(). If that's
a valid leak, it is a pretty serious one.

Basically bash forks and executes a command like "host kernel.org" which
finishes normally but the corresponding mm_struct isn't freed (I get
this consistently every time I run the above command):

unreferenced object 0xcfed4070 (size 368):
  comm "bash", pid 1674, jiffies 421592
  backtrace:
    [<c0082bd4>] kmemleak_alloc+0x140/0x2b0
    [<c007ff2c>] kmem_cache_alloc+0xd0/0x100
    [<c0036980>] mm_alloc+0x14/0x44
    [<c008a99c>] bprm_mm_init+0xc/0x13c
    [<c008ab70>] do_execve+0xa4/0x218
    [<c002718c>] sys_execve+0x34/0x54
    [<c0023e80>] ret_fast_syscall+0x0/0x28

I can't figure out why this structure isn't freed, so any help is
welcomed before I start bisecting. The platform is an ARM one but the
code in question is probably generic.

Thanks.

-- 
Catalin

