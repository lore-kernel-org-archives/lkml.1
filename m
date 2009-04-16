Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbZDPVqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbZDPVqR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 17:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754175AbZDPVp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 17:45:59 -0400
Received: from mail.fieldses.org ([141.211.133.115]:52914 "EHLO
	pickle.fieldses.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbZDPVp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 17:45:58 -0400
Date: Thu, 16 Apr 2009 17:45:45 -0400
To: David Woodhouse <dwmw2@infradead.org>
Cc: "hooanon05@yahoo.co.jp" <hooanon05@yahoo.co.jp>,
       Al Viro <viro@zeniv.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: Q: NFSD readdir in linux-2.6.28
Message-ID: <20090416214545.GA2237@fieldses.org>
References: <8036.1237474444@jrobl> <1237475837.16359.106.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237475837.16359.106.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 03:17:17PM +0000, David Woodhouse wrote:
> On Thu, 2009-03-19 at 14:54 +0000, hooanon05@yahoo.co.jp wrote:
> > 
> > Hello David and Al,
> > I have a question about NFSD readdir.
> > 
> > By the commit 14f7dd632011bb89c035722edd6ea0d90ca6b078
> > "[PATCH] Copy XFS readdir hack into nfsd code", nfsd_buffered_filldir()
> > was introduced and nfs3svc_encode_entry_plus() (the 'func' parameter) is
> > not called from vfs_readdir().
> > 
> > In 2.6.27, when nfs3svc_encode_entry_plus() calls lookup_one_len(), the
> > i_mutex lock was acquired by vfs_readdir() and it was not a problem.
> > 
> > After the commit (above), nfsd_readdir/nfsd_buffered_readdir/vfs_readdir
> > calls nfsd_buffered_filldir(), and nfs3svc_encode_entry_plus() is called
> > later.
> > In this sequence, lookup_one_len() is called without i_mutex held.
> > 
> > Isn't it a problem?
> 
> Yes, well spotted. It didn't matter when the buffered readdir() was
> purely internal to XFS, because it didn't matter there that we called
> ->lookup() without i_mutex set. But now we're exposing arbitrary file
> systems to it, we need to make sure we follow the locking rules. 
> 
> I _think_ it's sufficient to make the affected callers of
> lookup_one_len() lock the parent's i_mutex for themselves before calling
> it. I'll take a closer look...

Yipes--is this problem still here?

--b.
