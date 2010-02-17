Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345Ab0BQLm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 06:42:57 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:39794 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab0BQLm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 06:42:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=et7oTP65VS2qxgaRpeHl6SEnU6KPho0h47LFUxvUABTGDsAT+fkWTlAnPqPmcMEwcM
         23UkOm7NMLrg7ntDighVxknp9+vuvugkyPW78YtOUpdGn5a+UnKKStBWUj7dfFFo8zYs
         iKv6KaEmiOV3q+HB+5YiBpKJ/KT6GqcvQ16mE=
From: Luca Barbieri <luca@luca-barbieri.com>
To: mingo@elte.hu
Cc: hpa@zytor.com, a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Luca Barbieri <luca@luca-barbieri.com>
Subject: [PATCH 0/10] x86-32: improve atomic64_t functions
Date: Wed, 17 Feb 2010 12:42:32 +0100
Message-Id: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
X-Mailer: git-send-email 1.6.6.1.476.g01ddb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset improves the atomic64_t functions on x86-32.
It also includes a testsuite that has been used to test this functionality
and can test any atomic64_t implementation.

It offers the following improvements:
1. Better code due to hand-written assembly (e.g. use of the ZF flag)
2. All atomic64 functions implemented, efficiently
3. Support for 386/486 due to the ability to alternatively use either
   the cmpxchg8b based implementation or the generic implementation
4. Use of SSE, if available, for atomic64_read and atomic64_set

The first patches add functionality to the alternatives system to support
the new atomic64_t code.
A patch that improves cmpxchg64() using that functionality is also included.

To test this code, enable CONFIG_ATOMIC64_SELFTEST, compile for 386 and
boot normally, with "clearcpuid=25" and with "clearcpuid=8 clearcpuid=25".

You should receive a message stating that the atomic64 test passed,
along with the selected configuration.

Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>

