Return-Path: <linux-kernel-owner+w=401wt.eu-S1758566AbZGKIcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566AbZGKIcA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 04:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbZGKIbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 04:31:51 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:55380 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220AbZGKIbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 04:31:50 -0400
Date: Sat, 11 Jul 2009 10:31:47 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 5/5] staging/otus: Move a dereference below a NULL test
In-Reply-To: <4A584A94.5010105@gmail.com>
Message-ID: <Pine.LNX.4.64.0907111031180.29592@ask.diku.dk>
References: <Pine.LNX.4.64.0907110950510.29592@ask.diku.dk> <4A584A94.5010105@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Jul 2009, Jiri Slaby wrote:

> On 07/11/2009 09:51 AM, Julia Lawall wrote:
> > diff -u -p a/drivers/staging/otus/wwrap.c b/drivers/staging/otus/wwrap.c
> > --- a/drivers/staging/otus/wwrap.c
> > +++ b/drivers/staging/otus/wwrap.c
> > @@ -1016,12 +1016,13 @@ void kevent(struct work_struct *work)
> >  {
> >      struct usbdrv_private *macp =
> >                 container_of(work, struct usbdrv_private, kevent);
> > -    zdev_t *dev = macp->device;
> > +    zdev_t *dev;
> >  
> >      if (macp == NULL)
> >      {
> >          return;
> >      }
> 
> The test is rather useless here.

OK, I will submit a revised patch that just drops it.

thanks,
julia

> > +    dev = macp->device;
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
