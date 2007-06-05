Return-Path: <linux-kernel-owner+w=401wt.eu-S1762947AbXFEEfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762947AbXFEEfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 00:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754612AbXFEEfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 00:35:30 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:24111 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbXFEEf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 00:35:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=g1/lA8v4AQe2nU2psi1aWFhA1UCWb0RrIiqSpN9OsUaboNMEbcmAsUZWsPiO3////qJWhUNUdSGMwzJ0PkklPZkfM4qbcpHSRTtrzVeFOBjoSf8JTjxpWKK9maL0CdSbmlijtaneiCA1wYxCWRdYGkFXOXv7AlNUOz8Q7macp7k=
Message-ID: <516d7fa80706042135p3d0b87fawcc94971af1f529c3@mail.gmail.com>
Date: Tue, 5 Jun 2007 00:35:28 -0400
From: "Mike Richards" <mrmikerich@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: To swap or not to swap?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here's something that's been bugging me for a while now...

I have several Linux servers that have been given enough RAM that they
rarely ever use any swap space. For example, here's the typical output
of uptime and free:

root@veronica$ uptime; free
 03:55:33 up 225 days, 17:34,  0 users,  load average: 0.09, 0.13, 0.19
             total       used       free     shared    buffers     cached
Mem:       2076136    1931288     144848          0     150220     964108
-/+ buffers/cache:     816960    1259176
Swap:       524280        156     524124

As you can see, it's been up for the better part of a year and is only
using 156k of swap. The swappiness is set to the default of 60, so
there's no reason why the server *shouldn't* be using swap -- it just
never does.

On some of my older servers with a little less RAM and the 2.4 kernel
I'll occasionally see the swap go up into the double digits, but even
this is relatively infrequent. On all the machines with a 2.6 kernel
and 2GB+ RAM, I've almost never seen more than 1-2MB swap used.

However, there is one exception: When a runaway process eats up all
the RAM and causes a server meltdown.

Fortunately runaway processes don't happen often, but when they do, a
large swap space seems to have been more of a hindrance than a help.
With out-of-control swapping going on, the other server processes
ground to a halt, and it is all but impossible to execute any commands
in an attempt to find and kill the runaway process. In fact, what has
ended up happening to me in these situations is that eventually --
after perhaps 10-20 minutes -- the swap space gets maxed out and
processes start getting killed automatically and/or the server
reboots.

The trouble is... these servers need to be available at all times, and
those 10-20 minutes where the server is completely unresponsive is
pretty bad for business.

So, what I'm getting at is this: If the only time swap is ever
actually used on these servers in quantities above a few megs is when
they're in the process of melting down, wouldn't it seem wiser to use
little or no swap and let them fail fast, rather than having a 1/4
hour of downtime?

In my research on this matter I've come across various comments by
people saying that getting rid of swap entirely will hurt performance
somehow, but on these servers I'm  seeing very little swap used in the
first place, so I'm not seeing how that's really possible. But to
avoid that being an issue, let's suppose I give each server 32MB of
swap to cover the occasional usage. Is there any reason *not* to go
the route of minimizing swap in order to also minimize downtime?

The consensus these days seems to be that since hard drives are so big
now, go with a gig or more of swap even if you have plenty of RAM.
However, the way I'm seeing it is this: What's the point of having a
gig of swap if it only gets used during the worst possible time?
