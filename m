Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab0CIVrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 16:47:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972Ab0CIVq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 16:46:59 -0500
Date: Tue, 9 Mar 2010 22:45:04 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, David Howells <dhowells@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 3/3] call_usermodehelper: UMH_WAIT_EXEC ignores
	kernel_thread() failure
Message-ID: <20100309214504.GA32632@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UMH_WAIT_EXEC should report the error if kernel_thread() fails, like
UMH_WAIT_PROC does.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/kmod.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- mm/kernel/kmod.c~3_UMH_WAIT_EXEC	2010-03-09 21:56:36.000000000 +0100
+++ mm/kernel/kmod.c	2010-03-09 22:23:37.000000000 +0100
@@ -254,10 +254,10 @@ static void __call_usermodehelper(struct
 	case UMH_WAIT_PROC:
 		if (pid > 0)
 			break;
-		sub_info->retval = pid;
 		/* FALLTHROUGH */
-
 	case UMH_WAIT_EXEC:
+		if (pid < 0)
+			sub_info->retval = pid;
 		complete(sub_info->complete);
 	}
 }

