Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbZDQTcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbZDQTcv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 15:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbZDQTck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 15:32:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33805 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbZDQTck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 15:32:40 -0400
Date: Fri, 17 Apr 2009 20:32:33 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: hooanon05@yahoo.co.jp, hch@infradead.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: Q: NFSD readdir in linux-2.6.28
Message-ID: <20090417193233.GM26366@ZenIV.linux.org.uk>
References: <8036.1237474444@jrobl> <1237475837.16359.106.camel@macbook.infradead.org> <8913.1237476890@jrobl> <1239960739.3428.33.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239960739.3428.33.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 10:32:19AM +0100, David Woodhouse wrote:
> On Fri, 2009-03-20 at 00:34 +0900, hooanon05@yahoo.co.jp wrote:
> > David Woodhouse:
> > > Yes, well spotted. It didn't matter when the buffered readdir() was
> > > purely internal to XFS, because it didn't matter there that we called
> > > ->lookup() without i_mutex set. But now we're exposing arbitrary file
> > > systems to it, we need to make sure we follow the locking rules. 
> > > 
> > > I _think_ it's sufficient to make the affected callers of
> > > lookup_one_len() lock the parent's i_mutex for themselves before calling
> > > it. I'll take a closer look...
> > 
> > If you remember why you discarded the FS_NO_LOOKUP_IN_READDIR flag
> > approach, please let me know. URL or something is enough.
> 
> I think someone talked me into doing it in the interest of simplicity,
> so we confine the necessary hack into the NFS code alone and _always_
> just use the "safe" version. I can't remember who it was, but I'm
> guessing Al or Christoph -- both of whom are CC'd in case they want to
> object:

Ow...  Sorry, I've missed that one.  I really don't like flags-based
solution ;-/  It's not just filesystem method that want i_mutex there -
we have fs/namei.c code suddenly called in different locking conditions
now.

What were the details of xfs and jffs2 locking problems, just in case
if something can be done in that direction short-term?

