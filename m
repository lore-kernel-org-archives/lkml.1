Return-Path: <linux-kernel-owner+w=401wt.eu-S1754652AbZGKL6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbZGKL6T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 07:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbZGKL6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 07:58:10 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:41167 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697AbZGKL6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 07:58:09 -0400
Date: Sat, 11 Jul 2009 13:58:05 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, gregkh@suse.de,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 5/5] staging/otus: Move a dereference below a NULL test
In-Reply-To: <Pine.LNX.4.64.0907111331170.31089@ask.diku.dk>
Message-ID: <Pine.LNX.4.64.0907111356400.31089@ask.diku.dk>
References: <Pine.LNX.4.64.0907110950510.29592@ask.diku.dk>  <4A584A94.5010105@gmail.com>
 <1247307444.3032.2.camel@hpdv5.satnam> <4A587245.1080304@gmail.com>
 <Pine.LNX.4.64.0907111331170.31089@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Jul 2009, Julia Lawall wrote:

> On Sat, 11 Jul 2009, Jiri Slaby wrote:
> 
> > On 07/11/2009 12:17 PM, Jaswinder Singh Rajput wrote:
> > > On Sat, 2009-07-11 at 10:17 +0200, Jiri Slaby wrote:
> > >> On 07/11/2009 09:51 AM, Julia Lawall wrote:
> > >>> --- a/drivers/staging/otus/wwrap.c
> > >>> +++ b/drivers/staging/otus/wwrap.c
> > >>> @@ -1016,12 +1016,13 @@ void kevent(struct work_struct *work)
> > >>>  {
> > >>>      struct usbdrv_private *macp =
> > >>>                 container_of(work, struct usbdrv_private, kevent);
> > >>> -    zdev_t *dev = macp->device;
> > >>> +    zdev_t *dev;
> > >>>  
> > >>>      if (macp == NULL)
> > >>>      {
> > >>>          return;
> > >>>      }
> > >>
> > >> The test is rather useless here.
> > >>
> > > 
> > > Why useless, it should be non-null before setting to dev.
> > 
> > Even if work was NULL, macp won't be NULL.
> 
> work could be a small negative number such that calling container_of would 
> return 0.

On the other hand, that does not seem to be possible in this case, since 
work is passed through INIT_WORK, which dereferences the work value.

julia
