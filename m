Return-Path: <linux-kernel-owner+w=401wt.eu-S935481AbXGLC33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935481AbXGLC33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 22:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756665AbXGLC3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 22:29:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47595
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760777AbXGLC3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 22:29:17 -0400
Date: Wed, 11 Jul 2007 19:29:40 -0700 (PDT)
Message-Id: <20070711.192940.21926073.davem@davemloft.net>
To: miklos@szeredi.hu
Cc: netdev@vger.kernel.org, ebiederm@xmission.com, akpm@linux-foundation.org,
       viro@ftp.linux.org.uk, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] rewrite AF_UNIX garbage collector, fixes race
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1I61UT-0006Gk-00@dorka.pomaz.szeredi.hu>
References: <E1I61UT-0006Gk-00@dorka.pomaz.szeredi.hu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 04 Jul 2007 11:49:41 +0200

> Throw out the old mark & sweep garbage collector and put in a
> refcounting cycle detecting one.
> 
> The old one had a race with recvmsg, that resulted in false positives
> and hence data loss.  The old algorithm operated on all unix sockets
> in the system, so any additional locking would have meant performance
> problems for all users of these.
> 
> The new algorithm instead only operates on "in flight" sockets, which
> are very rare, and the additional locking for these doesn't negatively
> impact the vast majority of users.
> 
> In fact it's probable, that there weren't *any* heavy senders of
> sockets over sockets, otherwise the above race would have been
> discovered long ago.
> 
> The patch works OK with the app that exposed the race with the old
> code.  The garbage collection has also been verified to work in a few
> simple cases.
> 
> See comments inside patch for the description of the algorithm.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

This looks good, patch applied and I'll get this into the
2.6.23 merge window.

Once this sits around for a while and we feel super-confident
with it we can consider a backport into -stable.

