Return-Path: <linux-kernel-owner+w=401wt.eu-S1765848AbXHDSg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765848AbXHDSg6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 14:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932964AbXHDSdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 14:33:51 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:45415 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932957AbXHDSdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 14:33:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:content-disposition:from:to:subject:user-agent:cc:mime-version:date:content-type:content-transfer-encoding:message-id;
        b=S9CXSDKK0WIo6UpU5SBD1vfLCNh1uo46q6+18gzo4mpGvurRlhfkNcc6wZyLtR4LBC/dUJ/v8VTcTYuEMjfYzPFRVAjYvOFEJ3QK1g6rrV2+wMRbhui22goj9ujtN4FQX6ot7ZjRJg9lPPS4Qaf6kTNqte0atbVodsNYWuDH7QI=
Content-Disposition: inline
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH][RESEND][ISDN] Guard against a potential NULL pointer dereference in old_capi_manufacturer()
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       isdn4linux@listserv.isdn4linux.de, Carsten Paeth <calle@calle.de>,
       Kai Germaschewski <kai@germaschewski.name>,
       Karsten Keil <kkeil@suse.de>,
       Kai Germaschewski <kai.germaschewski@gmx.de>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Date: Sat, 4 Aug 2007 20:31:54 +0200
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200708042031.54363.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(first send: Monday 25 June 2007, resending due to no response)
(resending again on August 8'th, 2007)


In drivers/isdn/capi/kcapi.c::old_capi_manufacturer(), if the call 
to get_capi_ctr_by_nr(ldef.contr); in line 823 returns NULL, then 
we'll be dereferencing a NULL pointer in the very next line.

(Found by Coverity checker as bug #402)


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/isdn/capi/kcapi.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/isdn/capi/kcapi.c b/drivers/isdn/capi/kcapi.c
index 3ed34f7..3f9e962 100644
--- a/drivers/isdn/capi/kcapi.c
+++ b/drivers/isdn/capi/kcapi.c
@@ -821,6 +821,8 @@ static int old_capi_manufacturer(unsigned int cmd, void 
__user *data)
 				return -EFAULT;
 		}
 		card = get_capi_ctr_by_nr(ldef.contr);
+		if (!card)
+			return -EINVAL;
 		card = capi_ctr_get(card);
 		if (!card)
 			return -ESRCH;

