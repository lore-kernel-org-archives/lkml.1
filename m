Return-Path: <linux-kernel-owner+w=401wt.eu-S1763403AbZENXLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763403AbZENXLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 19:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762346AbZENW7B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:59:01 -0400
Received: from kroah.org ([198.145.64.141]:46082 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761028AbZENW6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:58:45 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu May 14 15:52:39 2009
Message-Id: <20090514225239.679485921@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 May 2009 15:51:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Davide Libenzi <davidel@xmailserver.org>,
       <Hiroyuki.Mach@gmail.com>, rohit verma <rohit.170309@gmail.com>,
       Ulrich Drepper <drepper@redhat.com>
Subject: [patch 20/28] epoll: fix size check in epoll_create()
References: <20090514225126.907908936@mini.kroah.org>
Content-Disposition: inline; filename=epoll-fix-size-check-in-epoll_create.patch
In-Reply-To: <20090514225413.GA705@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Davide Libenzi <davidel@xmailserver.org>

commit bfe3891a5f5d3b78146a45f40e435d14f5ae39dd upstream.

Fix a size check WRT the manual pages.  This was inadvertently broken by
commit 9fe5ad9c8cef9ad5873d8ee55d1cf00d9b607df0 ("flag parameters
add-on: remove epoll_create size param").

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: <Hiroyuki.Mach@gmail.com>
Cc: rohit verma <rohit.170309@gmail.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/eventpoll.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1132,7 +1132,7 @@ error_return:
 
 SYSCALL_DEFINE1(epoll_create, int, size)
 {
-	if (size < 0)
+	if (size <= 0)
 		return -EINVAL;
 
 	return sys_epoll_create1(0);


