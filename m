Return-Path: <linux-kernel-owner+w=401wt.eu-S1758552AbYDAN1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552AbYDAN1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 09:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755310AbYDAN1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 09:27:40 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:52220 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756611AbYDAN1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 09:27:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YrS/asY0VkyPt+Yu/zV781qSIgpGHeYj4/RcHJPqJLVMCXhZEHk9HX2hOlDiTUHMv59/FeQyFDeHSgF4TGff90pkoGVFuPfLoYxAc66gXGqqoHyQvT4x59LLRWIiLf4wwllOaok5+K+ahVIM3bGqpv2s/75k5k3qz6TTmLI0JUw=
Message-ID: <bc64b4640804010627n172be3fbi9a43eb392c487358@mail.gmail.com>
Date: Tue, 1 Apr 2008 16:27:38 +0300
From: Dmitry <dbaryshkov@gmail.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] Fix tosakbd suspend
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080401034903.GB18041@anvil.corenet.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080331213801.GA9372@doriath.ww600.siemens.net>
	 <20080401034903.GB18041@anvil.corenet.prv>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Dmitry,

2008/4/1, Dmitry Torokhov <dmitry.torokhov@gmail.com>:
> Hi Dmitry,
>
>
>  On Tue, Apr 01, 2008 at 01:38:01AM +0400, Dmitry Baryshkov wrote:
>  > Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
>  > ---
>  >  drivers/input/keyboard/tosakbd.c |    3 +++
>  >  1 files changed, 3 insertions(+), 0 deletions(-)
>  >
>  > diff --git a/drivers/input/keyboard/tosakbd.c b/drivers/input/keyboard/tosakbd.c
>  > index 3884d1e..306cbe8 100644
>  > --- a/drivers/input/keyboard/tosakbd.c
>  > +++ b/drivers/input/keyboard/tosakbd.c
>  > @@ -210,6 +210,9 @@ static int tosakbd_suspend(struct platform_device *dev, pm_message_t state)
>  >
>  >       del_timer_sync(&tosakbd->timer);
>  >
>
>
> What if interrupt comes here? The whole suspend path seems racy with
>  interrup handler/timer.

What is the best way to fix it? Moving from suspend to suspend_late
seems to be a hack.
Should I call a bunch of disable_irq or just introduce an atomic flag?

>
>
>  > +     PGSR1 = (PGSR1 & ~TOSA_GPIO_LOW_STROBE_BIT);
>  > +     PGSR2 = (PGSR2 & ~TOSA_GPIO_HIGH_STROBE_BIT);
>  > +
>  >       return 0;
>  >  }
>  >
>
>  --
>
> Dmitry
>


-- 
With best wishes
Dmitry
