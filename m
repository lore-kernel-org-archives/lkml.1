Return-Path: <linux-kernel-owner+w=401wt.eu-S965684AbXAYJCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965684AbXAYJCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 04:02:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965717AbXAYJCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 04:02:52 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:54288 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965684AbXAYJCu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 04:02:50 -0500
Date: Thu, 25 Jan 2007 10:01:34 +0100
From: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-aio <linux-aio@kvack.org>, Bharata B Rao <bharata@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Badari Pulavarty <pbadari@us.ibm.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>
Subject: [PATCH -mm] AIO - Comment aio_setup_sigevent() explaining why there
 is no task ref leak
Message-ID: <20070125100134.5f1e1340@frecb000686>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 25/01/2007 10:03:34,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 25/01/2007 10:03:41,
	Serialize complete at 25/01/2007 10:03:41
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Here it is

On Thu, 25 Jan 2007 05:42:42 +0000 Christoph Hellwig <hch@infradead.org> wrote:

> On Wed, Jan 24, 2007 at 12:11:30PM +0100, S?bastien Dugu? wrote:
> > > > +	if (unlikely(!notify->sigq))
> > > > +		return -EAGAIN;
> > > 
> > > Did this just leak a ref on the task_struct?
> > > 
> > 
> >   No, the ref is released in really_put_req() when we dispose of
> > the iocb.
> 
> And the code really needs a comment explaining this.  I tripped over
> this before, and I think it's even already the second time Andrew
> stumbled over it.
> 

From: Sébastien Dugué <sebastien.dugue@bull.net>

  Add a comment explaining why there is no task ref leak in
aio_setup_sigevent().


 aio.c |    5 +++++
 1 file changed, 5 insertions(+)


Signed-off-by: Sébastien Dugué <sebastien.dugue@bull.net>

Index: linux-2.6.20-rc4-mm1/fs/aio.c
===================================================================
--- linux-2.6.20-rc4-mm1.orig/fs/aio.c	2007-01-17 08:59:16.000000000 +0100
+++ linux-2.6.20-rc4-mm1/fs/aio.c	2007-01-25 09:52:29.000000000 +0100
@@ -987,6 +987,11 @@ static long aio_setup_sigevent(struct ai
 	 */
 	notify->sigq = sigqueue_alloc();
 
+	/*
+	 * The task ref will be released in really_put_req()
+	 * when we dispose of the iocb later on in the submission
+	 * path.
+	 */
 	if (unlikely(!notify->sigq))
 		return -EAGAIN;
 
