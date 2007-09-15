Return-Path: <linux-kernel-owner+w=401wt.eu-S1761248AbXIOKx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761248AbXIOKx4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 06:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760715AbXIOKxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 06:53:40 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:55671 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760550AbXIOKxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 06:53:38 -0400
Date: Sat, 15 Sep 2007 19:52:36 +0900
To: pj@sgi.com, jens.axboe@oracle.com
Cc: tomof@acm.org, apw@shadowen.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, mel@csn.ul.ie, linux-scsi@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: 2.6.23-rc4-mm1
From: FUJITA Tomonori <tomof@acm.org>
In-Reply-To: <20070914211635.4774c971.pj@sgi.com>
References: <20070910111926.9c942358.akpm@linux-foundation.org>
	<20070910042256Z.tomof@acm.org>
	<20070914211635.4774c971.pj@sgi.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070914104157D.tomof@acm.org>
X-Dispatcher: imput version 20050308(IM148)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Sep 2007 21:16:35 -0700
Paul Jackson <pj@sgi.com> wrote:

> FUJITA Tomonori wrote:
> > Can you try this patch (against 2.6.23-rc4-mm1)?
> > 
> > >From 592bd2049cb3e6e1f1dde7cf631879f26ddffeaa Mon Sep 17 00:00:00 2001
> > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Date: Mon, 10 Sep 2007 04:17:13 +0100
> > Subject: [PATCH] qla1280: sg chaining fixes
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > ---
> >  drivers/scsi/qla1280.c |    5 ++++-
> >  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> This patch works for me.
> 
> I was getting the scsi errors reported earlier in
> this thread, running 2.6.23-rc4-mm1 on one of our
> big SGI Altix systems.
> 
> Applying this patch fixed it, so far as I can tell,
> which is to say my system boots cleanly once again.

Thanks for testing!

Jens, we could enable use_sg_chaining option for qla1280.


From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] qla1280: enable use_sg_chaining option

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/qla1280.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 7c1eaec..83249af 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -4259,6 +4259,7 @@ static struct scsi_host_template qla1280_driver_template = {
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
+	.use_sg_chaining	= ENABLE_SG_CHAINING,
 };
 
 
-- 
1.5.2.4

