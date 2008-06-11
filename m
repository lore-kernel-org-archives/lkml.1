Return-Path: <linux-kernel-owner+w=401wt.eu-S1754108AbYFKFZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbYFKFZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 01:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbYFKFY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 01:24:58 -0400
Received: from mail2.briontech.com ([66.166.78.5]:40441 "EHLO
	mail2.briontech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbYFKFY5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 01:24:57 -0400
From: Luoqi Chen <Luoqi.Chen@brion.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>
Date: Tue, 10 Jun 2008 22:24:49 -0700
Subject: RE: NFS open/setuid/ftruncate problem
Thread-Topic: NFS open/setuid/ftruncate problem
Thread-Index: AcjLVFoK2wr78XGJQWuURu3BR4f9HQALTUPQ
Message-ID: <0707E37B6D2E244C85660487B602C9221D9D9883@ex02.briontech.com>
References: <0707E37B6D2E244C85660487B602C9221D9D9846@ex02.briontech.com>
 <1213141630.20459.113.camel@localhost>
In-Reply-To: <1213141630.20459.113.camel@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 11 Jun 2008 05:24:51.0548 (UTC) FILETIME=[794071C0:01C8CB83]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Trond Myklebust <Trond.Myklebust@netapp.com>
> Date: Tue, 10 Jun 2008 19:39:41 -0400
> NFS: Fix the ftruncate() credential problem
>
> ftruncate() access checking is supposed to be performed at
> open() time,
> just like reads and writes.
>
Thanks, Trond. Is there any chance this patch could be
included in the linux kernel in the near future? For now,
I guess I'll workaround this problem by moving the ftruncate()
to before setuid().

-luoqi

PS: I haven't tried the patch, just browsing through, and I noticed
a typo, pointing out here to save some trouble for anyone who
wants to give it a try (I guess gcc would issue a warning too),

        /* Search for an existing open(O_WRITE) file */
-       ctx = nfs_find_open_context(inode, cred, FMODE_WRITE);
-       if (ctx != NULL)
-               state = ctx->state;
+       if (sattr->ia_valid && ATTR_FILE) {  <=== && should be &
+               ctx = nfs_file_open_context(sattr->ia_file);
+               if (ctx != NULL)
+                       state = ctx->state;
+       }
