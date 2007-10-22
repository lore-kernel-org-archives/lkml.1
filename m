Return-Path: <linux-kernel-owner+w=401wt.eu-S1753064AbXJVUtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbXJVUtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 16:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbXJVUtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 16:49:18 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:46982 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbXJVUtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 16:49:17 -0400
To: riel@redhat.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xemul@openvz.org
In-reply-to: <20071022145321.195d929b@bree.surriel.com> (message from Rik van
	Riel on Mon, 22 Oct 2007 14:53:21 -0400)
Subject: Re: futex strangeness in 2.6.23-mm1/UML
References: <E1Ik15P-0001wg-00@dorka.pomaz.szeredi.hu> <20071022145321.195d929b@bree.surriel.com>
Message-Id: <E1Ik4Ch-000273-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 22 Oct 2007 22:48:51 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > I'm getting a process stuck in pthread_rwlock_wrlock(), even though it
> > looks like the lock is not held by anybody.
> > 
> > I think the last -mm was OK.  Any ideas?
> > 
> > If not, I'll go searching for the offending patch.
> 
> I wonder if that's the same bug that's breaking autofs for me.

Probably.

> Oct 22 14:39:01 kenny automount[2299]: cache_readlock: mapent cache
> rwlock lock failed
> Oct 22 14:39:01 kenny automount[2299]: unexpected pthreads error: 11 at
> 65 in cache.c
> 
> I'm bisecting 2.6.23-mm1 today to find the problem patch, with
> some luck I'll have it this afternoon.
> 
> With the series applied up to whitespace-fixes-task-exit-handling.patch
> things work.
> 
> It breaks before kswapd-should-only-wait-on-io-if-there-is-io.patch
> 
> That leaves only about 60-80 patches to look at :)

OK, the first patch that breaks something for me is:

  pid-namespaces-move-alloc_pid-lower-in-copy_process.patch

Miklos
