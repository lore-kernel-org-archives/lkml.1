Return-Path: <linux-kernel-owner+w=401wt.eu-S933062AbXGXKKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933062AbXGXKKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 06:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761947AbXGXKKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 06:10:14 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:40207 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761242AbXGXKKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 06:10:12 -0400
Date: Tue, 24 Jul 2007 14:10:36 +0400
From: Dmitry Monakhov <dmonakhov@sw.ru>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: linux-kernel@vger.kernel.org,
       device-mapper development <dm-devel@redhat.com>
Subject: Re: [PATCH 8/8] dm: dm-target.c Convert  kmalloc + memset  to
	kzalloc
Message-ID: <20070724101036.GI16507@dnb.sw.ru>
Mail-Followup-To: "Robert P. J. Day" <rpjday@mindspring.com>,
	linux-kernel@vger.kernel.org,
	device-mapper development <dm-devel@redhat.com>
References: <33136714.1185268299275.JavaMail.root@mswamui-valley.atl.sa.earthlink.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <33136714.1185268299275.JavaMail.root@mswamui-valley.atl.sa.earthlink.net>
Organization: SWsoft.
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05:11 Втр 24 Июл     , Robert P. J. Day wrote:
> 
> 
> -----Original Message-----
> >From: Dmitry Monakhov <dmonakhov@openvz.org>
> >Sent: Jul 24, 2007 4:59 AM
> >To: linux-kernel@vger.kernel.org
> >Cc: device-mapper development <dm-devel@redhat.com>
> >Subject: [PATCH 8/8] dm: dm-target.c Convert  kmalloc + memset  to kzalloc
> >
> >Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> >---
> > drivers/md/dm-target.c |    6 ++----
> > 1 files changed, 2 insertions(+), 4 deletions(-)
> >
> >diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
> >index 477a041..835cf95 100644
> >--- a/drivers/md/dm-target.c
> >+++ b/drivers/md/dm-target.c
> >@@ -88,12 +88,10 @@ void dm_put_target_type(struct target_type *t)
> > 
> > static struct tt_internal *alloc_target(struct target_type *t)
> > {
> >-	struct tt_internal *ti = kmalloc(sizeof(*ti), GFP_KERNEL);
> >+	struct tt_internal *ti = kzalloc(sizeof(*ti), GFP_KERNEL);
> > 
> >-	if (ti) {
> >-		memset(ti, 0, sizeof(*ti));
> >+	if (ti)
> > 		ti->tt = *t;
> >-	}
> > 
> > 	return ti;
> > }
> >-- 
> >1.5.2.2
> >
> >
> 
> would it not have made more sense to have submitted all those related,
> single-change patches as one patch?
Yes i think so (i've already wrote bout this in fist msg), but
dm maintainers may have different oppinion.
BTW: It is allways easier fold many patches to one, than split one 
patch to many.
> 
> rday
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

