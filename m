Return-Path: <linux-kernel-owner+w=401wt.eu-S934248AbXHXAdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934248AbXHXAdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 20:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764830AbXHXAdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 20:33:38 -0400
Received: from hu-out-0506.google.com ([72.14.214.224]:64911 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764697AbXHXAdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 20:33:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:resent-from:resent-to:resent-date:resent-message-id:message-id:in-reply-to:references:from:date:subject:to:cc:mime-version:content-transfer-encoding:content-disposition;
        b=jpQ00FaaIdud5ID+xcYwSCtw6cer0ljqVmWjUXsPBQkl+SfUskUHrwDjGX5/URCY/bjDLuybP+XgKm/wKRA/349nfJMG9nDC9BAKiXIgPG4ywnib/F3ke9A73MiNg0d3GCC3ODK6Q3KfJApszu54qjV2a5vqGs0sCiA9AL3OPpQ=
Message-Id: <d10569804357e6b76a0906a0864b2dfd128d2b3d.1187912217.git.jesper.juhl@gmail.com>
In-Reply-To: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
From: Jesper Juhl <jesper.juhl@gmail.com>
Date: Fri, 24 Aug 2007 02:30:43 +0200
Subject: [PATCH 26/30] md: vmalloc() returns void pointer so we don't need to cast it in dm-ioctl
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In drivers/md/dm-ioctl.c::copy_params() there's a call to vmalloc()
where we currently cast the return value, but that's pretty pointles
given that vmalloc() returns "void *".

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---
 drivers/md/dm-ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index b441d82..efbf9b6 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1358,7 +1358,7 @@ static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl **param)
 	if (tmp.data_size < sizeof(tmp))
 		return -EINVAL;
 
-	dmi = (struct dm_ioctl *) vmalloc(tmp.data_size);
+	dmi = vmalloc(tmp.data_size);
 	if (!dmi)
 		return -ENOMEM;
 
-- 
1.5.2.2

