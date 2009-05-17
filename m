Return-Path: <linux-kernel-owner+w=401wt.eu-S1753105AbZEQQ6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbZEQQ6y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 12:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbZEQQ6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 12:58:30 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:44978 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbZEQQ62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 12:58:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=pSAcW6YPexax7G6GvWKnpUQN/C3JwwHHVQoPyBBKeta55WvKRqDxTtrDqsdiXJhjQ9
         9FiNmCaawlaiad8Sr1US3YjOKyQRwawqHy2PpkmYuWTvxTUIt/8nd/TypeYbmdlXUV/8
         1ZP3RAIyjS0cobV7OtKcRBcUA1jibsmtvUA4Y=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 3/7] ide: merge ide_disk_special() into do_special()
Date: Sun, 17 May 2009 19:00:45 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-00442-ga3668b0; KDE/4.2.2; i686; ; )
Cc: Joe Perches <joe@perches.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20090513205139.28638.87226.sendpatchset@localhost.localdomain> <1242248102.4639.17.camel@Joe-AcerAspire> <4A0C0D44.9020308@ru.mvista.com>
In-Reply-To: <4A0C0D44.9020308@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905171900.45661.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 May 2009 14:23:32 Sergei Shtylyov wrote:
> Hello.
> 
> Joe Perches wrote:
> 
> >>While at it:
> >>- change debug printk() level to KERN_DEBUG
> >>- update documentation
> 
> >>There should be no functional changes caused by this patch.
> 
> >>Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> >>---
> >> drivers/ide/ide-io.c |   44 ++++++++++++++++++--------------------------
> >> 1 file changed, 18 insertions(+), 26 deletions(-)
> 
> >>Index: b/drivers/ide/ide-io.c
> >>===================================================================
> >>--- a/drivers/ide/ide-io.c
> >>+++ b/drivers/ide/ide-io.c
> >>@@ -184,11 +184,28 @@ static void ide_tf_set_setmult_cmd(ide_d
> 
> > []
> 
> >>+#ifdef DEBUG
> >>+	printk(KERN_DEBUG "%s: %s: 0x%02x\n", drive->name, s->all);
> >>+#endif
> 
> > pr_debug?
> 
>     Yes, and the number of arguments doesn't correspond to the number of the 
> format specifiers.

Ugh :)  Fixed in the revised version (interdiff below)...

When it comes to pr_debug() & co. I will warmly welcome patches converting
drivers/ide/*.[ch] to use them.

...
v2:
- fix DEBUG build (noticed by Sergei)
...

diff -u b/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
--- b/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -198,7 +198,7 @@
 	struct ide_cmd cmd;
 
 #ifdef DEBUG
-	printk(KERN_DEBUG "%s: %s: 0x%02x\n", drive->name, s->all);
+	printk(KERN_DEBUG "%s: %s: 0x%02x\n", drive->name, __func__, s->all);
 #endif
 	if (drive->media != ide_disk) {
 		s->all = 0;
