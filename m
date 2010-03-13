Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936506Ab0CMBb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:31:28 -0500
Received: from kroah.org ([198.145.64.141]:60641 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934867Ab0CMATw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:19:52 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:07 2010
Message-Id: <20100313001507.625630841@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ang Way Chuang <wcang79@gmail.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [patch 028/123] dvb-core: Fix DoS bug in ULE decapsulation code that can be triggered by an invalid Payload Pointer
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Ang Way Chuang <wcang79@gmail.com>

commit 29e1fa3565a7951cc415c634eb2b78dbdbee151d upstream.

ULE (Unidirectional Lightweight Encapsulation RFC 4326) decapsulation
has a bug that causes endless loop when Payload Pointer of MPEG2-TS
frame is 182 or 183.  Anyone who sends malicious MPEG2-TS frame will
cause the receiver of ULE SNDU to go into endless loop.

This patch was generated and tested against linux-2.6.32.9 and should
apply cleanly to linux-2.6.33 as well because there was only one typo
fix to dvb_net.c since v2.6.32.

This bug was brought to you by modern day Santa Claus who decided to
shower the satellite dish at Keio University with heavy snow causing
huge burst of errors.  We, receiver end, received Santa Claus's gift in
the form of kernel bug.

Care has been taken not to introduce more bug by fixing this bug, but
please scrutinize the code for I always produces buggy code.

Signed-off-by: Ang Way Chuang <wcang79@gmail.com>
Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/dvb/dvb-core/dvb_net.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/dvb/dvb-core/dvb_net.c
+++ b/drivers/media/dvb/dvb-core/dvb_net.c
@@ -504,6 +504,7 @@ static void dvb_net_ule( struct net_devi
 				       "bytes left in TS.  Resyncing.\n", ts_remain);
 				priv->ule_sndu_len = 0;
 				priv->need_pusi = 1;
+				ts += TS_SZ;
 				continue;
 			}
 


