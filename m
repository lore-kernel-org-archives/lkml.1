Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902AbYAIPmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbYAIPmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 10:42:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbYAIPmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 10:42:44 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:51556 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbYAIPmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 10:42:43 -0500
Message-ID: <4784EB6A.5020604@bull.net>
Date: Wed, 09 Jan 2008 16:42:34 +0100
From: Pierre Peiffer <pierre.peiffer@bull.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: ricknu-0@student.ltu.se
Cc: Derbey Nadia <nadia.derbey@bull.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [-mm] new warning in ipc/msg.c
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 09/01/2008 16:50:49,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 09/01/2008 16:50:53,
	Serialize complete at 09/01/2008 16:50:53
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This very small patch:
    ipc-convert-handmade-min-to-min.patch
introduces a new warning when compiling the -mm kernel:

.../linux-2.6.24-rc6-mm1/ipc/msg.c: In function `do_msgrcv':
.../linux-2.6.24-rc6-mm1/ipc/msg.c:939: warning: comparison of distinct pointer
types lacks a cast

I don't know if doing in include/linux/msg.h

struct msg_msg {
	struct list_head m_list;
	long  m_type;
-	int m_ts;           /* message text size */
+	size_t m_ts;           /* message text size */
	struct msg_msgseg* next;
	void *security;
	/* the actual message follows immediately */
};

is acceptable ?

Otherwise, either a cast can be added or this patch can be dropped...

Thanks,

-- 
Pierre Peiffer
