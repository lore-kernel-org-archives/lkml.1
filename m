Return-Path: <linux-kernel-owner+w=401wt.eu-S932404AbYEHSoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404AbYEHSoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 14:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757500AbYEHSns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 14:43:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756818AbYEHSnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 14:43:47 -0400
Date: Thu, 8 May 2008 14:29:47 -0400
From: Josef Bacik <jbacik@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jbacik@redhat.com, trond.myklebust@fys.uio.no, npiggin@suse.de,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: NFS infinite loop in filemap_fault()
Message-ID: <20080508182947.GB30499@unused.rdu.redhat.com>
References: <E1JtqLW-0005j5-KU@pomaz-ex.szeredi.hu> <E1JtzuH-0006nY-AM@pomaz-ex.szeredi.hu> <20080508130759.GA30499@unused.rdu.redhat.com> <E1JuB47-0008C9-5n@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JuB47-0008C9-5n@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 08:42:03PM +0200, Miklos Szeredi wrote:
> > > Index: linux.git/mm/filemap.c
> > > ===================================================================
> > > --- linux.git.orig/mm/filemap.c	2008-05-08 08:17:22.000000000 +0200
> > > +++ linux.git/mm/filemap.c	2008-05-08 08:19:59.000000000 +0200
> > > @@ -1461,6 +1461,12 @@ page_not_uptodate:
> > >  	 */
> > >  	ClearPageError(page);
> > >  	error = mapping->a_ops->readpage(file, page);
> > > +	if (!error && !PageUptodate(page)) {
> > 
> > Shouldn't you have (!error || error != AOP_TRUNCATED_PAGE),
> 
> That would be a rather useless condition (hint: '!error' means 'error == 0')
> 
> > since the fs can
> > return AOP_TRUNCATED_PAGE if it needs vfs to try the readpage again?
> 
> Yep, I din't touch the 'error != 0' codepath.
>

Doh sorry, I hadn't had my coffee yet.

Josef 
