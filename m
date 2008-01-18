Return-Path: <linux-kernel-owner+w=401wt.eu-S1760590AbYARAid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760590AbYARAid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 19:38:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757720AbYARAg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 19:36:29 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759920AbYARAgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 19:36:23 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: lguest@ozlabs.org
Cc: glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       rostedt@goodmis.org
Subject: [PATCH 0/7] More lguest massage.
Date: Thu, 17 Jan 2008 22:35:50 -0200
Message-Id: <12006165841070-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12006165781954-git-send-email-gcosta@redhat.com>
References: <1200616550283-git-send-email-gcosta@redhat.com> <12006165571406-git-send-email-gcosta@redhat.com> <1200616561270-git-send-email-gcosta@redhat.com> <12006165651341-git-send-email-gcosta@redhat.com> <12006165701019-git-send-email-gcosta@redhat.com> <12006165743557-git-send-email-gcosta@redhat.com> <12006165781954-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

urrently, lguest module can't be compiled without the PARAVIRT flag being
on.This is a fake dependency, since the module itself shouldn't need any
paravirtoverride. Reason for that is the reference to pv_info structure
ininitial loading tests.

his patch removes it in favour of a more generic error message.

Signed-off-by:Glauber de Oliveira Costa <gcosta@redhat.com>
---
drivers/lguest/core.c |    2 +-
1 files changed, 1 insertions(+), 1 deletions(-)

diff--git a/drivers/lguest/core.c b/drivers/lguest/core.c
indexbb42fd0..97b76d6 100644
---a/drivers/lguest/core.c
+++b/drivers/lguest/core.c
@@-255,7 +255,7 @@ static int __init init(void)

	/* Lguest can't run under Xen, VMI or itself.  It does Tricky Stuff. */
	if (paravirt_enabled()) {
-		printk("lguestis afraid of %s\n", pv_info.name);
+		printk("lguestcan't run under another hypervisor");
		return -EPERM;
	}

--
1.5.0.6

