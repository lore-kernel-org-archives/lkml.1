Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab0BSRBb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:01:31 -0500
Received: from kroah.org ([198.145.64.141]:57747 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754978Ab0BSRBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:01:02 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:50 2010
Message-Id: <20100219163250.123525413@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:30:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "David S. Miller" <davem@davemloft.net>
Subject: [70/93] pktgen: Fix freezing problem
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rafael J. Wysocki <rjw@sisk.pl>

commit 1b3f720bf033fde1fbb6231f9b156b918c5f68d8 upstream.

Add missing try_to_freeze() to one of the pktgen_thread_worker() code
paths so that it doesn't block suspend/hibernation.

Fixes http://bugzilla.kernel.org/show_bug.cgi?id=15006

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reported-and-tested-by: Ciprian Dorin Craciun <ciprian.craciun@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/core/pktgen.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -3516,6 +3516,7 @@ static int pktgen_thread_worker(void *ar
 			wait_event_interruptible_timeout(t->queue,
 							 t->control != 0,
 							 HZ/10);
+			try_to_freeze();
 			continue;
 		}
 


