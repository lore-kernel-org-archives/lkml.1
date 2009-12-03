Return-Path: <linux-kernel-owner+w=401wt.eu-S1756749AbZLCTOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbZLCTOO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 14:14:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756732AbZLCTOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 14:14:11 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:62352 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756699AbZLCTOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 14:14:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Subject: What's in asm-generic.git
Date: Thu, 3 Dec 2009 19:14:08 +0000
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Chen Liqin <liqin.chen@sunplusct.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912031914.08975.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX184L/vDhOfrrGtnZkXdF96hdLl0blxtxsXIEIi
 +uQHN+PX82uPOwAen82IHvbasjZGUApcT+fHZSDRJe8LQKiCt4
 VN3+8J+X/E4LcdTaWuPxg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the contents of the "next" branch of
git://git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic.git,
as currently found in linux-next.

Only two files are touched, most of the changes are bugfixes
to the lib/checksum.c file that I introduced with the original
asm-generic merge.

If anything is missing here, please tell me.

Diffstat:

 include/asm-generic/unistd.h |    4 ++--
 lib/checksum.c               |   14 ++++++++------
 2 files changed, 10 insertions(+), 8 deletions(-)

Full log:

commit 34b2fb828b63aa1178313ed0478955636dcb49be
Author: Chen Liqin <liqin.chen@sunplusct.com>
Date:   Mon Oct 26 11:09:29 2009 +0800

    asm-generic: Fix typo in asm-generic/unistd.h.
    
    Fixed __NR_ftruncate and __NR_ftruncate64 define in asm-generic/unistd.h.
    
    Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

 include/asm-generic/unistd.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

commit 0a5549ed163520787f76b7515dfe9d9aa1c7ae37
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Tue Jun 23 22:52:51 2009 +0200

    lib/checksum: fix one more thinko
    
    When do_csum gets unaligned data, we really need to treat
    the first byte as an even byte, not an odd byte, because
    we swap the two halves later.
    
    Found by Mike's checksum-selftest module.
    
    Reported-by: Mike Frysinger <vapier.adi@gmail.com>
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

 lib/checksum.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

commit 20c1f641bb80fb272dec959a5caabed92e5a422e
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Tue Jun 23 21:37:26 2009 +0200

    lib/checksum.c: make do_csum optional
    
    Mike Frysinger suggested that do_csum should be optional
    so that an architecture can use the generic checksum code
    but still provide an optimized fast-path for the most
    critical function.
    
    This can mean an implementation using inline assembly,
    or in case of Alpha one using 64-bit arithmetic in C.
    
    Cc: Mike Frysinger <vapier@gentoo.org>
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

 lib/checksum.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

commit c44ba9f6684946b156335da6a6d55f0b8cf7cb72
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Tue Jun 23 21:22:58 2009 +0200

    lib/checksum.c: use 32-bit arithmetic consistently
    
    The use of 'unsigned long' variables in the 32-bit part of do_csum()
    is confusing at best, and potentially broken for long input on 64-bit
    machines.
    
    This changes the code to use 'unsigned int' instead, which makes
    the code behave in the same (correct) way on both 32 and 64 bit
    machines.
    
    Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

 lib/checksum.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)
