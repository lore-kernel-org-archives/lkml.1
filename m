Return-Path: <linux-kernel-owner+w=401wt.eu-S1759705AbXEMThg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759705AbXEMThg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 15:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758070AbXEMTh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 15:37:28 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4354 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627AbXEMTh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 15:37:28 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 13 May 2007 12:37:26 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/2] fix epoll single pass code and add wait-exclusive
 flag ...
In-Reply-To: <20070513122950.e30f2c80.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705131235490.3212@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.27693.1178937031.1>
 <20070513122950.e30f2c80.akpm@linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 May 2007, Andrew Morton wrote:

> On Fri, 11 May 2007 19:30:31 -0700 Davide Libenzi <davidel@xmailserver.org> wrote:
> 
> > Fixes the epoll single pass code. During the unlocked event delivery
> > (to userspace) code, the poll callback can re-issue new events, and
> > we must receive them correctly. Since we loop in a lockless fashion,
> > we want to be O(nready), and we don't want to flash on/off the spinlock
> > for every event, we have the poll callback to use a secondary list to
> > queue events while we're inside the event delivery loop.
> > The rw_semaphore has been turned into a mutex.
> > This patch also adds the wait-exclusive flag, as suggested by Davi Arnaut.
> > 
> > ...
> > @@ -534,6 +547,8 @@
> >  	}
> >  
> >  	mutex_unlock(&epmutex);
> > +
> > +	mutex_destroy(&ep->mtx);
> >  }
> 
> It's a little alarming to see a dereference of `ep' right at the end of a
> function called ep_free(ep).
> 
> Code is OK, but perhaps the kfree(ep) should be moved into ep_free()?

Ok, will do.



- Davide


