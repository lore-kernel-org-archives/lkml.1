Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828AbZE2Ddg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbZE2Ddg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 23:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbZE2Dd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 23:33:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:9806 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbZE2Dd1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 23:33:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=fCmBn9gl0oh8pexJJMa50HAPkOHV9Gd4ggnLElKNOgQBCn/gKYXAKYLt2W9+kV2wXa
         ytnfStAJCtiBqrxCTlbCNUMZ6KlTC3xJBwocXiCbx1BZbDMJy9VN+BROgT8nU1+7nr44
         /cQqTNw3p2onYxl59VPbMBLd2IroyTmSmwSIY=
Date: Fri, 29 May 2009 11:33:19 +0800
From: Ming Lei <tom.leiming@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver core : fix request_firmware_nowait
Message-ID: <20090529113319.274d7d4f@linux-lm>
In-Reply-To: <20090529014341.GA12295@kroah.com>
References: <1243004787-5362-1-git-send-email-tom.leiming@gmail.com>
	<20090522161016.36ef6f15@lxorguk.ukuu.org.uk>
	<d82e647a0905220826p378f6bb4vac9150343b5c3622@mail.gmail.com>
	<20090528201450.GA4043@kroah.com>
	<d82e647a0905281824kd98e5c9re22b4c43e68d341e@mail.gmail.com>
	<20090529014341.GA12295@kroah.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.4; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 May 2009 18:43:41 -0700
Greg KH <greg@kroah.com> wrote:
> 
> Anyway, I suggest just fixing the documentation, it's easier :)

Ok, it is the patch which fixes the documentation.
Thanks.

>From 32a1fe6013ed796d397417cc60d5e9a2aa66d74a Mon Sep 17 00:00:00 2001
From: Ming Lei <tom.leiming@gmail.com>
Date: Fri, 29 May 2009 11:23:04 +0800
Subject: [PATCH] driver core: fix documentation of request_firmware_nowait

request_firmware_nowait declares it can be called in non-sleep contexts,
but kthead_run called by request_firmware_nowait may sleep. So fix its
documentation and comment to make callers clear about it.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 Documentation/firmware_class/README |    3 ++-
 drivers/base/firmware_class.c       |    5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/firmware_class/README b/Documentation/firmware_class/README
index c3480aa..3a37ad3 100644
--- a/Documentation/firmware_class/README
+++ b/Documentation/firmware_class/README
@@ -77,7 +77,8 @@
    seconds for the whole load operation.
 
  - request_firmware_nowait() is also provided for convenience in
-   non-user contexts.
+   user contexts to request firmware asynchronously, but can't be called
+   in atomic contexts.
 
 
  about in-kernel persistence:
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 2d296b7..2427702 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -617,8 +617,9 @@ request_firmware_work_func(void *arg)
  * @cont: function will be called asynchronously when the firmware
  *	request is over.
  *
- *	Asynchronous variant of request_firmware() for contexts where
- *	it is not possible to sleep.
+ *	Asynchronous variant of request_firmware() for user contexts where
+ *	it is not possible to sleep for long time. It can't be called
+ *	in atomic contexts.
  **/
 int
 request_firmware_nowait(
-- 
1.6.0.GIT




-- 
Lei Ming
