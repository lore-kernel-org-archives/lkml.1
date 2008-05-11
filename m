Return-Path: <linux-kernel-owner+w=401wt.eu-S1759431AbYEKUFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759431AbYEKUFX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 16:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756147AbYEKUFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 16:05:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:52355 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757323AbYEKUFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 16:05:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=VeJ+qLF5DgMbeBI6OZ9/Ti2ZddzPLTYT7szavzv+8D2RE8J0/cOGVYMSSLwRNoLcjNOiLv84sQlC7GpH29o07Tbj+TxpWzyC3IQEozFmFmvpsKQjfpoi98DovjQDHHfEyGb7o4WCEu9Aj7J/htRnHgUO25vgkhRy1z92h7mW/RY=
Date: Sun, 11 May 2008 22:04:25 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ramkrishna Vepa <ram.vepa@neterion.com>,
       Rastapur Santosh <santosh.rastapur@neterion.com>,
       Sivakumar Subramani <sivakumar.subramani@neterion.com>,
       Sreenivasa Honnur <sreenivasa.honnur@neterion.com>,
       netdev@vger.kernel.org
Subject: [PATCH] net/s2io: set_rxd_buffer_pointer returns -ENOMEM, not
	ENOMEM
Message-ID: <20080511200421.GK19058@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Ramkrishna Vepa <ram.vepa@neterion.com>
Cc: Rastapur Santosh <santosh.rastapur@neterion.com>
Cc: Sivakumar Subramani <sivakumar.subramani@neterion.com>
Cc: Sreenivasa Honnur <sreenivasa.honnur@neterion.com>
Cc: netdev@vger.kernel.org
---
compile tested only
---
 drivers/net/s2io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/s2io.c b/drivers/net/s2io.c
--- a/drivers/net/s2io.c
+++ b/drivers/net/s2io.c
@@ -6951,7 +6951,7 @@ static  int rxd_owner_bit_reset(struct s2io_nic *sp)
 						       &skb,(u64 *)&temp0_64,
 						       (u64 *)&temp1_64,
 						       (u64 *)&temp2_64,
-							size) == ENOMEM) {
+							size) == -ENOMEM) {
 					return 0;
 				}
 
-- 
