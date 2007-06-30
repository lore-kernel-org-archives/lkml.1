Return-Path: <linux-kernel-owner+w=401wt.eu-S1753995AbXF3XST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbXF3XST (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 19:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbXF3XR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 19:17:58 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:60769 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828AbXF3XRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 19:17:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:content-disposition:from:to:subject:date:user-agent:cc:mime-version:message-id:content-type:content-transfer-encoding;
        b=iHPgLHlfuGxQbRjwEBOog1qmi1atelndyrCKnBC7Hn4eOTAOA6FWb+hTA83z9fEy7MvJ9ASKoXBvl5gzThaKmoH3DA+J1Rpfrv7vViKTlZ8NxUnBTlqMNF6qINKlj+jXlOpuV01nynMik6DyQsvC8uCuU+bF7/qXkMF1K9yLxbg=
Content-Disposition: inline
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][ISDN][resend] Guard against a potential NULL pointer dereference in old_capi_manufacturer()
Date: Sun, 1 Jul 2007 00:59:01 +0200
User-Agent: KMail/1.9.7
Cc: isdn4linux@listserv.isdn4linux.de, Carsten Paeth <calle@calle.de>,
       Kai Germaschewski <kai@germaschewski.name>,
       Karsten Keil <kkeil@suse.de>,
       Kai Germaschewski <kai.germaschewski@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Message-Id: <200707010059.01826.jesper.juhl@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(first send: Monday 25 June 2007, resending due to no response)


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

