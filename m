Return-Path: <linux-kernel-owner+w=401wt.eu-S1751276AbXAXLyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276AbXAXLyD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 06:54:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbXAXLyC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 06:54:02 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:44111 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbXAXLyA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 06:54:00 -0500
Date: Wed, 24 Jan 2007 12:53:11 +0100
From: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-aio <linux-aio@kvack.org>, Bharata B Rao <bharata@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>,
       Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: [PATCH -mm 5/5][AIO] - Add listio syscall support
Message-ID: <20070124125311.7fbe0393@frecb000686>
In-Reply-To: <45B72C7A.90803@bull.net>
References: <20070117104601.36b2ab18@frecb000686>
	<20070117105554.346324b4@frecb000686>
	<20070123215318.beddfdf7.akpm@osdl.org>
	<45B72C7A.90803@bull.net>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 24/01/2007 12:54:47,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 24/01/2007 12:54:48,
	Serialize complete at 24/01/2007 12:54:48
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jan 2007 10:52:58 +0100 Laurent Vivier <Laurent.Vivier@bull.net> wrote:

> Andrew Morton wrote:
> > On Wed, 17 Jan 2007 10:55:54 +0100
> > Sébastien Dugué <sebastien.dugue@bull.net> wrote:
> > 
> >> +struct lio_event *lio_create(struct sigevent __user *user_event,
> >> +			int mode)
> >> +{
> >> +	int ret = 0;
> >> +	struct lio_event *lio = NULL;
> >> +
> >> +	if (unlikely((mode == LIO_NOWAIT) && !user_event))
> >> +		return lio;
> >> +
> >> +	lio = kzalloc(sizeof(*lio), GFP_KERNEL);
> >> +
> >> +	if (!lio)
> >> +		return ERR_PTR(-EAGAIN);
> >> +
> > 
> > Why EAGAIN and not ENOMEM?
> 
> According to the POSIX AIO specifications:
> 
> "ERRORS:
> ...
> [EAGAIN]
>     The resources necessary to queue all the I/O requests were not available. "
> 
> I think memory is "a resource necessary to queue all the I/O requests"...
> 
> http://www.opengroup.org/onlinepubs/009695399/functions/lio_listio.html
> 
> Regards,
> Laurent

  Thanks Laurent,

  just forgot the whys here.

  Sébastien.
