Return-Path: <linux-kernel-owner+w=401wt.eu-S1751762AbZELTPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbZELTPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 15:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbZELTPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 15:15:30 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:43574 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbZELTP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 15:15:29 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 12 May 2009 12:10:23 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Hiroyuki.Mach@gmail.com,
       rohit verma <rohit.170309@gmail.com>
Subject: [patch] epoll - fix size check in epoll_create
Message-ID: <alpine.DEB.1.10.0905121207100.29869@makko.or.mcafeemobile.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, this one-liner fixes a size check WRT the manual pages, that had 
been broken somewhere in the past (might have been Uli with the 
open-with-flags changes, though I'm not sure).



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 fs/eventpoll.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.mod/fs/eventpoll.c
===================================================================
--- linux-2.6.mod.orig/fs/eventpoll.c	2009-05-12 12:05:36.000000000 -0700
+++ linux-2.6.mod/fs/eventpoll.c	2009-05-12 12:05:56.000000000 -0700
@@ -1212,7 +1212,7 @@ SYSCALL_DEFINE1(epoll_create1, int, flag
 
 SYSCALL_DEFINE1(epoll_create, int, size)
 {
-	if (size < 0)
+	if (size <= 0)
 		return -EINVAL;
 
 	return sys_epoll_create1(0);

