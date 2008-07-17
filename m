Return-Path: <linux-kernel-owner+w=401wt.eu-S1758153AbYGQOtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153AbYGQOtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 10:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754289AbYGQOtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 10:49:36 -0400
Received: from ixia01.ro.gtsce.net ([212.146.94.66]:1165 "EHLO
	ixro-ex1.ixiacom.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752861AbYGQOtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 10:49:35 -0400
From: Octavian Purdila <opurdila@ixiacom.com>
Organization: IXIA
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH] tcp: do not promote SPLICE_F_NONBLOCK to socket O_NONBLOCK
Date: Thu, 17 Jul 2008 17:47:27 +0300
User-Agent: KMail/1.9.9
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200807171633.49791.opurdila@ixiacom.com> <20080717142132.GA11702@2ka.mipt.ru>
In-Reply-To: <20080717142132.GA11702@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807171747.27775.opurdila@ixiacom.com>
X-OriginalArrivalTime: 17 Jul 2008 14:51:29.0225 (UTC) FILETIME=[98514390:01C8E81C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 July 2008, Evgeniy Polyakov wrote:

>
> Existing behaviour was selected to be able to have a progress if socket
> does not have enough data to fill the pipe. With your change if socket
> is not opened with non-blocking mode reading will block not matter if
> SPLICE_F_NONBLOCK is set or not. 

I am probably missing some usecases here, but usually if you want to use 
non-blocking I/O you need to use special approach anyway (e.g. code the 
poll/epoll/select bits) so then you could open the socket with O_NONBLOCK.

> This is a quite serious break of the 
> overall idea behind SPLICE_F_NONBLOCK.
>

I don't know... the man page explicitly says that even when you use 
SPLICE_F_NONBLOCK splice may block because of the underlying fd blocking.

But more importantly, how can we solve the deadlock issue described in the 
patch? Do we need all of the complications of async I/O for such a simple and 
common usecase?

Maybe we can solve both usecases by using two flags: one for splice and 
another one for the underlying file descriptor?

Thanks,
tavi
