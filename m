Return-Path: <linux-kernel-owner+w=401wt.eu-S1763552AbYD3MgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763552AbYD3MgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 08:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762696AbYD3MgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 08:36:12 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:56713 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763129AbYD3MgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 08:36:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=cEE7xhpPlKjDo3m4nb7I9zg0ThWL9M2OOv98khAjuFeYLj5Z72BNr1ICBr7GDV1QapL+5ORHL6soBUn02abE3cUsfOzrBG1UPYrFGJokFYHldZGboeMYCNOqnvibsetFtIvj3UI3ETiVpmdXKtVsw2XLtXEjcLgGrbHu9Mgl7+g=
Message-ID: <37219a840804300536y720facfeg91872b207c617989@mail.gmail.com>
Date: Wed, 30 Apr 2008 08:36:09 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [v4l-dvb-maintainer] [patch, -git] media/video/sound build fix, TEA5761/TEA5767
Cc: "Takashi Iwai" <tiwai@suse.de>, video4linux-list@redhat.com,
       "Mike Galbraith" <efault@gmx.de>, linux-kernel@vger.kernel.org,
       "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       linux-dvb-maintainer@linuxtv.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080430112138.GA11844@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080430110115.GA5633@elte.hu> <s5hiqxzwqak.wl%tiwai@suse.de>
	 <20080430111516.GA9954@elte.hu> <20080430111803.GA11628@elte.hu>
	 <20080430112138.GA11844@elte.hu>
X-Google-Sender-Auth: 4c5c0492dcf3edcc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 7:21 AM, Ingo Molnar <mingo@elte.hu> wrote:
>  Subject: dvb: fix3
>  From: Ingo Molnar <mingo@elte.hu>
>  Date: Mon Apr 28 23:22:13 CEST 2008
>
>  Signed-off-by: Ingo Molnar <mingo@elte.hu>
>  ---
>   drivers/media/video/cx23885/Kconfig |    2 ++
>   1 file changed, 2 insertions(+)
>
>  Index: linux/drivers/media/video/cx23885/Kconfig
>  ===================================================================
>  --- linux.orig/drivers/media/video/cx23885/Kconfig
>  +++ linux/drivers/media/video/cx23885/Kconfig
>  @@ -9,6 +9,8 @@ config VIDEO_CX23885
>         select VIDEO_IR
>         select VIDEOBUF_DVB
>         select VIDEO_CX25840
>  +       select VIDEO_CX2341X
>  +       select DVB_DIB7000P
>         select MEDIA_TUNER_MT2131 if !DVB_FE_CUSTOMISE
>         select DVB_S5H1409 if !DVB_FE_CUSTOMISE
>         select DVB_LGDT330X if !DVB_FE_CUSTOMISE


Ingo,

It should actually be as follows:



[PATCH] cx23885: fix kbuild dependencies

Thanks to Ingo Molnar for finding this.

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>

--- linux.orig/drivers/media/video/cx23885/Kconfig
+++ linux/drivers/media/video/cx23885/Kconfig
@@ -9,6 +9,8 @@ config VIDEO_CX23885
 	select VIDEO_IR
 	select VIDEOBUF_DVB
 	select VIDEO_CX25840
+	select VIDEO_CX2341X
+	select DVB_DIB7000P if !DVB_FE_CUSTOMISE
 	select MEDIA_TUNER_MT2131 if !DVB_FE_CUSTOMISE
 	select DVB_S5H1409 if !DVB_FE_CUSTOMISE
 	select DVB_LGDT330X if !DVB_FE_CUSTOMISE
