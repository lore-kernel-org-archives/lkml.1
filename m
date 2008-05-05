Return-Path: <linux-kernel-owner+w=401wt.eu-S1761166AbYEEURZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761166AbYEEURZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 16:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760840AbYEEURB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 16:17:01 -0400
Received: from pat.uio.no ([129.240.10.15]:53235 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757580AbYEEUQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 16:16:48 -0400
Subject: Re: VFS + path walktrough
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, weigelt@metux.de, linux-kernel@vger.kernel.org
In-Reply-To: <E1Jt5Td-0006rG-3E@pomaz-ex.szeredi.hu>
References: <20080505124041.GB32019@nibiru.local>
	 <20080505130623.GC32019@nibiru.local>
	 <20080505131307.GM5882@ZenIV.linux.org.uk>
	 <20080505134315.GF32019@nibiru.local>
	 <20080505153501.GN5882@ZenIV.linux.org.uk>
	 <E1Jt3nB-0006ZP-6S@pomaz-ex.szeredi.hu>
	 <20080505171425.GO5882@ZenIV.linux.org.uk>
	 <E1Jt4Ye-0006hz-9i@pomaz-ex.szeredi.hu>
	 <20080505174048.GP5882@ZenIV.linux.org.uk>
	 <E1Jt526-0006le-04@pomaz-ex.szeredi.hu>
	 <E1Jt5Td-0006rG-3E@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Date: Mon, 05 May 2008 16:16:39 -0400
Message-Id: <1210018599.7448.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5)
X-UiO-Scanned: B7DBAA2E37FD71D3899091ED93BD9ADC477B5395
X-UiO-SR-test: D8B1555B89EC345357226BF06E69DC8E8AC8E2B6
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 258 total 8236034 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-05-05 at 20:31 +0200, Miklos Szeredi wrote:
> > > > >  Take a look at 9P walk - it does *not* give
> > > > > you anything resembling stat, you just get qids of intermediates.
> > > > 
> > > > Which is exactly what's needed to populate the dentry tree, no?
> > > 
> > > No - you need inodes as well (i.e. as the absolute least you want
> > > mode and ownership).  Which is to say, you need to issue stat on
> > > each component in such situation anyway.  Not a win...
> 
> And actually even that *could* be a win, if the network latency is
> large.  Because by doing the lookup first, the stats can be performed
> in parallel.  So a path with an arbitrary number of components could
> be resolved in just 2 RTTs.

...and NFSv4 could do it in a single RPC call (assuming no symlinks or
submounts).

Cheers
  Trond

