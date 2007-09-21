Return-Path: <linux-kernel-owner+w=401wt.eu-S1759950AbXIUOdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759950AbXIUOdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 10:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757850AbXIUOdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 10:33:05 -0400
Received: from pat.uio.no ([129.240.10.15]:56152 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbXIUOdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 10:33:03 -0400
Subject: Re: [patch 3/5] VFS: pass open file to ->xattr()
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <E1IYiN2-0001eq-00@dorka.pomaz.szeredi.hu>
References: <20070921122343.307289079@szeredi.hu>
	 <20070921123333.247493758@szeredi.hu> <20070921124323.GA8088@infradead.org>
	 <E1IYi74-0001dX-00@dorka.pomaz.szeredi.hu>
	 <20070921130642.GA9431@infradead.org>
	 <E1IYiN2-0001eq-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain
Date: Fri, 21 Sep 2007 10:32:31 -0400
Message-Id: <1190385151.6680.35.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.085)
X-UiO-Scanned: 4A2C0BABC2941E4F47D43FA00835D077E487802A
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 680 total 4034861 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-21 at 15:16 +0200, Miklos Szeredi wrote:

> > ftruncate is a special case due to O_TRUNC.
> 
> No, it's special, because it does not do permission checking, while
> truncate() does.

So why not just add file->f_op->ftruncate() and file->f_op->fstat()?
Most filesystems can trivially redirect these to do_truncate() and their
existing getattr() method. Those, like FUSE, that care can use the hook.
In fact, I think that NFSv4 could also benefit from an ftruncate():
currently we have to hunt around for an open file context for that
particular case.

Trond

