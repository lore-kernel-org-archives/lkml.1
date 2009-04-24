Return-Path: <linux-kernel-owner+w=401wt.eu-S1760126AbZDXOOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760126AbZDXOOi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 10:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757530AbZDXOO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 10:14:29 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:46560 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756495AbZDXOO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 10:14:28 -0400
Subject: Re: NFS BUG_ON in nfs_do_writepage
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Rince <rincebrain@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-nfs@vger.kernel.org
In-Reply-To: <5da0588e0904240226j3454941y5f58c17a32a9a23d@mail.gmail.com>
References: <alpine.LFD.2.00.0904130145050.4396@centaur.acm.jhu.edu>
	 <20090412235010.c8e3475b.akpm@linux-foundation.org>
	 <1239650202.16771.15.camel@heimdal.trondhjem.org>
	 <5da0588e0904131506k5c58e8ddob9bf38f61da6302a@mail.gmail.com>
	 <5da0588e0904131644g131dc816r61884e83bc4cd006@mail.gmail.com>
	 <5da0588e0904240226j3454941y5f58c17a32a9a23d@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 24 Apr 2009 10:14:19 -0400
Message-Id: <1240582459.4946.31.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 10 msgs/h 2 sum rcpts/h 14 sum msgs/h 2 total rcpts 38 max rcpts/h 10 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=_BLID_, uiouri=_URIID_)
X-UiO-Scanned: A9308334A8FB6F8A3BFEAE5CDF4FC3F737008FF3
X-UiO-SPAM-Test: remote_host: 71.227.91.12 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 2 total 198 max/h 5 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-24 at 05:26 -0400, Rince wrote:
> Applied try 3 of Nick Piggin's patch to 2.6.30-rc3 (cleanly, no less!)
> 
> Doesn't appear to have helped at all - I received my favorite BUG ON
> write.c:252 just like always, within 24 hours of booting the kernel,
> even.
> 
> - Rich

Yes. I'm able to reproduce this bug now. I found that I can trigger it
fairly reliably by running iozone in something like the following
configuration: "iozone -t 32 -r 1k -s 256m -c -D -K -Z -i0 -i8"

I believe it boils down to the problems being discussed in the following
thread:
   http://thread.gmane.org/gmane.linux.nfs/26181

Cheers
  Trond

