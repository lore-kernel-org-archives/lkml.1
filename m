Return-Path: <linux-kernel-owner+w=401wt.eu-S1758784AbXIBRs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758784AbXIBRs0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 13:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754712AbXIBRsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 13:48:19 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:20936 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbXIBRsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 13:48:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=isyEwD/7vlHWtk4c2GDSIu1noallG/G2R4uHH6akJYFb2uuOGH+6w2sypsoqO/0X+aXqltkCwcWj6eY4AF6SIYV2IW5YaNu09IxaPlXHvuo6UTO5aW7dyr3PzGuMoMdKq7b6xfk/XwnDe/VIWMI+wl8aZ2FRRwfG9vclvIBwdvg=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Steve French <sfrench@samba.org>
Subject: [PATCH][Trivial] CIFS: Use ssleep() instead of msleep() when sleeping multiple seconds
Date: Sun, 2 Sep 2007 19:44:49 +0200
User-Agent: KMail/1.9.7
Cc: linux-cifs-client@lists.samba.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709021944.49862.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A little trivial thing...

When sleeping for multiple seconds the function to use is
ssleep() not msleep() - especially when there's a comment 
above reading "... wait at least 45 seconds ...", then 
ssleep() best describes what is wanted.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 fs/cifs/connect.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 4af3588..0a9b76a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -733,7 +733,7 @@ multi_t2_fnd:
 		on a request getting a response and going ahead
 		and killing cifsd */
 		cFYI(1, ("Wait for exit from demultiplex thread"));
-		msleep(46000);
+		ssleep(46);
 		/* if threads still have not exited they are probably never
 		coming home not much else we can do but free the memory */
 	}

