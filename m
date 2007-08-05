Return-Path: <linux-kernel-owner+w=401wt.eu-S1757713AbXHEH2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713AbXHEH2k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 03:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbXHEH2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 03:28:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38613 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631AbXHEH23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 03:28:29 -0400
Date: Sun, 5 Aug 2007 09:28:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Claudio Martins <ctpm@ist.utl.pt>, Jeff Garzik <jeff@garzik.org>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-ID: <20070805072805.GB4414@elte.hu>
References: <20070803123712.987126000@chello.nl> <46B4E161.9080100@garzik.org> <20070804224706.617500a0@the-village.bc.nu> <200708050051.40758.ctpm@ist.utl.pt> <20070805014926.400d0608@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070805014926.400d0608@the-village.bc.nu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> >  Can you give examples of backup solutions that rely on atime being 
> > updated? I can understand backup tools using mtime/ctime for 
> > incremental backups (like tar + Amanda, etc), but I'm having trouble 
> > figuring out why someone would want to use atime for that.
> 
> HSM is the usual one, and to a large extent probably why Unix 
> originally had atime. Basically migrating less used files away so as 
> to keep the system disks tidy.

atime is used as a _hint_, at most and HSM sure works just fine on an 
atime-incapable filesystem too. So it's the same deal as "add user_xattr 
mount option to the filesystem to make Beagle index faster". It's now: 
"if you use HSM storage add the atime mount option to make it slightly 
more intelligent. Expect huge IO slowdowns though."

The only remotely valid compatibility argument would be Mutt - but even 
that handles it just fine. (we broke way more software via noexec)

	Ingo
