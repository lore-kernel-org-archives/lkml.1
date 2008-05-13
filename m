Return-Path: <linux-kernel-owner+w=401wt.eu-S1759952AbYEMUQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759952AbYEMUQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759171AbYEMUOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:14:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:38119 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761996AbYEMUOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:14:18 -0400
Date: Tue, 13 May 2008 13:11:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 11/37] SPARC64: Fix args to 64-bit sys_semctl() via
	sys_ipc().
Message-ID: <20080513201156.GL31167@suse.de>
References: <20080513200453.064446337@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sparc64-fix-args-to-64-bit-sys_semctl-via-sys_ipc.patch"
In-Reply-To: <20080513201053.GA31167@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: David S. Miller <davem@davemloft.net>

[ Upstream commit: 020cfb05f2c594c778537159bd45ea5efb0c5e0d ]

Second and third arguments were swapped for whatever reason.

Reported by Tom Callaway.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/kernel/sys_sparc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/sparc64/kernel/sys_sparc.c
+++ b/arch/sparc64/kernel/sys_sparc.c
@@ -454,8 +454,8 @@ asmlinkage long sys_ipc(unsigned int cal
 			err = sys_semget(first, (int)second, (int)third);
 			goto out;
 		case SEMCTL: {
-			err = sys_semctl(first, third,
-					 (int)second | IPC_64,
+			err = sys_semctl(first, second,
+					 (int)third | IPC_64,
 					 (union semun) ptr);
 			goto out;
 		}

-- 
