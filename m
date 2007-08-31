Return-Path: <linux-kernel-owner+w=401wt.eu-S1757593AbXHaEbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593AbXHaEbf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 00:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251AbXHaEb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 00:31:27 -0400
Received: from pat.uio.no ([129.240.10.15]:43408 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbXHaEb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 00:31:26 -0400
Subject: RE: recent nfs change causes autofs regression
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Hua Zhong <hzhong@gmail.com>
Cc: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org
In-Reply-To: <001601c7eb5f$b6146980$223d3c80$@com>
References: <000701c7eb49$cff701c0$6fe50540$@com>
	 <1188513433.6626.24.camel@heimdal.trondhjem.org>
	 <001001c7eb57$afd2d320$0f787960$@com>
	 <1188516173.6626.46.camel@heimdal.trondhjem.org>
	 <001501c7eb5d$d295d870$77c18950$@com>
	 <1188517070.6626.54.camel@heimdal.trondhjem.org>
	 <001601c7eb5f$b6146980$223d3c80$@com>
Content-Type: text/plain
Date: Fri, 31 Aug 2007 00:31:22 -0400
Message-Id: <1188534682.6626.70.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.090)
X-UiO-Scanned: E9367BA4E446A70E4C36A58A8E1951E2406576D3
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 83 total 3574511 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-30 at 16:44 -0700, Hua Zhong wrote:
> > How is the NFS client to know that these directories are disjoint, or
> > that no-one will ever create a hard link from one directory to another?
> > To my knowledge, the only way to ensure this is to put them on
> > different disk partitions.
> > 
> > I don't know if all Unix systems have this issue, but I have been told
> > that Solaris at least has it.
> 
> Does Solaris enforces this "mount with same options" as default?

No. Solaris defaults to breaking cache consistency.

> > > "working" as in "I can mount the directory and do my work". And there
> > > has never been any problems as far as I know.
> > 
> > That is too narrow a definition: the minimum should be "everyone can
> > mount their directories and do their work". Your particular setup may
> > be safe, but that is why we have overrides: the default should be for the
> > kernel to be conservative, and to _tell_ users what it thinks is wrong.
> 
> Every engineer in our organization mounts it too. No problem until now.

I believe I've already explained why that isn't a sufficient metric.
What is your point?

> It's not very conservative to suddenly change default behavior and break
> autofs mounts. There is not even one kernel message that "_tells_ user why
> it thinks it's wrong". It just silently fails.

No it doesn't. It reports an error code to the caller. If autofs is
failing silently, then that is a bug in autofs: mount will report the
error to the user.

Trond

