Return-Path: <linux-kernel-owner+w=401wt.eu-S935286AbXGXJWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935286AbXGXJWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 05:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756769AbXGXJWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 05:22:06 -0400
Received: from elasmtp-dupuy.atl.sa.earthlink.net ([209.86.89.62]:38048 "EHLO
	elasmtp-dupuy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761478AbXGXJWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 05:22:05 -0400
X-Greylist: delayed 625 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Jul 2007 05:22:05 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=mrNuKDasJPklQHTyd2T15WWrc8q537SbvVg9xrk9IkMJ1viLVZlXf/uoj4guKvRq;
  h=Message-ID:Date:From:Reply-To:To:Subject:Cc:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Mailer:X-ELNK-Trace:X-Originating-IP;
Message-ID: <33136714.1185268299275.JavaMail.root@mswamui-valley.atl.sa.earthlink.net>
Date: Tue, 24 Jul 2007 05:11:39 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
Reply-To: "Robert P. J. Day" <rpjday@mindspring.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] dm: dm-target.c Convert  kmalloc + memset  to
 kzalloc
Cc: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: EarthLink Zoo Mail 1.0
X-ELNK-Trace: c4ef088d726be7c75e89bb4777695beb69025943178dce0b177e2d5000288745c32c27803a207808350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 209.86.224.52
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
>From: Dmitry Monakhov <dmonakhov@openvz.org>
>Sent: Jul 24, 2007 4:59 AM
>To: linux-kernel@vger.kernel.org
>Cc: device-mapper development <dm-devel@redhat.com>
>Subject: [PATCH 8/8] dm: dm-target.c Convert  kmalloc + memset  to kzalloc
>
>Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>---
> drivers/md/dm-target.c |    6 ++----
> 1 files changed, 2 insertions(+), 4 deletions(-)
>
>diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
>index 477a041..835cf95 100644
>--- a/drivers/md/dm-target.c
>+++ b/drivers/md/dm-target.c
>@@ -88,12 +88,10 @@ void dm_put_target_type(struct target_type *t)
> 
> static struct tt_internal *alloc_target(struct target_type *t)
> {
>-	struct tt_internal *ti = kmalloc(sizeof(*ti), GFP_KERNEL);
>+	struct tt_internal *ti = kzalloc(sizeof(*ti), GFP_KERNEL);
> 
>-	if (ti) {
>-		memset(ti, 0, sizeof(*ti));
>+	if (ti)
> 		ti->tt = *t;
>-	}
> 
> 	return ti;
> }
>-- 
>1.5.2.2
>
>

would it not have made more sense to have submitted all those related,
single-change patches as one patch?

rday



