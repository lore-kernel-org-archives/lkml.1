Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbZIRVjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbZIRVjM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 17:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbZIRVjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 17:39:08 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:53238 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199AbZIRVjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 17:39:07 -0400
Subject: Re: circular locking dependency detected panic in filldir when
 CONFIG_PROVE_LOCKING=y
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Joe Korty <joe.korty@ccur.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Steve French <sfrench@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20090918211550.GA8258@tsunami.ccur.com>
References: <20090918211550.GA8258@tsunami.ccur.com>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 17:39:01 -0400
Message-Id: <1253309941.3183.104.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 7 msgs/h 2 sum rcpts/h 9 sum msgs/h 3 total rcpts 1495 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 94A156ED91180DC47A156C8A47EEE71DB26A0F90
X-UiO-SPAM-Test: remote_host: 198.95.226.230 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 2 total 30 max/h 3 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-18 at 17:15 -0400, Joe Korty wrote:
> I experienced a might_fault panic from NFS's use of filldir
> in a 2.6.31 kernel compiled with CONFIG_PROVE_LOCKING=y.
> 
> Looking at filldir, I see it is accessing user space with
> __put_dir's (which are inatomic) and with one copy_to_user
> (which is not inatomic).  It is the single copy_to_user
> which is causing the might_fault panic.
> 
> It doesn't make any sense to be mixing use of inatomic
> and non-inatomic services in filldir.  Either all should be
> the inatomic version, or none should be.
> 
> The might_fault condition being reported by the panic looks
> real to me, so I suspect the wrong answer is converting
> everything to the inatomic version, since that just
> suppresses the circular dependency check while leaving
> the circular dependency in place.

Yes. This is known... Please see 
   http://thread.gmane.org/gmane.linux.nfs/28578
and
   http://thread.gmane.org/gmane.linux.nfs/27406

I'm still hoping the VM folks can see fit to merge Peter's fix at some
point...

Cheers
  Trond

