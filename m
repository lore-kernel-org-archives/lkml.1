Return-Path: <linux-kernel-owner+w=401wt.eu-S1760478AbYDAVvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760478AbYDAVvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756645AbYDAVvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 17:51:31 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:36757 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548AbYDAVva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:51:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dk/RZ/6NZpODT6hCBlCoADskFlejcv9DY1BrEZuHxeqVzHx+1IBlAW4N+XB4l5Qxpe3N09sxvYM5ktrWQ/2rMH6gG07apUtSJWQbQ9OfnjZx79Z898G5ZNOb8iYO5ZqHRuBdIKh4oWLIlLV9XjpxlahoooQAw/DQwWfpZ9kMC/M=
Message-ID: <bc64b4640804011451y71c095dfhddc26067a8d3eb6f@mail.gmail.com>
Date: Wed, 2 Apr 2008 01:51:28 +0400
From: Dmitry <dbaryshkov@gmail.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] Fix tosakbd suspend
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080401144224.GA6436@USFSHXP-002051>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080331213801.GA9372@doriath.ww600.siemens.net>
	 <20080401034903.GB18041@anvil.corenet.prv>
	 <bc64b4640804010627n172be3fbi9a43eb392c487358@mail.gmail.com>
	 <20080401144224.GA6436@USFSHXP-002051>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2008/4/1, Dmitry Torokhov <dmitry.torokhov@gmail.com>:
> On Tue, Apr 01, 2008 at 04:27:38PM +0300, Dmitry wrote:
>  > Hi, Dmitry,
>  >
>  > 2008/4/1, Dmitry Torokhov <dmitry.torokhov@gmail.com>:
>  > > Hi Dmitry,
>  > >
>  > >
>  > >  On Tue, Apr 01, 2008 at 01:38:01AM +0400, Dmitry Baryshkov wrote:
>  > >  > Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
>  > >  > ---
>  > >  >  drivers/input/keyboard/tosakbd.c |    3 +++
>  > >  >  1 files changed, 3 insertions(+), 0 deletions(-)
>  > >  >
>  > >  > diff --git a/drivers/input/keyboard/tosakbd.c b/drivers/input/keyboard/tosakbd.c
>  > >  > index 3884d1e..306cbe8 100644
>  > >  > --- a/drivers/input/keyboard/tosakbd.c
>  > >  > +++ b/drivers/input/keyboard/tosakbd.c
>  > >  > @@ -210,6 +210,9 @@ static int tosakbd_suspend(struct platform_device *dev, pm_message_t state)
>  > >  >
>  > >  >       del_timer_sync(&tosakbd->timer);
>  > >  >
>  > >
>  > >
>  > > What if interrupt comes here? The whole suspend path seems racy with
>  > >  interrup handler/timer.
>  >
>  > What is the best way to fix it? Moving from suspend to suspend_late
>  > seems to be a hack.
>  > Should I call a bunch of disable_irq or just introduce an atomic flag?
>  >
>
>
> How about we take the lock in tosakbd_suspend, set flag indicating that the
>  picece is suspended, do the discharge and then del_timer_sync()? If you change
>  tosakbd_scankeyboard() to check for suspend flag and exit as soon as it sees it
>  it should take care of the most of the issues I think. Something like this:

This should do the trick. I'll test the patch tomorrow.

-- 
With best wishes
Dmitry
