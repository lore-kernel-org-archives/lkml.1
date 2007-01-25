Return-Path: <linux-kernel-owner+w=401wt.eu-S965404AbXAYUpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965404AbXAYUpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 15:45:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965572AbXAYUpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 15:45:47 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:21607 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965404AbXAYUpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 15:45:46 -0500
Message-ID: <45B916F2.4070906@tls.msk.ru>
Date: Thu, 25 Jan 2007 23:45:38 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.8 (X11/20061128)
MIME-Version: 1.0
To: Phillip Susi <psusi@cfl.rr.com>
CC: Denis Vlasenko <vda.linux@googlemail.com>,
       Linus Torvalds <torvalds@osdl.org>, Viktor <vvp01@inbox.ru>,
       Aubrey <aubreylee@gmail.com>, Hua Zhong <hzhong@gmail.com>,
       Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org,
       hch@infradead.org, kenneth.w.chen@in
Subject: Re: O_DIRECT question
References: <6d6a94c50701101857v2af1e097xde69e592135e54ae@mail.gmail.com> <200701251838.30796.vda.linux@googlemail.com> <45B904CF.1070102@cfl.rr.com> <200701252052.38119.vda.linux@googlemail.com> <45B90D19.60106@cfl.rr.com>
In-Reply-To: <45B90D19.60106@cfl.rr.com>
X-Enigmail-Version: 0.94.1.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Susi wrote:
> Denis Vlasenko wrote:
>> You mean "You can use aio_write" ?
> 
> Exactly.  You generally don't use O_DIRECT without aio.  Combining the
> two is what gives the big win.

Well, it's not only aio.  Multithreaded I/O also helps alot -- all this,
say, to utilize a raid array with many spindles.

But even single-threaded I/O but in large quantities benefits from O_DIRECT
significantly, and I pointed this out before.  It's like enabling a write
cache on disk AND doing intensive random writes - the cache - surprizingly -
slows whole thing down by 5..10%.

/mjt
