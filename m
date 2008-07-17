Return-Path: <linux-kernel-owner+w=401wt.eu-S1760800AbYGQRm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760800AbYGQRm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 13:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756218AbYGQRmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 13:42:17 -0400
Received: from relay.2ka.mipt.ru ([194.85.80.65]:50961 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756077AbYGQRmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 13:42:16 -0400
Date: Thu, 17 Jul 2008 21:41:56 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Octavian Purdila <opurdila@ixiacom.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tcp: do not promote SPLICE_F_NONBLOCK to socket O_NONBLOCK
Message-ID: <20080717174150.GA24002@2ka.mipt.ru>
References: <200807171633.49791.opurdila@ixiacom.com> <20080717142132.GA11702@2ka.mipt.ru> <200807171747.27775.opurdila@ixiacom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807171747.27775.opurdila@ixiacom.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 05:47:27PM +0300, Octavian Purdila (opurdila@ixiacom.com) wrote:
> > Existing behaviour was selected to be able to have a progress if socket
> > does not have enough data to fill the pipe. With your change if socket
> > is not opened with non-blocking mode reading will block not matter if
> > SPLICE_F_NONBLOCK is set or not. 
> 
> I am probably missing some usecases here, but usually if you want to use 
> non-blocking I/O you need to use special approach anyway (e.g. code the 
> poll/epoll/select bits) so then you could open the socket with O_NONBLOCK.

It depends. Splice clearly states that it tries to be nonblocking with
given flag being set, and its reading will be non-blocking indeed.

> > This is a quite serious break of the 
> > overall idea behind SPLICE_F_NONBLOCK.
> >
> 
> I don't know... the man page explicitly says that even when you use 
> SPLICE_F_NONBLOCK splice may block because of the underlying fd blocking.

Yes, but reading from the network will not.

> But more importantly, how can we solve the deadlock issue described in the 
> patch? Do we need all of the complications of async I/O for such a simple and 
> common usecase?

I'm not sure I understand how it can deadlock, please explain it in more
details.

-- 
	Evgeniy Polyakov
