Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab0CFLFU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 06:05:20 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:53158 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab0CFLFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 06:05:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=vif3EHxYeZzmQHZuC3koDGd612kB59HLSJOoNCfXc6cUdb3ZJ5gbdkPe/Xa+aJerHu
         CxpZC/yVZgHZS3e9gk8RMSObQFiZbL5l75T1r/At3QjpfxrsqJ4Kl9aIlfAR4RU61C7h
         BBWuLe/3uKJptjN8S57rode+2qF74Xx2Oh6UM=
Date: Sat, 6 Mar 2010 14:04:45 +0300
From: Dan Carpenter <error27@gmail.com>
To: netdev@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Jan Engelhardt <jengelh@medozas.de>,
       Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] sock.c: potential null dereference
Message-ID: <20100306110445.GC4958@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>, netdev@vger.kernel.org,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Jan Engelhardt <jengelh@medozas.de>, Ingo Molnar <mingo@elte.hu>,
	"David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We test that "prot->rsk_prot" is non-null right before we dereference it
on this line.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/net/core/sock.c b/net/core/sock.c
index fcd397a..fa427b5 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2276,7 +2276,8 @@ out_free_request_sock_slab:
 		prot->rsk_prot->slab = NULL;
 	}
 out_free_request_sock_slab_name:
-	kfree(prot->rsk_prot->slab_name);
+	if (prot->rsk_prot)
+		kfree(prot->rsk_prot->slab_name);
 out_free_sock_slab:
 	kmem_cache_destroy(prot->slab);
 	prot->slab = NULL;
