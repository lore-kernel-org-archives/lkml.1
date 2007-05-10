Return-Path: <linux-kernel-owner+w=401wt.eu-S1758979AbXEJSyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758979AbXEJSyR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 14:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754627AbXEJSyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 14:54:06 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2381 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978AbXEJSyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 14:54:05 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 10 May 2007 11:54:00 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Charles Gagalac <charle97@yahoo.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bugme-new] [Bug 8462] New: applications under wine freezes
In-Reply-To: <421462.15161.qm@web60013.mail.yahoo.com>
Message-ID: <Pine.LNX.4.64.0705101150340.18318@alien.or.mcafeemobile.com>
References: <421462.15161.qm@web60013.mail.yahoo.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007, Charles Gagalac wrote:

> i just installed the windows version of firefox
> 2.0.0.3 under wine and firefox also froze after a few
> minutes of use.
> 
> also, wine version is wine-0.9.36.

Thank you Charles. Would you mind giving the patch below a try?



- Davide


Index: linux-2.6.21/fs/eventpoll.c
===================================================================
--- linux-2.6.21.orig/fs/eventpoll.c	2007-05-10 11:47:10.000000000 -0700
+++ linux-2.6.21/fs/eventpoll.c	2007-05-10 11:49:47.000000000 -0700
@@ -1410,13 +1410,14 @@
 			 * the ep_poll_callback() can requeue the item again,
 			 * but we don't care since we are already past it.
 			 */
+			epi->rdllink.prev = &epi->rdllink;
 			smp_mb();
-			INIT_LIST_HEAD(&epi->rdllink);
+			epi->rdllink.next = &epi->rdllink;
 		}
 	}
 	error = 0;
 
-	errxit:
+errxit:
 
 	/*
 	 * If the re-injection list or the txlist are not empty, re-splice
