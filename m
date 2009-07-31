Return-Path: <linux-kernel-owner+w=401wt.eu-S1751959AbZGaGaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbZGaGaK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 02:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751587AbZGaGaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 02:30:10 -0400
Received: from smtp-104-thursday.nerim.net ([62.4.16.104]:54111 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751483AbZGaGaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 02:30:09 -0400
Date: Fri, 31 Jul 2009 08:30:08 +0200
From: Damien Wyart <damien.wyart@free.fr>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, fweisbec@gmail.com, Alan.Brunelle@hp.com
Subject: Re: [PATCH 0/9] Per-bdi writeback flusher threads v13
Message-ID: <20090731063008.GA2796@brouette>
References: <1248989044-21605-1-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248989044-21605-1-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> Here's the 13th version of the writeback patches. Changes since v12:

> - Update to 2.6.31-rc4 ('ish, it's on top of current -git, but wil apply
>   to -rc4 as well).
> - Drop the last patch in the series, it was a questionable optimization
>   that needs to be tested and evaluated separately.

fs/sync.c has changed some time ago and I think your patch needs this
(which I had lazyly added by hand in v12 without telling):

--- a/fs/sync.c	2009-07-31 07:32:08.927926281 +0200
+++ b/fs/sync.c.new	2009-07-31 07:31:52.499801359 +0200
@@ -118,7 +118,7 @@ restart:
  */
 SYSCALL_DEFINE0(sync)
 {
-	wakeup_pdflush(0);
+	wakeup_flusher_threads(0);
 	sync_filesystems(0);
 	sync_filesystems(1);
 	if (unlikely(laptop_mode))



Best,

-- 
Damien Wyart
