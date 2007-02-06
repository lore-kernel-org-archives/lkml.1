Return-Path: <linux-kernel-owner+w=401wt.eu-S1751734AbXBFLlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734AbXBFLlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 06:41:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbXBFLlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 06:41:09 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:55752 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbXBFLlH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 06:41:07 -0500
Date: Tue, 6 Feb 2007 12:39:46 +0100
From: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       linux-aio <linux-aio@kvack.org>, Bharata B Rao <bharata@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Badari Pulavarty <pbadari@us.ibm.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>
Subject: Re: [PATCH -mm][AIO] AIO completion signal notification fixes and
 cleanups
Message-ID: <20070206123946.401bf57f@frecb000686>
In-Reply-To: <20070206110539.GA129@tv-sign.ru>
References: <20070201102252.240130c6@frecb000686>
	<20070201103053.64489048@frecb000686>
	<20070202180039.GA658@tv-sign.ru>
	<20070205131839.6f601c3e@frecb000686>
	<20070205134314.GA283@tv-sign.ru>
	<20070205170056.6a29b19b@frecb000686>
	<20070205171335.GA528@tv-sign.ru>
	<20070206102253.20b121ae@frecb000686>
	<20070206110539.GA129@tv-sign.ru>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 06/02/2007 12:42:09,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 06/02/2007 12:42:10,
	Serialize complete at 06/02/2007 12:42:10
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Feb 2007 14:05:39 +0300 Oleg Nesterov <oleg@tv-sign.ru> wrote:

> On 02/06, S?bastien Dugu? wrote:
> > 
> > @@ -970,8 +969,14 @@ static long aio_setup_sigevent(struct ai
> >  	rcu_read_lock();
> >  	target = sigevent_find_task(&event);
> >  
> > -	if (unlikely(!target))
> > +	if (unlikely(!target)) {
> > +		/*
> > +		 * Revert notify to SIGEV_NONE so that really_put_req()
> > +		 * knows that no ref has been taken on a task.
> > +		 */
> > +		notify->notify = SIGEV_NONE;
> >  		goto out_unlock;
> > +	}
> 
> Very minor nit, feel free to ignore.
> 
> Isn't it better to move "notify->* = event.*;" down, when we know that
> target != NULL. Imho, a bit easier to follow. This way we don't need to
> reset notify->notify = SIGEV_NONE.
> 
> aio_setup_sigevent() relies on the fact that ->notify = SIGEV_NONE on
> entry anyway.

  Yep, right, it will make things cleaner.

  Thanks,

  Sébastien.
