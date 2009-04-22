Return-Path: <linux-kernel-owner+w=401wt.eu-S1752894AbZDVGiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbZDVGiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 02:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751029AbZDVGiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 02:38:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55428 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbZDVGip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 02:38:45 -0400
Date: Wed, 22 Apr 2009 08:38:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Peter Osterlund <petero2@telia.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] include/linux/pktcdvd.h: add mempool.h dependency
Message-ID: <20090422063833.GA23258@elte.hu>
References: <alpine.LFD.2.00.0904212014170.3101@localhost.localdomain> <20090422062053.GA20960@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090422062053.GA20960@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> A last-minute build error slipped through:
>
>   In file included from fs/compat_ioctl.c:105:
>   include/linux/pktcdvd.h:285: error: expected specifier-qualifier-list before ‘mempool_t’

Caused by:

  1ba0c7d: fs/compat_ioctl: fix build when !BLOCK

fixed by the patch below. The build error itself triggers with 
!BLOCK

	Ingo

------------------>
>From f8b664b0e6ad3369a998379e7f87297082d04bef Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 22 Apr 2009 08:29:40 +0200
Subject: [PATCH] include/linux/pktcdvd.h: add mempool.h dependency
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

A change to the order of header files in fs/compat_ioctl.c
unearthed a dormant header file dependency bug:

  In file included from fs/compat_ioctl.c:105:
  include/linux/pktcdvd.h:285: error: expected specifier-qualifier-list before ‘mempool_t’

pktcdvd.h relies on mempool_t but does not include mempool.h.
This worked until now accidentally: due to other headers including
mempool.h in compat_ioctl.c (and all other pktcdvd.h using sites).
But once the header file broke this implicit dependency got
uncovered and an uncleanliness turned into a build failure.

Add mempool.h to pktcdvd.h.

[ Impact: fix build on !CONFIG_BLOCK ]

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/pktcdvd.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/pktcdvd.h b/include/linux/pktcdvd.h
index 04b4d73..9cabc20 100644
--- a/include/linux/pktcdvd.h
+++ b/include/linux/pktcdvd.h
@@ -112,6 +112,7 @@ struct pkt_ctrl_command {
 #include <linux/completion.h>
 #include <linux/cdrom.h>
 #include <linux/kobject.h>
+#include <linux/mempool.h>
 #include <linux/sysfs.h>
 
 /* default bio write queue congestion marks */
