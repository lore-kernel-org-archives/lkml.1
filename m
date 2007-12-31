Return-Path: <linux-kernel-owner+w=401wt.eu-S1752818AbXLaXvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbXLaXvo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 18:51:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbXLaXvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 18:51:36 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:37761 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbXLaXvf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 18:51:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=YcPb3sjTo6LmbGhj0VlFUQVkdxMuwUv6ScHPi/EdTW1ngDtD8tMDyO95VucVxMbInaGr4KhYov2615NH5K721XD54szGBN4awyEuHe9sOOEFErIjxaxRhN1o8wt2c2Hfq2vHQH0o5Kmo2juBpmYdCGUOenYLD8QoVZFOGrXO5OA=
To: linux-kernel@vger.kernel.org
Subject: [PATCH] alsa: fix compilation warning in GCC
Date: Tue, 1 Jan 2008 00:51:30 +0100
User-Agent: KMail/1.9.7
Cc: perex@perex.cz
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801010051.30963.mboton@gmail.com>
From: Miguel =?utf-8?q?Bot=C3=B3n?= <mboton.lkml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just a little patch to shut up GCC.

'snd_shutdown_f_ops' is not a pointer so its address will never be NULL.
GCC will complain because 'fops_get' will do an unnecessary check because
'&snd_shutdown_f_ops' is always true.

Signed-off-by: Miguel Botón <mboton@gmail.com>

diff --git a/sound/core/init.c b/sound/core/init.c
index 48d38a7..2215ba8 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -340,8 +340,8 @@ int snd_card_disconnect(struct snd_card *card)
 		list_add(&mfile->shutdown_list, &shutdown_files);
 		spin_unlock(&shutdown_lock);
 
-		fops_get(&snd_shutdown_f_ops);
 		mfile->file->f_op = &snd_shutdown_f_ops;
+		fops_get(mfile->file->f_op);
 		
 		mfile = mfile->next;
 	}

-- 
	Miguel Botón
