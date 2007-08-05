Return-Path: <linux-kernel-owner+w=401wt.eu-S1761074AbXHEK3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761074AbXHEK3U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 06:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755366AbXHEK3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 06:29:10 -0400
Received: from unthought.net ([212.97.129.88]:3385 "EHLO unthought.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375AbXHEK3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 06:29:08 -0400
X-Greylist: delayed 526 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Aug 2007 06:29:08 EDT
Date: Sun, 5 Aug 2007 12:29:07 +0200
From: Jakob Oestergaard <jakob@unthought.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Claudio Martins <ctpm@ist.utl.pt>,
       Jeff Garzik <jeff@garzik.org>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-ID: <20070805102907.GB4246@unthought.net>
Mail-Followup-To: Jakob Oestergaard <jakob@unthought.net>,
	Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Claudio Martins <ctpm@ist.utl.pt>, Jeff Garzik <jeff@garzik.org>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
	dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
	trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
	richard@rsk.demon.co.uk, david@lang.hm
References: <20070803123712.987126000@chello.nl> <46B4E161.9080100@garzik.org> <20070804224706.617500a0@the-village.bc.nu> <200708050051.40758.ctpm@ist.utl.pt> <20070805014926.400d0608@the-village.bc.nu> <20070805072805.GB4414@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070805072805.GB4414@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 05, 2007 at 09:28:05AM +0200, Ingo Molnar wrote:
> 
> * Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > >  Can you give examples of backup solutions that rely on atime being 
> > > updated? I can understand backup tools using mtime/ctime for 
> > > incremental backups (like tar + Amanda, etc), but I'm having trouble 
> > > figuring out why someone would want to use atime for that.
> > 
> > HSM is the usual one, and to a large extent probably why Unix 
> > originally had atime. Basically migrating less used files away so as 
> > to keep the system disks tidy.
> 
> atime is used as a _hint_, at most and HSM sure works just fine on an 
> atime-incapable filesystem too. So it's the same deal as "add user_xattr 
> mount option to the filesystem to make Beagle index faster". It's now: 
> "if you use HSM storage add the atime mount option to make it slightly 
> more intelligent. Expect huge IO slowdowns though."
> 
> The only remotely valid compatibility argument would be Mutt - but even 
> that handles it just fine. (we broke way more software via noexec)

I find it pretty normal to use tmpreaper to clear out unused files from
certain types of semi-temporary directory structures. Those files are
often only ever read. They'd start randomly disappearing while in use.

But then again, maybe I'm the only guy on the planet who uses tmpreaper.

-- 

 / jakob

