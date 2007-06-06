Return-Path: <linux-kernel-owner+w=401wt.eu-S1758902AbXFFIM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902AbXFFIM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 04:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753935AbXFFIMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 04:12:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55094
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752983AbXFFIMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 04:12:42 -0400
Date: Wed, 06 Jun 2007 01:12:58 -0700 (PDT)
Message-Id: <20070606.011258.71090697.davem@davemloft.net>
To: miklos@szeredi.hu
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix race in AF_UNIX
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1HvqZB-0003Vc-00@dorka.pomaz.szeredi.hu>
References: <E1Hvo2m-00038P-00@dorka.pomaz.szeredi.hu>
	<20070605.224128.104032917.davem@davemloft.net>
	<E1HvqZB-0003Vc-00@dorka.pomaz.szeredi.hu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 06 Jun 2007 10:08:29 +0200

> > > > Holding a global mutex over recvmsg() calls under AF_UNIX is pretty
> > > > much a non-starter, this will kill performance for multi-threaded
> > > > apps.
> > > 
> > > That's an rwsem held for read.  It's held for write in unix_gc() only
> > > for a short duration, and unix_gc() should only rarely be called.  So
> > > I don't think there's any performance problem here.
> > 
> > It pulls a non-local cacheline into the local thread, that's extremely
> > expensive on SMP.
> 
> OK, here's an updated patch, that uses ->readlock, and passes my
> testing.

Thanks a lot, I'll review this as soon as possible unless
someone else beats me to it :)
