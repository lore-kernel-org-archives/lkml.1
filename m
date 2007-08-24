Return-Path: <linux-kernel-owner+w=401wt.eu-S964868AbXHXAOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964868AbXHXAOP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 20:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932105AbXHXAN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 20:13:58 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:34562 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932482AbXHXAN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 20:13:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:resent-from:resent-to:resent-date:resent-message-id:message-id:in-reply-to:references:from:date:subject:to:cc:mime-version:content-transfer-encoding:content-disposition;
        b=GtJ64ul4SCI7IS4z+ZlRVfYsxSy0GpTP7NbogSxRRZ/kpx35VY46FpQsLX3n4AVV+YeeLnfDmYVJQz1DXIlfcyTd/qKrmA3lLV747bPM4QQCKwQ8QQ9V5h/GYP5iKiMhWH+v2HuIVXHaa8otESNKiRuzbTAoUK/w3WAhXP6TV/U=
Message-Id: <faf86e8b389bbc43ea531a1eadcda5ce4694ac0a.1187912217.git.jesper.juhl@gmail.com>
In-Reply-To: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
From: Jesper Juhl <jesper.juhl@gmail.com>
Date: Fri, 24 Aug 2007 02:11:03 +0200
Subject: [PATCH 18/30] isdn: eicon - get rid of a pointless vmalloc() return value cast
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Karsten Keil <kkeil@suse.de>, Kai Germaschewski <kai.germaschewski@gmx.de>,
       isdn4linux@listserv.isdn4linux.de, Armin Schindler <mac@melware.de>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

vmalloc() returns void*.
No need to cast in drivers/isdn/hardware/eicon/platform.h::diva_os_malloc()

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
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

