Return-Path: <linux-kernel-owner+w=401wt.eu-S1753825AbYLBVzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbYLBVzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 16:55:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbYLBVzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 16:55:38 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:32825 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbYLBVzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 16:55:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=Fz8IaNJ0JI3bZphJotdyXoOMrOqeT7/8glir5miMvPe+f0IeTA6HHhY5v/cmIxQuma
         M+vqFowA3Ka+Ewzf40jeRDZrwB2+r8JF6S66i1wcXpza6DcmolHGeJahkLRpCfAdtdIg
         aqYdg4tSlx9rVyj0/e2fK0yNcqEtUqczs1CX4=
Message-ID: <4935AEDA.5020504@gmail.com>
Date: Tue, 02 Dec 2008 22:55:38 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] check_hung_task(): unsigned sysctl_hung_task_warnings cannot
 be less than 0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unsigned sysctl_hung_task_warnings cannot be less than 0

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
in kernel/softlockup.c

unsigned long __read_mostly sysctl_hung_task_warnings = 10;
...
static void check_hung_task()
{
...
        if (sysctl_hung_task_warnings < 0)
		return
        sysctl_hung_task_warnings--;

diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index 3953e4a..a50a5db 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -188,7 +188,7 @@ static void check_hung_task(struct task_struct *t, unsigned long now)
 	if ((long)(now - t->last_switch_timestamp) <
 					sysctl_hung_task_timeout_secs)
 		return;
-	if (sysctl_hung_task_warnings < 0)
+	if (sysctl_hung_task_warnings == -1)
 		return;
 	sysctl_hung_task_warnings--;
 

