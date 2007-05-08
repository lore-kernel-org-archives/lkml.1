Return-Path: <linux-kernel-owner+w=401wt.eu-S967634AbXEHCtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967634AbXEHCtM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 22:49:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966946AbXEHCtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 22:49:08 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:17642 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966910AbXEHCtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 22:49:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UFCWaeeE41B3H7Hyd37mtGFgLXwckSrkcULyXZiIDmNr28bWKY3aSDyQOlWJcn3IPTf0foXG+usuRv6frRS7ttC5LP3MwV2d+50kM6O0BJXjdynsUPcDaz8ypnrWnIpvDRDVN4MHPOIKsNLDwxxXdOvQsOlhdRyG8RvMQDEzCZ0=
Message-ID: <a36005b50705071949r4f45194bhc0c0416db28d1560@mail.gmail.com>
Date: Mon, 7 May 2007 19:49:04 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: [PATCH] rfc: threaded epoll_wait thundering herd
Cc: "Davi Arnaut" <davi@haxent.com.br>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0705071525200.29173@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070504225730.490334000@haxent.com.br>
	 <463BC3CA.6050109@haxent.com.br>
	 <Pine.LNX.4.64.0705051155210.19104@alien.or.mcafeemobile.com>
	 <463CFA37.3020809@haxent.com.br>
	 <a36005b50705071400p5302da05n7d27ec1995b9d4dc@mail.gmail.com>
	 <463F9B68.305@haxent.com.br>
	 <a36005b50705071519k40449ed2p7b9ece22cc19219a@mail.gmail.com>
	 <Pine.LNX.4.64.0705071525200.29173@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/7/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> read(2) is a cancellation point too. So if the fine userspace code issues
> a random pthread_cancel() to a thread handling that, data is lost together
> with the session that thread was handling.

This is absolutely not comparable.  When read/write is canceled no
data is lost.  Some other thread might have to pick up the slack but
that's it.

With your poll extensions where one thread gets notified and then the
kernel forgets about the event information.  Now this information is
only available in the thread itself.  How can a cancellation handler
communication this to all the other threads waiting in poll()?  Every
event which is reported and forgotten must be communication.  To make
things more fun, the various waiters can be in different processes.

We went over this for kevent discussions.  I really am not willing to
do it all again especially since there is no hope to achieve a
satisfying result with poll.  So, don't count my silence as agreement,
it isn't.
