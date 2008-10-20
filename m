Return-Path: <linux-kernel-owner+w=401wt.eu-S1753584AbYJTUvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbYJTUvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 16:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754851AbYJTUuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 16:50:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605AbYJTUuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 16:50:50 -0400
Date: Mon, 20 Oct 2008 16:49:54 -0400
From: Jason Baron <jbaron@redhat.com>
To: Alejandro Riveira =?iso-8859-1?Q?Fern=E1ndez?= 
	<alejandro.riveira@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, ericvh@gmail.com,
       v9fs-developer@lists.sourceforge.net, lucho@ionkov.net
Subject: Re: [net/9p/9pnet.c] Compile error
Message-ID: <20081020204954.GC3161@redhat.com>
References: <1224530845.22829.4.camel@varda>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1224530845.22829.4.camel@varda>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 09:27:25PM +0200, Alejandro Riveira Fernández wrote:
> Current Git
>  v2.6.27-6030-g6da0b38
> 
>  I get a build error
> 
> Kernel: arch/x86/boot/bzImage is ready  (#17)
>   Building modules, stage 2.
>   MODPOST 571 modules
> ERROR: "p9_debug_level" [net/9p/9pnet.ko] undefined!
> make[3]: *** [__modpost] Error 1
> make[2]: *** [modules] Error 2
> make[1]: *** [sub-make] Error 2
> make: *** [all] Error 2
> 

hi,

Yes, i hit that too...the patch below resolved it for me.

thanks,

-Jason


Signed-off-by: Jason Baron <jbaron@redhat.com>

diff --git a/net/9p/protocol.c b/net/9p/protocol.c
index 29be524..ebf819e 100644
--- a/net/9p/protocol.c
+++ b/net/9p/protocol.c
@@ -542,8 +542,10 @@ int p9pdu_finalize(struct p9_fcall *pdu)
 	err = p9pdu_writef(pdu, 0, "d", size);
 	pdu->size = size;
 
+#ifdef CONFIG_NET_9P_DEBUG
 	if ((p9_debug_level & P9_DEBUG_PKT) == P9_DEBUG_PKT)
 		p9pdu_dump(0, pdu);
+#endif
 
 	P9_DPRINTK(P9_DEBUG_9P, ">>> size=%d type: %d tag: %d\n", pdu->size,
 							pdu->id, pdu->tag);
