Return-Path: <linux-kernel-owner+w=401wt.eu-S1752146AbZHXLFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbZHXLFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 07:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbZHXLFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 07:05:33 -0400
Received: from mx1.melware.net ([78.47.171.162]:50662 "EHLO mx1.melware.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbZHXLFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 07:05:32 -0400
Date: Mon, 24 Aug 2009 13:05:34 +0200 (CEST)
From: Armin Schindler <armin@melware.de>
To: Jiri Slaby <jirislaby@gmail.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ISDN: eicon, return on error
In-Reply-To: <1250966584-29496-2-git-send-email-jirislaby@gmail.com>
Message-ID: <alpine.DEB.2.00.0908241305080.5388@justus.melware.de>
References: <1250966584-29496-1-git-send-email-jirislaby@gmail.com> <1250966584-29496-2-git-send-email-jirislaby@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
Organization: Cytronics & Melware
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When diva_strace_read_uint returns an error, return even from
process_idi_event, because l2_state is uninitialized.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Armin Schindler <armin@melware.de>
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
