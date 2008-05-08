Return-Path: <linux-kernel-owner+w=401wt.eu-S1761724AbYEHSm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761724AbYEHSm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 14:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754183AbYEHSmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 14:42:14 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:37182 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751AbYEHSmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 14:42:13 -0400
To: jbacik@redhat.com
CC: miklos@szeredi.hu, trond.myklebust@fys.uio.no, npiggin@suse.de,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org
In-reply-to: <20080508130759.GA30499@unused.rdu.redhat.com> (message from
	Josef Bacik on Thu, 8 May 2008 09:07:59 -0400)
Subject: Re: NFS infinite loop in filemap_fault()
References: <E1JtqLW-0005j5-KU@pomaz-ex.szeredi.hu> <E1JtzuH-0006nY-AM@pomaz-ex.szeredi.hu> <20080508130759.GA30499@unused.rdu.redhat.com>
Message-Id: <E1JuB47-0008C9-5n@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 08 May 2008 20:42:03 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Index: linux.git/mm/filemap.c
> > ===================================================================
> > --- linux.git.orig/mm/filemap.c	2008-05-08 08:17:22.000000000 +0200
> > +++ linux.git/mm/filemap.c	2008-05-08 08:19:59.000000000 +0200
> > @@ -1461,6 +1461,12 @@ page_not_uptodate:
> >  	 */
> >  	ClearPageError(page);
> >  	error = mapping->a_ops->readpage(file, page);
> > +	if (!error && !PageUptodate(page)) {
> 
> Shouldn't you have (!error || error != AOP_TRUNCATED_PAGE),

That would be a rather useless condition (hint: '!error' means 'error == 0')

> since the fs can
> return AOP_TRUNCATED_PAGE if it needs vfs to try the readpage again?

Yep, I din't touch the 'error != 0' codepath.

Miklos
