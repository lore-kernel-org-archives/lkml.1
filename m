Return-Path: <linux-kernel-owner+w=401wt.eu-S1759016AbXEQSgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759016AbXEQSgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 14:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755752AbXEQSga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 14:36:30 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55253 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575AbXEQSg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 14:36:29 -0400
Date: Thu, 17 May 2007 19:36:28 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: David Woodhouse <dwmw2@infradead.org>, dedekind@infradead.org,
       akpm@osdl.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH] ubi: kill homegrown endian macros
Message-ID: <20070517183628.GA12282@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Sam Ravnborg <sam@ravnborg.org>,
	David Woodhouse <dwmw2@infradead.org>, dedekind@infradead.org,
	akpm@osdl.org, linux-kernel@vger.kernel.org,
	viro@zeniv.linux.org.uk
References: <20070517143200.GA30850@lst.de> <1179417055.2859.506.camel@shinybook.infradead.org> <20070517181223.GA17765@lst.de> <20070517182314.GA5584@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070517182314.GA5584@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 08:23:14PM +0200, Sam Ravnborg wrote:
> On Thu, May 17, 2007 at 08:12:23PM +0200, Christoph Hellwig wrote:
> > On Thu, May 17, 2007 at 11:50:54PM +0800, David Woodhouse wrote:
> > > On Thu, 2007-05-17 at 16:32 +0200, Christoph Hellwig wrote:
> > > > Kill ubis homegrown endianess handling crap and replace it with
> > > > the normal kernel endianess handling. 
> > > 
> > > NAK. The 'normal' kernel stuff doesn't work in GCC; only in sparse.
> > > 
> > > If you want to go removing the ones which _do_ work in GCC, then fix the
> > > 'normal' one first. _Then_ go about converting others over to it.
> > 
> > Nope.  gcc checking is crap and we need to run sparse anyway.  It's what
> > everyone in the kernel use so it's perfect for some random code almost
> > no one uses aswell.
> 
> Care to explain what is wrong with the gcc checks as used by UBI?
> Would be nice to know before someone start to migrate current
> stuff so gcc can check for correct endian.

The major wrong thing is that it makes a little subsysttem artifically
different from the rest of the kernel.

At a technical level it overdoing things.  The attribute syntax is perfecltly
find to address endianess issues without introducing wrapper structs the
lead to horrible code generation in some situations (e.g. trying to return
such a value)
