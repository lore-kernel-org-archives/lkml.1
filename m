Return-Path: <linux-kernel-owner+w=401wt.eu-S1756437AbZJDMxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437AbZJDMxf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 08:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754474AbZJDMxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 08:53:34 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:60017 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754425AbZJDMxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 08:53:31 -0400
Message-Id: <20091004124946.788396453@I-love.SAKURA.ne.jp>
User-Agent: quilt/0.46-1
Date: Sun, 04 Oct 2009 21:49:46 +0900
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [TOMOYO #16 00/25] Starting TOMOYO 2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

This is the beginning of TOMOYO 2.3. TOMOYO 2.2 (which is in kernel 2.6.30 and
later) is terribly lacking in functionality (e.g. no audit logs, no network).
I hope TOMOYO 2.3 can provide practically sufficient functionality.

This patchset provides almost all functionality in TOMOYO 1.7.0 except
(1) DAC before MAC checks for directory modification operations.
(2) Incoming UDP/RAW packet filtering.
(3) Signal transmission restriction.
(4) Many of non-posix capabilities support.

Since this patchset is not yet accepted, I haven't written documentation for
TOMOYO 2.3. You can see http://tomoyo.sourceforge.jp/1.7/policy-reference.html
instead.

Conventionally, patches should be submitted in the form of diff file.
But this time, I submit in the form of entire file due to amount of changes.

# diff -u security/tomoyo.2.2/realpath.c security/tomoyo/new-realpath.c | diffstat -f0
 new-realpath.c |  609  186 +   423 -   0 !
 1 file changed, 186 insertions(+), 423 deletions(-)
# wc -l security/tomoyo/new-realpath.c
251 security/tomoyo/new-realpath.c

# diff -u security/tomoyo.2.2/file.c security/tomoyo/new-file.c | diffstat -f0
 new-file.c | 2472      1693 +  779 -   0 !
 1 file changed, 1693 insertions(+), 779 deletions(-)
# wc -l security/tomoyo/new-file.c
2249 security/tomoyo/new-file.c

# diff -u security/tomoyo.2.2/domain.c security/tomoyo/new-domain.c | diffstat -f0
 new-domain.c | 1322    877 +   445 -   0 !
 1 file changed, 877 insertions(+), 445 deletions(-)
# wc -l security/tomoyo/new-domain.c
1354 security/tomoyo/new-domain.c

# diff -u security/tomoyo.2.2/tomoyo.c security/tomoyo/lsm.c | diffstat -f0
 lsm.c |  492   350 +   142 -   0 !
 1 file changed, 350 insertions(+), 142 deletions(-)
# wc -l security/tomoyo/lsm.c
523 security/tomoyo/lsm.c

# diff -Nur security/tomoyo.2.2/ security/tomoyo/ | diffstat -f0
 Kconfig         |   67         67 +    0 -     0 !
 Makefile        |    2         1 +     1 -     0 !
 address_group.c |  270         270 +   0 -     0 !
 audit.c         |  561         561 +   0 -     0 !
 capability.c    |  141         141 +   0 -     0 !
 common.c        | 2276         0 +     2276 -  0 !
 common.h        |  461         0 +     461 -   0 !
 condition.c     | 1332         1332 +  0 -     0 !
 domain.c        |  922         0 +     922 -   0 !
 environ.c       |  232         232 +   0 -     0 !
 file.c          | 1335         0 +     1335 -  0 !
 gc.c            |  606         606 +   0 -     0 !
 internal.h      | 1317         1317 +  0 -     0 !
 load_policy.c   |   97         97 +    0 -     0 !
 lsm.c           |  523         523 +   0 -     0 !
 memory.c        |  391         391 +   0 -     0 !
 mount.c         |  366         366 +   0 -     0 !
 network.c       |  757         757 +   0 -     0 !
 new-domain.c    | 1354         1354 +  0 -     0 !
 new-file.c      | 2249         2249 +  0 -     0 !
 new-realpath.c  |  251         251 +   0 -     0 !
 number_group.c  |  212         212 +   0 -     0 !
 path_group.c    |  210         210 +   0 -     0 !
 policy_io.c     | 2734         2734 +  0 -     0 !
 realpath.c      |  488         0 +     488 -   0 !
 realpath.h      |   66         0 +     66 -    0 !
 securityfs_if.c |  148         148 +   0 -     0 !
 tomoyo.c        |  315         0 +     315 -   0 !
 tomoyo.h        |   96         0 +     96 -    0 !
 util.c          | 1144         1144 +  0 -     0 !
 30 files changed, 14963 insertions(+), 5960 deletions(-)

Regards.
-- 
