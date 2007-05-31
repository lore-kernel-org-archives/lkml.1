Return-Path: <linux-kernel-owner+w=401wt.eu-S1759601AbXEaDUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759601AbXEaDUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 23:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756348AbXEaDT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 23:19:59 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:62557 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756171AbXEaDT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 23:19:58 -0400
Subject: Re: [PATCH RT] fix faulting bomb in futex_unlock_pi64
From: Steven Rostedt <rostedt@goodmis.org>
To: john stultz <johnstul@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       Ulrich Drepper <drepper@gmail.com>
In-Reply-To: <1180579953.21781.34.camel@localhost.localdomain>
References: <1180572567.6126.44.camel@localhost.localdomain>
	 <1180579953.21781.34.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 30 May 2007 23:18:44 -0400
Message-Id: <1180581524.21781.39.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

This patch contains both John's and mine for -rt. Might as well make it
a single patch to pull in.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: John Stultz <johnstul@us.ibm.com>

---
Index: linux-2.6.21-rt9/kernel/futex.c
===================================================================
--- linux-2.6.21-rt9.orig/kernel/futex.c	2007-05-30 23:12:34.000000000 -0400
+++ linux-2.6.21-rt9/kernel/futex.c	2007-05-30 23:17:05.000000000 -0400
@@ -1839,6 +1839,7 @@ static int futex_lock_pi(u32 __user *uad
 			ret = -EFAULT;
 			goto out_unlock_release_sem;
 		}
+		uval = 0;
 		goto retry_locked;
 	}
 
@@ -3503,6 +3504,7 @@ pi_faulted:
 			ret = -EFAULT;
 			goto out_unlock;
 		}
+		uval = 0;
 		goto retry_locked;
 	}
 


