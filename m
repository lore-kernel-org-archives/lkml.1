Return-Path: <linux-kernel-owner+w=401wt.eu-S1758774AbYESMtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758774AbYESMtY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 08:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754908AbYESMtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 08:49:14 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:60161 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605AbYESMtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 08:49:14 -0400
To: hjk@linutronix.de
Cc: corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [11/11] Convert uio to fasync_unlocked
From: Andi Kleen <andi@firstfloor.org>
References: <20080519231.561421028@firstfloor.org>
	<20080519123120.C7BBD1B41FF@basil.firstfloor.org>
Date: Mon, 19 May 2008 14:48:32 +0200
In-Reply-To: <20080519123120.C7BBD1B41FF@basil.firstfloor.org> (Andi Kleen's message of "Mon, 19 May 2008 14:31:20 +0200 (CEST)")
Message-ID: <87lk26bgtb.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 19 May 2008 12:41:30.0033 (UTC) FILETIME=[A943C210:01C8B9AD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> Just calls fasync_helper
>
> Cc: hjk@linutronix.de

Sorry that one was missing a quilt refresh. Here's the real patch.
Not very exciting.

-Andi

---

Convert uio to fasync_unlocked

Just calls fasync_helper

Cc: hjk@linutronix.de
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux/drivers/uio/uio.c
===================================================================
--- linux.orig/drivers/uio/uio.c
+++ linux/drivers/uio/uio.c
@@ -541,7 +541,7 @@ static const struct file_operations uio_
 	.read		= uio_read,
 	.mmap		= uio_mmap,
 	.poll		= uio_poll,
-	.fasync		= uio_fasync,
+	.unlocked_fasync = uio_fasync,
 };
 
 static int uio_major_init(void)
