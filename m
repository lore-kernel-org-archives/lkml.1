Return-Path: <linux-kernel-owner+w=401wt.eu-S964818AbZKYNXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964818AbZKYNXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:23:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934656AbZKYNXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:23:44 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:52633 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934379AbZKYNXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:23:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=V3THsJXusYc6IOYlDhkehOVrdrl7DvadAxx71Mhc0iZY8AqQ3rerdcO94MjXp5ET1/
         vOma4zymvLIfwYmLe/Bg31iH0jfqKGOlurXl94Fy/8HckzyZms8G+FD7MuHHTUOpwaR9
         TA//k6WqK/lcYlyK49nolwScW3BJdKcoZWSBo=
Message-ID: <4b0d2fe4.0ab6660a.6437.3cfc@mx.google.com>
Date: Wed, 25 Nov 2009 15:23:41 +0200
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sched.c: call debug_show_all_locks when dumping all tasks
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

show_state_filter() failed to call debug_show_all_locks() when specified to
dump all tasks.
Fix: call debug_show_all_locks() when !state_filter (since !state_filter
means "all tasks").

Signed-off-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
---
In commit 39bc89fd4019b164002adaacef92c4140e37955a the interface of
show_state_filter() was changed: zero valued 'state_filter' specifies "dump all
tasks" (instead of -1).
However, the condition for calling debug_show_all_locks() ("show locks if all
tasks are dumped") was not updated accordingly.

diff --git a/kernel/sched.c b/kernel/sched.c
index 3c11ae0..6e2b936 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6935,7 +6935,7 @@ void show_state_filter(unsigned long state_filter)
 	/*
 	 * Only show locks if all tasks are dumped:
 	 */
-	if (state_filter == -1)
+	if (!state_filter)
 		debug_show_all_locks();
 }

-- 
Shmulik Ladkani
