Return-Path: <linux-kernel-owner+w=401wt.eu-S1161479AbXECJx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161479AbXECJx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 05:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161219AbXECJxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 05:53:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031017AbXECJxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 05:53:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/5] [AFS]: Fix memory leak in SRXAFSCB_GetCapabilities
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org, kaber@trash.net, dhowells@redhat.com
Date: Thu, 03 May 2007 10:53:20 +0100
Message-ID: <20070503095320.26912.67210.stgit@warthog.cambridge.redhat.com>
In-Reply-To: <20070503095315.26912.24270.stgit@warthog.cambridge.redhat.com>
References: <20070503095315.26912.24270.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The interface array is not freed on exit.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/cmservice.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/afs/cmservice.c b/fs/afs/cmservice.c
index 6685f4c..d5b2ad6 100644
--- a/fs/afs/cmservice.c
+++ b/fs/afs/cmservice.c
@@ -443,6 +443,7 @@ static void SRXAFSCB_GetCapabilities(struct work_struct *work)
 			reply.ia.netmask[loop] = ifs[loop].netmask.s_addr;
 			reply.ia.mtu[loop] = htonl(ifs[loop].mtu);
 		}
+		kfree(ifs);
 	}
 
 	reply.cap.capcount = htonl(1);

