Return-Path: <linux-kernel-owner+w=401wt.eu-S1752736AbYLPFOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbYLPFOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 00:14:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750853AbYLPFOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 00:14:35 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48275 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbYLPFOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 00:14:34 -0500
Date: Tue, 16 Dec 2008 14:13:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, jens.axboe@oracle.com, kniknath@suse.de
Subject: Re: mmotm 2008-12-15-16-45 uploaded
Message-Id: <20081216141334.0eb6f0e4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200812160046.mBG0k0YV024823@imap1.linux-foundation.org>
References: <200812160046.mBG0k0YV024823@imap1.linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Dec 2008 16:45:59 -0800
akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2008-12-15-16-45 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> It contains the following patches against 2.6.28-rc8:
> 
This patch was necessary...maybe fixed by linux-next.

==
Don't call __cfq_exit_single_io_context() twice.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
Index: mmotm-2.6.28-Dec15/block/cfq-iosched.c
===================================================================
--- mmotm-2.6.28-Dec15.orig/block/cfq-iosched.c
+++ mmotm-2.6.28-Dec15/block/cfq-iosched.c
@@ -1322,7 +1322,6 @@ static void cfq_exit_single_io_context(s
 		smp_read_barrier_depends();
 		if (cic->key)
 			__cfq_exit_single_io_context(cfqd, cic);
-		__cfq_exit_single_io_context(cfqd, cic);
 
 		spin_unlock_irqrestore(q->queue_lock, flags);
 	}

