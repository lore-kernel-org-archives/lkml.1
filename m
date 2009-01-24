Return-Path: <linux-kernel-owner+w=401wt.eu-S1757847AbZAXPqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757847AbZAXPqk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 10:46:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbZAXPq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 10:46:28 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:36174 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbZAXPq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 10:46:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=t0mwkHh9HPgK6ZNC/xl5LaVulS9wv7FYIvyYdF/Y+8q+txS+18KBdmFiWpOL21V8+4
         aya9SGflP/Ydf6ys0rBZWU6O9Z9WJWsoDb8scfZ+aUdaR6uLprBw9UrIkG0mYF6FkyRJ
         FBJcUHglMTQyGa3iCcEOer+pX+OGYaqK7kGH4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: Re: [PATCH] icside: fix PCB version 6 support
Date: Sat, 24 Jan 2009 16:46:21 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-next-20090123; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
References: <200901241513.29772.bzolnier@gmail.com>
In-Reply-To: <200901241513.29772.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200901241646.22077.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 January 2009, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] icside: fix PCB version 6 support
> 
> We need to pass struct ide_port_info also to ide_host_register().
> 
> Cc: Russell King <rmk@arm.linux.org.uk>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] icside: fix PCB version 6 support (v2)

We need to pass struct ide_port_info also to ide_host_register().

v2:
Fix v5/v6 mismatch noticed by Russell.

Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/icside.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/icside.c
===================================================================
--- a/drivers/ide/icside.c
+++ b/drivers/ide/icside.c
@@ -534,7 +534,7 @@ icside_register_v6(struct icside_state *
 		d.dma_ops = NULL;
 	}
 
-	ret = ide_host_register(host, NULL, hws);
+	ret = ide_host_register(host, &d, hws);
 	if (ret)
 		goto err_free;
 
