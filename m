Return-Path: <linux-kernel-owner+w=401wt.eu-S1755065AbYFNTOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065AbYFNTOX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 15:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754024AbYFNTOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 15:14:14 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:50257 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753927AbYFNTON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 15:14:13 -0400
X-Greylist: delayed 1710 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Jun 2008 15:14:13 EDT
Subject: Re: [2/3] POHMELFS: Documentation.
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Jamie Lokier <jamie@shareable.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20080614065616.GA32585@2ka.mipt.ru>
References: <20080613163700.GA25860@2ka.mipt.ru>
	 <20080613164110.GB26166@2ka.mipt.ru> <20080614021547.GC32232@shareable.org>
	 <20080614065616.GA32585@2ka.mipt.ru>
Content-Type: text/plain
Date: Sat, 14 Jun 2008 14:45:36 -0400
Message-Id: <1213469136.7149.36.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 2A4484828CD3DB50C590747EB1ADF77619AFF260
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 192 total 8929668 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-06-14 at 10:56 +0400, Evgeniy Polyakov wrote:
> > That sounds great, but what do you mean by 'novel'?  Don't other
> > modern network filesystems use asynchronous requests and replies in
> > some form?  It seems like the obvious thing.
> 
> Maybe it was a bit naive though :)
> But I checked lots of implementation, all of them use send()/recv()
> approach. NFSv4 uses a bit different, but it is a cryptic, and at least
> from its names it is not clear:
> like nfs_pagein_multi() -> nfs_pageio_complete() -> add_stats. Presumably
> we add stats when we have data handy...

You're confusing write gathering with asynchronous I/O...

NFS attempts to send multiple contiguous pages in one I/O request, and
so it has a mechanism for collecting them and dispatching the I/O as
soon as we have enough pages for an RPC call.

The actual RPC call is then handled by the sunrpc layer and is done
fully asynchronously using non-blocking I/O.

  Trond

