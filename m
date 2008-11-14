Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749AbYKNVIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbYKNVIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 16:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbYKNVIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 16:08:10 -0500
Received: from 1wt.eu ([62.212.114.60]:1199 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbYKNVIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 16:08:09 -0500
Date: Fri, 14 Nov 2008 22:07:59 +0100
From: Willy Tarreau <w@1wt.eu>
To: Olaf van der Spek <olafvdspek@gmail.com>
Cc: David Miller <davem@davemloft.net>, jrm8005@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: Unix sockets via TCP on localhost: is TCP slower?
Message-ID: <20081114210759.GX24654@1wt.eu>
References: <b2cc26e40811121520k711fa702u85e53bbc18b021a0@mail.gmail.com> <3aaafc130811131619w3ba48a86u6c6e2af35f149bf1@mail.gmail.com> <b2cc26e40811140051n4e821fddsc5504eedcccc9cdc@mail.gmail.com> <20081114.005635.131100777.davem@davemloft.net> <b2cc26e40811140109jfc6b0f3tf33a92afbff33e46@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2cc26e40811140109jfc6b0f3tf33a92afbff33e46@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 10:09:25AM +0100, Olaf van der Spek wrote:
> On Fri, Nov 14, 2008 at 9:56 AM, David Miller <davem@davemloft.net> wrote:
> >> Why would you use windowing, ACKs, flow control and encapsulation on localhost?
> >
> > So that you could firewall, shape, redirect, and make other
> > modifications to the traffic, as well as see it in tcpdumps.  That's
> > the power of Linux, and yes people do this stuff and yes people do
> > want these features to work over loopback.
> >
> >> I expected the kernel to copy data directly from user-space of the
> >> sending process to a kernel buffer of the receiving process, much like
> >> UNIX sockets.
> >
> > Then all of the above features and debugging facilities go away.
> 
> So instead the recommendation is for all apps to support both TCP and
> Unix sockets?
> If you then use Unix sockets, you still lose all of those facilities
> and as a bonus, your apps are more complex.
> 
> I'd prefer a switch that could be enabled to use such a shortcut for TCP.
> Firewalls should still work mostly (on connect), redirect would still work.

I'm already wondering what problems you encounter with TCP performance
on the loopback. I'm used to stress-test network proxies on the loopback
for quick tests when I don't want to boot 3 machines, and seeing that it's
easy to connect/accept 100k sessions/s and forward about 20-30 Gbps between
two processes on consumer-grade machines, I'm really doubting that your
applications needs that much out of your database.

If you're really so sensible to local traffic tunning, you can already
set a very large MTU on your loopback, you can have very large windows
between your applications so that very few ACKs are sent, etc... And
BTW checksums are already not even computed. Loopback *is* fast, there's
no need to crapify the whole stack with your "switch" to gain 5% more out
of it.

Anyway, if you can come up with patches which proves all of us wrong
without weakening the code, I'm sure they could be accepted.

Willy

