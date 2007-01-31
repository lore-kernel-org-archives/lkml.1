Return-Path: <linux-kernel-owner+w=401wt.eu-S1030449AbXAaRfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030449AbXAaRfL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 12:35:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030446AbXAaRfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 12:35:10 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49140 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030443AbXAaRfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 12:35:09 -0500
Date: Wed, 31 Jan 2007 17:47:24 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH] libata: Fix (hopefully) all the remaining problems with
 devices failing setup/identify
Message-ID: <20070131174724.7b17153a@localhost.localdomain>
In-Reply-To: <45C0D050.4030302@garzik.org>
References: <20070131172605.2c5dfc78@localhost.localdomain>
	<45C0D050.4030302@garzik.org>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Looks like you should use ata_busy_wait() here, rather than reproducing 
> the same code again.

It waits in 10uS chunks while 1uS chunks were used in the workaround.
Could indeed do that once I know the fix is right. While I'm at it the
ata_busy_wait kerneldoc is borked so here's a fix

Signed-off-by: Alan Cox <alan@redhat.com>

--- linux.vanilla-2.6.20-rc6-mm3/include/linux/libata.h	2007-01-31 14:20:43.000000000 +0000
+++ linux-2.6.20-rc6-mm3/include/linux/libata.h	2007-01-31 17:19:04.703229512 +0000
@@ -1052,6 +1053,8 @@
 /**
  *	ata_busy_wait - Wait for a port status register
  *	@ap: Port to wait for.
+ *	@bits: bits that must be clear
+ *	@max: number of 10uS waits to perform
  *
  *	Waits up to max*10 microseconds for the selected bits in the port's
  *	status register to be cleared.
