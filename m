Return-Path: <linux-kernel-owner+w=401wt.eu-S1758452AbZCBJEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758452AbZCBJEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 04:04:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753582AbZCBJEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 04:04:31 -0500
Received: from mail.gmx.net ([213.165.64.20]:39739 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753459AbZCBJEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 04:04:31 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/bBc1w9uPb8cZ7msS0gA2rlEMbOS/ziF9psw/0He
	MCxvp9zIriW9p2
Subject: x86-tip: xine bustage bisection fingers commit
	97286a2b64725aac2d584ddd1f94871f9991d5a1
From: Mike Galbraith <efault@gmx.de>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 02 Mar 2009 10:04:25 +0100
Message-Id: <1235984665.6195.12.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings and Salutations,

$subject, box is Q6600 X86_64 running v2.6.29-rc6-2261-g0fdaeee

marge:/root # xine
This is xine (X11 gui) - a free video player v0.99.6cvs.
(c) 2000-2007 The xine Team.
Floating point exception

[pid  6230] 06:59:50.524473 set_robust_list(0x40e239f0, 0x18 <unfinished ...>
[pid  6230] 06:59:50.524553 <... set_robust_list resumed> ) = 0 <0.000027>
[pid  6230] 06:59:50.524648 select(0, NULL, NULL, NULL, {0, 500000} <unfinished ...>
[pid  6230] 06:59:50.763988 <... select resumed> ) = ? ERESTARTNOHAND (To be restarted) <0.239321>
[pid  6230] 06:59:50.764012 --- SIGRT_1 (Unknown signal 33) @ 0 (0) ---
[pid  6230] 06:59:50.764074 setuid(0)   = 0 <0.000014>
[pid  6230] 06:59:50.764151 futex(0x7fff2745e7a0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
[pid  6230] 06:59:50.764213 <... futex resumed> ) = 0 <0.000051>
[pid  6230] 06:59:50.764255 futex(0x40e23d2c, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
[pid  6230] 06:59:50.764298 <... futex resumed> ) = 0 <0.000028>
[pid  6230] 06:59:50.764346 rt_sigreturn(0x40e23d2c <unfinished ...>
[pid  6230] 06:59:50.778497 <... rt_sigreturn resumed> ) = 0 <0.014136>
[pid  6230] 06:59:50.778524 --- SIGSEGV (Segmentation fault) @ 0 (0) ---

[ 1303.345419] xine[6230] bad frame in rt_sigreturn frame:0000000040e22c28 ip:7f051ca28622 sp:40e23070 orax:ffffffffffffffff in libc-2.8.so[7f051c95c000+14f000]
﻿
97286a2b64725aac2d584ddd1f94871f9991d5a1 is first bad commit
commit 97286a2b64725aac2d584ddd1f94871f9991d5a1
Author: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Date:   Fri Feb 27 10:28:48 2009 -0800

    x86: signal: intrroduce get_sigframe() and replace get_sigstack()
    
    Impact: cleanup
    
    Introduce get_sigframe() like 32-bit to replace get_sigstack().
    Move the i387 stuff into get_sigframe().
    
    Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

:040000 040000 8362638206eb8aff52e3cfbcff614aac2431c703 81c0844015869d3773673420898f54b55ea36298 M	arch

git bisect start
# good: [20f4d6c3a2a23c5d7d9cc7f42fbb943ca7a03d1f] Linux 2.6.29-rc6
git bisect good 20f4d6c3a2a23c5d7d9cc7f42fbb943ca7a03d1f
# bad: [0fdaeee8594f2ce68e497cdabd9c39ff3a12747c] Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-tip into x86-tip
git bisect bad 0fdaeee8594f2ce68e497cdabd9c39ff3a12747c
# good: [d05aaeb333ccc4bee996c684f81dd47014d14c8a] Merge branch 'auto-warnings-next' into auto-latest
git bisect good d05aaeb333ccc4bee996c684f81dd47014d14c8a
# good: [a91607d4fab1edcd14c2063dad4a3128050d009a] Merge branch 'out-of-tree'
git bisect good a91607d4fab1edcd14c2063dad4a3128050d009a
# good: [7f0f13281741d9135e57991160ebdcc57e95ad4b] Merge branch 'kmemcheck'
git bisect good 7f0f13281741d9135e57991160ebdcc57e95ad4b
# skip: [01bb434893fe62d3504ef4a0a9d24ac04209ace5] Merge branch 'kmemcheck'
git bisect skip 01bb434893fe62d3504ef4a0a9d24ac04209ace5
# bad: [2047d5799675f0d8c5fc939475cdd2913bcb77ea] Merge branch 'kmemcheck'
git bisect bad 2047d5799675f0d8c5fc939475cdd2913bcb77ea
# good: [64e71303e44f3697e4568147caa966de74bdb4fb] Merge git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable
git bisect good 64e71303e44f3697e4568147caa966de74bdb4fb
# good: [f39e09b3b2c11ad1b008518a05bc2b7c25eabc7d] Merge branch 'tracing/ftrace'
git bisect good f39e09b3b2c11ad1b008518a05bc2b7c25eabc7d
# good: [72e97b0f8d9d1d0842af6b47ac0982dc048cbadd] Merge branch 'x86/fixmap'
git bisect good 72e97b0f8d9d1d0842af6b47ac0982dc048cbadd
# good: [39bc66625d7a761f6e5c5b3d81d88e7c9359ca84] kmemcheck: fix split_page() of the page allocator, fix
git bisect good 39bc66625d7a761f6e5c5b3d81d88e7c9359ca84
# bad: [75779f05264b9968d7ae7ecb4ca5127b08785692] x86: signal: unify get_sigframe()
git bisect bad 75779f05264b9968d7ae7ecb4ca5127b08785692
# bad: [97286a2b64725aac2d584ddd1f94871f9991d5a1] x86: signal: intrroduce get_sigframe() and replace get_sigstack()
git bisect bad 97286a2b64725aac2d584ddd1f94871f9991d5a1
# good: [144b0712dd9dd9ebd4e80c4e5388c9f6afc2b497] x86: signal: add __user annotation
git bisect good 144b0712dd9dd9ebd4e80c4e5388c9f6afc2b497


