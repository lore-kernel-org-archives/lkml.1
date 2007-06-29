Return-Path: <linux-kernel-owner+w=401wt.eu-S933895AbXF2Qo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933895AbXF2Qo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 12:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754616AbXF2QoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 12:44:18 -0400
Received: from mail.suse.de ([195.135.220.2]:36609 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756560AbXF2QoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 12:44:18 -0400
Message-ID: <46853764.8020608@suse.de>
Date: Fri, 29 Jun 2007 18:46:28 +0200
From: Alexander Graf <agraf@suse.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] fix logic error in ipc compat semctl()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

when calling a semctl(IPC_STAT) without IPC_64 the check if the memory
is unevaluated. This patch fixes this.

Signed-off-by: Alexander Graf <agraf@suse.de>

Index: linux/ipc/compat.c
===================================================================
--- linux.orig/ipc/compat.c
+++ linux/ipc/compat.c
@@ -225,7 +225,7 @@ static inline int put_compat_semid_ds(st
        int err;
 
        if (!access_ok (VERIFY_WRITE, up, sizeof(*up)))
-               err = -EFAULT;
+               return -EFAULT;
        err  = __put_compat_ipc_perm(&s->sem_perm, &up->sem_perm);
        err |= __put_user(s->sem_otime, &up->sem_otime);
        err |= __put_user(s->sem_ctime, &up->sem_ctime);

