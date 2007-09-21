Return-Path: <linux-kernel-owner+w=401wt.eu-S1758529AbXIUNGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529AbXIUNGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 09:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756684AbXIUNGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 09:06:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36338 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749AbXIUNGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 09:06:44 -0400
Date: Fri, 21 Sep 2007 14:06:42 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [patch 3/5] VFS: pass open file to ->xattr()
Message-ID: <20070921130642.GA9431@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20070921122343.307289079@szeredi.hu> <20070921123333.247493758@szeredi.hu> <20070921124323.GA8088@infradead.org> <E1IYi74-0001dX-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IYi74-0001dX-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 03:00:06PM +0200, Miklos Szeredi wrote:
> I don't think it's silly.  Read/write get passed the file descriptor,
> and it makes a lot of sense, if the filesystem has stateful opens.
> 
> Similarly for any fs operation that gets a file descriptor, it makes
> sense to pass the relevant open file down into the filesystem.

read/write fundamentally operate on file descriptors.  None of these
operations does, rather their normal forms get a path name and special
forms operate on a file descriptor to avoid lookup races.  Still the
underlying operation has nothing to do with the file descriptor at all.

> If you look carefully, the ftrunacate() already does this, becuse
> without that it's impossible to implement correct semantics in the
> filesystem in some cases.

ftruncate is a special case due to O_TRUNC.  But I have plans to solve
this whole issue more elegant than the current hack.

> For other operations it's not impossible, but it would mean more hacks
> in the filesystem itself (such as sillyrenaming) that are entirely
> unneeded if the file info is available.

It's not a problem at all for filesystem that implement normal unix
semantics.  If you want to shoer-horn strange semantics that barely
fit, you'll need some more hacks.
