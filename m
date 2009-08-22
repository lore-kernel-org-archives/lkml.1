Return-Path: <linux-kernel-owner+w=401wt.eu-S933225AbZHVSnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933225AbZHVSnG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 14:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933180AbZHVSnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 14:43:05 -0400
Received: from server1.wserver.cz ([82.113.45.157]:57509 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933159AbZHVSnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 14:43:04 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Armin Schindler <mac@melware.de>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 2/2] ISDN: eicon, return on error
Date: Sat, 22 Aug 2009 20:43:04 +0200
Message-Id: <1250966584-29496-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1250966584-29496-1-git-send-email-jirislaby@gmail.com>
References: <1250966584-29496-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When diva_strace_read_uint returns an error, return even from
process_idi_event, because l2_state is uninitialized.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/isdn/hardware/eicon/maintidi.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/hardware/eicon/maintidi.c b/drivers/isdn/hardware/eicon/maintidi.c
index 23960cb..41c26e7 100644
--- a/drivers/isdn/hardware/eicon/maintidi.c
+++ b/drivers/isdn/hardware/eicon/maintidi.c
@@ -959,8 +959,9 @@ static int process_idi_event (diva_strace_context_t* pLib,
 	}
 	if (!strncmp("State\\Layer2 No1", path, pVar->path_length)) {
 		char* tmp = &pLib->lines[0].pInterface->Layer2[0];
-    dword l2_state;
-    diva_strace_read_uint (pVar, &l2_state);
+		dword l2_state;
+		if (diva_strace_read_uint(pVar, &l2_state))
+			return -1;
 
 		switch (l2_state) {
 			case 0:
-- 
1.6.3.3

