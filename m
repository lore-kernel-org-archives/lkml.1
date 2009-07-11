Return-Path: <linux-kernel-owner+w=401wt.eu-S1755866AbZGKKSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbZGKKSU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 06:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbZGKKSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 06:18:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:58006 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880AbZGKKSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 06:18:11 -0400
Subject: Re: [PATCH 5/5] staging/otus: Move a dereference below a NULL test
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Julia Lawall <julia@diku.dk>, gregkh@suse.de, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <4A584A94.5010105@gmail.com>
References: <Pine.LNX.4.64.0907110950510.29592@ask.diku.dk>
	 <4A584A94.5010105@gmail.com>
Content-Type: text/plain
Date: Sat, 11 Jul 2009 15:47:24 +0530
Message-Id: <1247307444.3032.2.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-07-11 at 10:17 +0200, Jiri Slaby wrote:
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
> 

Why useless, it should be non-null before setting to dev.

But issue is why function name like kevent() is global and who is using
it.

> > +    dev = macp->device;
> 
> 

Thanks,
--
JSR

