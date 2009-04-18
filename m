Return-Path: <linux-kernel-owner+w=401wt.eu-S1754491AbZDRCcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbZDRCcv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 22:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbZDRCcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 22:32:36 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:59076 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbZDRCce convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 22:32:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=NWcaitrrMM8deN75W6fc6UpuCB4va+z63IKO9Wutn3ymE4n830ACIXf3kk/C78QD49
         mNHlwTcQAYgWCGqRahD/X7leKV30GUH1Jfc2BwBP+Q1IH/hheWifmtMpFNSiUOruloPI
         rX0vRYXXJgY+OkQrNy7nobuyo0rNf5jj8tj/w=
Date: Sat, 18 Apr 2009 10:32:26 +0800
From: leiming <tom.leiming@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       video4linux-list@redhat.com, laurent.pinchart@skynet.be,
       mchehab@infradead.org
Subject: Re: 2.6.30-rc2-git2: Reported regressions from 2.6.29
Message-ID: <20090418103226.54250420@linux-lm>
In-Reply-To: <200904172336.12414.rjw@sisk.pl>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
	<d82e647a0904161837w6b6fb652la0da05f9061e95dc@mail.gmail.com>
	<200904172336.12414.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.4; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ÓÚ Fri, 17 Apr 2009 23:36:11 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> Ð´µÀ:

> On Friday 17 April 2009, Ming Lei wrote:
> > 2009/4/17 Rafael J. Wysocki <rjw@sisk.pl>:
> > >
> > > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13125
> > > Subject         : active uvcvideo breaks over suspend
> > > Submitter       : Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> > > Date            : 2009-04-15 10:12 (2 days old)
> > > References      :
> > > http://marc.info/?l=linux-kernel&m=123979009508840&w=4
> > >
> > 
> > It is a bug in resume path of uvcvideo driver, and I have sent a
> > patch to laurent.pinchart@skynet.be,
> > mchehab@infradead.org  and video4linux-list@redhat.com to fix it,
> > but still no echo from them.
> > 
> > The patch title is V4L/DVB:usbvideo:fix uvc resume failed.
> > 
> > Rafael J.
> >         If you would like to apply it ,I can resend to you.  Thanks!
> 
> Please resend.
> 
> Rafael

>From 5715e310a939f3f7cd3e88eae8f25fedbb28def4 Mon Sep 17 00:00:00 2001
From: Ming Lei <tom.leiming@gmail.com>
Date: Wed, 15 Apr 2009 22:32:51 +0800
Subject: [PATCH] V4L/DVB:usbvideo:fix uvc resume failed

Now urb buffers is not freed before suspend, so uvc_alloc_urb_buffers
should return packet counts allocated originally during uvc resume
, instead of zero.

This patch is against v2.6.30-rc2.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/media/video/uvc/uvc_video.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
index a95e173..c050b22 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -742,7 +742,7 @@ static int uvc_alloc_urb_buffers(struct uvc_video_device *video,
 
 	/* Buffers are already allocated, bail out. */
 	if (video->urb_size)
-		return 0;
+		return DIV_ROUND_UP(video->urb_size, psize);
 
 	/* Compute the number of packets. Bulk endpoints might transfer UVC
 	 * payloads accross multiple URBs.
-- 
1.6.0.GIT



-- 
Lei Ming
