Return-Path: <linux-kernel-owner+w=401wt.eu-S1752123AbZGKRYD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbZGKRYD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 13:24:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbZGKRXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 13:23:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43304 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbZGKRXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 13:23:51 -0400
Date: Sat, 11 Jul 2009 10:03:56 -0700
From: Greg KH <gregkh@suse.de>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Julia Lawall <julia@diku.dk>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 5/5] staging/otus: Move a dereference below a NULL test
Message-ID: <20090711170356.GA5205@suse.de>
References: <Pine.LNX.4.64.0907110950510.29592@ask.diku.dk>
 <4A584A94.5010105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A584A94.5010105@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 11, 2009 at 10:17:24AM +0200, Jiri Slaby wrote:
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

Yes it is. 

Julia, if you just remove the NULL check, will that keep your scripts
happy from noticing such a "problem"?

thanks,

greg k-h
