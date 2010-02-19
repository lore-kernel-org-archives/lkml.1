Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab0BSRd6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:33:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:42351 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab0BSRdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:33:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=OX0/defUzUV2C7RdulNrOj3ZhqxTlc0YUTcWzL1qUB7MLyp11htEh49yxvxFgdDBHH
         Qd8AMr9R1lnvuIAU5IcHplvLd+jkM9k0ttmKcTIl7NSdFb9LQO5TBWkxXxUlbTBM+Ni8
         n2Tw9tQAtO5jXPDJerVRcOu9nJGX9UXBbWHRs=
From: Luca Barbieri <luca@luca-barbieri.com>
To: mingo@elte.hu
Cc: hpa@zytor.com, a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Luca Barbieri <luca@luca-barbieri.com>
Subject: [PATCH 0/5] x86-32: improve atomic64_t functions (v2)
Date: Fri, 19 Feb 2010 18:26:39 +0100
Message-Id: <1266600404-16402-1-git-send-email-luca@luca-barbieri.com>
X-Mailer: git-send-email 1.6.6.1.476.g01ddb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes in v2:
- 386/486 is supported with a custom assembly implementation, the generic
  implementation is no longer used/modified
- dropped SSE code
- changed CALL alternative code to use a custom alternative type:
  insn parser no longer used
- several implementation improvements
- several formatting/style improvements
- merged 386 support into main patch

This patchset improves the atomic64_t functions on x86-32.
It also includes a testsuite that has been used to test this functionality
and can test any atomic64_t implementation.

It offers the following improvements:
1. Better code due to hand-written assembly (e.g. use of the ZF flag)
2. All atomic64 functions implemented
3. Support for 386/486 due to the ability to alternatively use either
   the cmpxchg8b assembly implementation or the 386 cli/popf assembly one

The first patches add functionality to the alternatives system to support
the new atomic64_t code.
A patch that improves cmpxchg64() using that functionality is also included.

To test this code, enable CONFIG_ATOMIC64_SELFTEST, compile for 386 and
boot normally and with "clearcpuid=8".

You should receive a message stating that the atomic64 test passed,
along with the selected configuration.

386/486 SMP is not supported, following existing practice, but the code
is structured to allow to very easily add such support.

Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
