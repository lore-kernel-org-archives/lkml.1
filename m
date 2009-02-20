Return-Path: <linux-kernel-owner+w=401wt.eu-S1755061AbZBTQal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061AbZBTQal (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 11:30:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752329AbZBTQab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 11:30:31 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:65213 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbZBTQaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 11:30:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=RvTdlasX8pV+IhY0WE+dJ6ZtCNkxYZpZaPR2fMQKG2n5DbAIGsK92h9BAitqFRXLhM
         E9vBQGUdm9C9AvVaJD3f8fR5Dg15KzD6E9OFZxKeBxXGv3MvvPDpF3oGU9IjBLbwtlYd
         AIcF41V1LXUV2fJyLqgdvo8YvzvNNSeFhZAT4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for February 20
Date: Fri, 20 Feb 2009 17:32:06 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-next-20090219; KDE/4.2.0; i686; ; )
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20090220201224.3f32ae24.sfr@canb.auug.org.au>
In-Reply-To: <20090220201224.3f32ae24.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902201732.06203.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 February 2009, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090219:

I've just noticed stall patch version in ide tree so if you're
using ide this patch is also necessary (fixes hang on boot):

--- linux-next/drivers/ide/ide-iops.c	2009-02-20 18:00:28.000000000 +0100
+++ linux-2.6.git/drivers/ide/ide-iops.c	2009-02-19 18:31:04.000000000 +0100
@@ -468,9 +468,9 @@
 	unsigned long flags;
 
 	spin_lock_irqsave(&hwif->lock, flags);
-	if ((drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT) &&
-	    (cmd->protocol == ATAPI_PROT_DMA ||
-	     cmd->protocol == ATAPI_PROT_PIO))
+	if ((cmd->protocol != ATAPI_PROT_DMA &&
+	     cmd->protocol != ATAPI_PROT_PIO) ||
+	    (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT))
 		__ide_set_handler(drive, handler, timeout);
 	hwif->tp_ops->exec_command(hwif, cmd->tf.command);
 	/*
