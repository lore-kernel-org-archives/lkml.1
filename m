Return-Path: <linux-kernel-owner+w=401wt.eu-S1759848AbXIZPH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759848AbXIZPH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 11:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754362AbXIZPHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 11:07:49 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38748 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826AbXIZPHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 11:07:48 -0400
Date: Wed, 26 Sep 2007 16:07:45 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: haveblue@us.ibm.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: missing mnt_drop_write() on open error
Message-ID: <20070926150745.GB24744@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Miklos Szeredi <miklos@szeredi.hu>, haveblue@us.ibm.com,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <E1IaJc0-000541-00@dorka.pomaz.szeredi.hu> <1190769669.26982.325.camel@localhost> <E1IaSPW-0005M4-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IaSPW-0005M4-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2007 at 10:38:22AM +0200, Miklos Szeredi wrote:
> Also even more horrible things can happen because of the
> nd->intent.open.file thing.  For example if the lookup routine calls
> lookup_instantiate_filp(), and after this, but before may_open() some
> error happens, then release_open_intent() will call fput() on the
> file, which will cause mnt_drop_write() to be called, even though a
> matching mnt_want_write() hasn't yet been called.  Ugly, eh?

It's more than horrible.  I wouldn't mind using the word utter crap
for it.  It's defintively on my todo list to get rid of this junk
again.  It managed to get in without proper review unfortunately.

> 
> > I'm also thinking that we should change the open_namei*
> > functions to simply return 'struct file *'.  Those are the only users
> > other than NFS, and forcing the return of a file like that will force
> > users to do the fput() on it if they don't want it any more.  We'd just
> > need to make sure no new may_open() users pop up.  Any thoughts on that?
> 
> Yeah, something needs to be done with open, because currently it's way
> too convoluted.

I have some changes for open_namei pending and I'll see if incorporating
this makes sense.
