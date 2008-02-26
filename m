Return-Path: <linux-kernel-owner+w=401wt.eu-S1760388AbYBZI3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760388AbYBZI3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 03:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbYBZI3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 03:29:05 -0500
Received: from www.tglx.de ([62.245.132.106]:60591 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbYBZI3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 03:29:04 -0500
Date: Tue, 26 Feb 2008 09:28:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Quel Qun <kelk1@comcast.net>
cc: David Woodhouse <dwmw2@infradead.org>,
       Dave Young <hidave.darkstar@gmail.com>,
       Marcel Holtmann <marcel@holtmann.org>,
       LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] bluetooth: delete timer in l2cap_conn_del()
In-Reply-To: <022620080003.1247.47C35750000085C8000004DF2207300793CE05040A05@comcast.net>
Message-ID: <alpine.LFD.1.00.0802260926550.7583@apollo.tec.linutronix.de>
References: <022620080003.1247.47C35750000085C8000004DF2207300793CE05040A05@comcast.net>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete a possibly armed timer before kfree'ing the connection object.

Solves: http://lkml.org/lkml/2008/2/15/514

Reported-by:Quel Qun <kelk1@comcast.net>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 net/bluetooth/l2cap.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/net/bluetooth/l2cap.c
===================================================================
--- linux-2.6.orig/net/bluetooth/l2cap.c
+++ linux-2.6/net/bluetooth/l2cap.c
@@ -417,6 +417,8 @@ static void l2cap_conn_del(struct hci_co
 		l2cap_sock_kill(sk);
 	}
 
+	del_timer_sync(&conn->info_timer);
+
 	hcon->l2cap_data = NULL;
 	kfree(conn);
 }
