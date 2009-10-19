Return-Path: <linux-kernel-owner+w=401wt.eu-S1755193AbZJSIjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbZJSIjr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 04:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbZJSIjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 04:39:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33282 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbZJSIjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 04:39:46 -0400
Date: Mon, 19 Oct 2009 10:39:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Arjan van de Ven <arjan@infradead.org>,
       David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] nfs: Fix nfs_parse_mount_options() kfree() leak
Message-ID: <20091019083934.GA28434@elte.hu>
References: <86802c440910182252v4648a7d1k249d091799583e37@mail.gmail.com> <1255933848.11116.2.camel@heimdal.trondhjem.org> <20091019065433.GA29550@elte.hu> <1255935518.18914.0.camel@penberg-laptop> <20091019070825.GA16493@elte.hu> <86802c440910190031m33e116d3o90869de5212bb2e@mail.gmail.com> <1255938774.11116.35.camel@heimdal.trondhjem.org> <20091019080403.GA24036@elte.hu> <20091019082333.GA27410@elte.hu> <1255940951.14447.9.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255940951.14447.9.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> > So d508afb fixed all that needed fixing and there's nothing serious 
> > pending here. I've reverted all pending bits in tip:out-of-tree, so 
> > it's pure -git now. I rarely have to carry any NFS fixes in 
> > out-of-tree, this was an odd-one-out exception that fell through the 
> > cracks.
> > 
> > 	Ingo
> 
> OK. Could you resend the remaining leak fix, with the fixed up 
> changelog and attributions so I can pass it on to Linus?

Sure - find it below.

Thanks,

	Ingo

-------------------------------------------->
>From 42497c08be18c388f696a692ca5f8c3ba48cb183 Mon Sep 17 00:00:00 2001
From: Yinghai Lu <yinghai@kernel.org>
Date: Fri, 3 Apr 2009 09:06:15 +0200
Subject: [PATCH] nfs: Fix nfs_parse_mount_options() kfree() leak

Fix a (small) memory leak in one of the error paths of
the NFS mount options parsing code.

Reported-by: Yinghai Lu <yinghai@kernel.org>
Reported-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 fs/nfs/super.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index a2c18ac..90be551 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1253,6 +1253,7 @@ static int nfs_parse_mount_options(char *raw,
 			default:
 				dfprintk(MOUNT, "NFS:   unrecognized "
 						"transport protocol\n");
+				kfree(string);
 				return 0;
 			}
 			break;
