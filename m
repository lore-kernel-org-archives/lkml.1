Return-Path: <linux-kernel-owner+w=401wt.eu-S1757135AbZJDCZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135AbZJDCZP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 22:25:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756989AbZJDCZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 22:25:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756833AbZJDCZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 22:25:14 -0400
Date: Sun, 4 Oct 2009 04:20:21 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Daniel Lezcano <dlezcano@fr.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>, roland@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] signals: cosmetic, collect_signal: use SI_USER
Message-ID: <20091004022021.GD21006@redhat.com>
References: <4AC608BE.9020805@fr.ibm.com> <20091003171029.GA30442@us.ibm.com> <20091004021844.GA21006@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091004021844.GA21006@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial, s/0/SI_USER/ in collect_signal() for grep.

This is a bit confusing, we don't know the source of this signal.
But we don't care, and "info->si_code = 0" is imho worse.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- TTT_32/kernel/signal.c~3_COLLECT_SIGNAL	2009-10-04 03:09:44.000000000 +0200
+++ TTT_32/kernel/signal.c	2009-10-04 03:48:48.000000000 +0200
@@ -400,7 +400,7 @@ still_pending:
 		 */
 		info->si_signo = sig;
 		info->si_errno = 0;
-		info->si_code = 0;
+		info->si_code = SI_USER;
 		info->si_pid = 0;
 		info->si_uid = 0;
 	}

