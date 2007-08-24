Return-Path: <linux-kernel-owner+w=401wt.eu-S1765306AbXHXHV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765306AbXHXHV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 03:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755219AbXHXHVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 03:21:33 -0400
Received: from mx.melware.net ([217.91.97.190]:4344 "EHLO mx.melware.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636AbXHXHVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 03:21:31 -0400
X-Greylist: delayed 2059 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Aug 2007 03:21:30 EDT
Date: Fri, 24 Aug 2007 08:47:08 +0200 (CEST)
From: Armin Schindler <armin@melware.de>
X-X-Sender: armin@phoenix.one.melware.de
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Karsten Keil <kkeil@suse.de>,
       Kai Germaschewski <kai.germaschewski@gmx.de>,
       isdn4linux@listserv.isdn4linux.de
Subject: Re: [PATCH 18/30] isdn: eicon - get rid of a pointless vmalloc()
 return value cast
In-Reply-To: <faf86e8b389bbc43ea531a1eadcda5ce4694ac0a.1187912217.git.jesper.juhl@gmail.com>
Message-ID: <Pine.LNX.4.61.0708240846200.10564@phoenix.one.melware.de>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
 <faf86e8b389bbc43ea531a1eadcda5ce4694ac0a.1187912217.git.jesper.juhl@gmail.com>
Organization: Cytronics & Melware
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

vmalloc() returns void*.
No need to cast in drivers/isdn/hardware/eicon/platform.h::diva_os_malloc()

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Acked-by: Armin Schindler <armin@melware.de>
---
 drivers/isdn/hardware/eicon/platform.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/hardware/eicon/platform.h b/drivers/isdn/hardware/eicon/platform.h
index 15d4942..8756ef1 100644
--- a/drivers/isdn/hardware/eicon/platform.h
+++ b/drivers/isdn/hardware/eicon/platform.h
@@ -167,7 +167,7 @@ static __inline__ void* diva_os_malloc (unsigned long flags, unsigned long size)
 	void *ret = NULL;
 
 	if (size) {
-		ret = (void *) vmalloc((unsigned int) size);
+		ret = vmalloc((unsigned int)size);
 	}
 	return (ret);
 }
-- 
1.5.2.2

