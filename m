Return-Path: <linux-kernel-owner+w=401wt.eu-S1751635AbXBFIdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635AbXBFIdI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 03:33:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbXBFIdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 03:33:08 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:60866 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbXBFIdG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 03:33:06 -0500
Date: Tue, 6 Feb 2007 09:31:42 +0100
From: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       linux-aio <linux-aio@kvack.org>, Bharata B Rao <bharata@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Badari Pulavarty <pbadari@us.ibm.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>
Subject: Re: [PATCH -mm][AIO] Fix AIO completion signal notification
 possible ref leak
Message-ID: <20070206093142.738f93e6@frecb000686>
In-Reply-To: <20070205171335.GA528@tv-sign.ru>
References: <20070201102252.240130c6@frecb000686>
	<20070201103053.64489048@frecb000686>
	<20070202180039.GA658@tv-sign.ru>
	<20070205131839.6f601c3e@frecb000686>
	<20070205134314.GA283@tv-sign.ru>
	<20070205170056.6a29b19b@frecb000686>
	<20070205171335.GA528@tv-sign.ru>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 06/02/2007 09:34:07,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 06/02/2007 09:34:08,
	Serialize complete at 06/02/2007 09:34:08
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Feb 2007 20:13:35 +0300 Oleg Nesterov <oleg@tv-sign.ru> wrote:

> On 02/05, S?bastien Dugu? wrote:
> > 
> >   Make sure we only accept valid sigev_notify values in aio_setup_sigevent(),
> > namely SIGEV_NONE, SIGEV_THREAD_ID or SIGEV_SIGNAL.
> 
> I think this is correct, but I have another concern (most probably I just
> confused looking at non-applied patch), could you re-check?
> 
> > @@ -959,6 +959,10 @@ static long aio_setup_sigevent(struct ai
> >  	if (event.sigev_notify == SIGEV_NONE)
> >  		return 0;
> >  
> > +	if (event.sigev_notify != SIGEV_SIGNAL &&
> > +	    event.sigev_notify != SIGEV_THREAD_ID)
> > +		return -EINVAL;
> > +
> >  	notify->notify = event.sigev_notify;
> >  	notify->signo = event.sigev_signo;
> >  	notify->value = event.sigev_value;
> 
> Ok. But what if sigevent_find_task() fails after that? Doesn't this mean
> that really_put_req() will do put_task_struct(NULL) ?
> 

  Argh, right, a patch to fix that and a couple of other corner cases to
follow soon.

  Thanks Oleg for looking through this.

  Sébastien.
