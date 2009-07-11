Return-Path: <linux-kernel-owner+w=401wt.eu-S1752403AbZGKS2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbZGKS2Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 14:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbZGKS2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 14:28:17 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:39766 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696AbZGKS2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 14:28:17 -0400
Date: Sat, 11 Jul 2009 20:28:11 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Greg KH <gregkh@suse.de>
Cc: Jiri Slaby <jirislaby@gmail.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 5/5] staging/otus: Move a dereference below a NULL test
In-Reply-To: <20090711170356.GA5205@suse.de>
Message-ID: <Pine.LNX.4.64.0907112027530.1525@ask.diku.dk>
References: <Pine.LNX.4.64.0907110950510.29592@ask.diku.dk> <4A584A94.5010105@gmail.com>
 <20090711170356.GA5205@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Jul 2009, Greg KH wrote:

> On Sat, Jul 11, 2009 at 10:17:24AM +0200, Jiri Slaby wrote:
> > On 07/11/2009 09:51 AM, Julia Lawall wrote:
> > > diff -u -p a/drivers/staging/otus/wwrap.c b/drivers/staging/otus/wwrap.c
> > > --- a/drivers/staging/otus/wwrap.c
> > > +++ b/drivers/staging/otus/wwrap.c
> > > @@ -1016,12 +1016,13 @@ void kevent(struct work_struct *work)
> > >  {
> > >      struct usbdrv_private *macp =
> > >                 container_of(work, struct usbdrv_private, kevent);
> > > -    zdev_t *dev = macp->device;
> > > +    zdev_t *dev;
> > >  
> > >      if (macp == NULL)
> > >      {
> > >          return;
> > >      }
> > 
> > The test is rather useless here.
> 
> Yes it is. 
> 
> Julia, if you just remove the NULL check, will that keep your scripts
> happy from noticing such a "problem"?

Yes.  The trigger is the NULL test after the dereference.

julia
