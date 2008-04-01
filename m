Return-Path: <linux-kernel-owner+w=401wt.eu-S1759302AbYDARuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759302AbYDARuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 13:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756863AbYDARtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 13:49:52 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:58650 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756851AbYDARtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 13:49:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=cSYr3pD5sD//+I1NHMkdBevLcqUVm5L4ZXf93tRdvFNK9Fpbr/gjkT5qTRvrjctgqAvY8xgjQSnb9hFVzLqbJnc3FHCPGkBd85nYLUOszrug7pGgtMvUJ50TfouW+ejnTASFBsdSaVOhrtaOP6YI9vHN8RIjnhDz0at3HkUGcp8=
Date: Tue, 1 Apr 2008 21:49:13 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, video4linux-list@redhat.com
Subject: [PATCH] bttv: fix missed index check
Message-ID: <20080401174913.GD7654@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should check for proper index first

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

I'm not really familiar with V4L so please check the patch

Index: linux-2.6.git/drivers/media/video/bt8xx/bttv-driver.c
===================================================================
--- linux-2.6.git.orig/drivers/media/video/bt8xx/bttv-driver.c	2008-03-21 18:04:39.000000000 +0300
+++ linux-2.6.git/drivers/media/video/bt8xx/bttv-driver.c	2008-04-01 21:29:53.000000000 +0400
@@ -3508,8 +3508,12 @@ static int radio_enum_input(struct file 
 static int radio_g_audio(struct file *file, void *priv,
 					struct v4l2_audio *a)
 {
+	if (a->index != 0)
+		return -EINVAL;
+
 	memset(a, 0, sizeof(*a));
 	strcpy(a->name, "Radio");
+
 	return 0;
 }
 
