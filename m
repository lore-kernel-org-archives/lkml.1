Return-Path: <linux-kernel-owner+w=401wt.eu-S1756515AbYEKMgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515AbYEKMgX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 08:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754970AbYEKMgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 08:36:16 -0400
Received: from jade.aracnet.com ([216.99.193.136]:46135 "EHLO jade.aracnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754809AbYEKMgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 08:36:15 -0400
Message-ID: <4826E1CB.6090500@BitWagon.com>
Date: Sun, 11 May 2008 05:08:43 -0700
From: John Reiser <jreiser@BitWagon.com>
Organization: -
User-Agent: Mozilla Thunderbird 1.0.8-1.1.fc4 (X11/20060501)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Bart Van Assche <bart.vanassche@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Christoph Lameter <clameter@sgi.com>,
       Daniel Walker <dwalker@mvista.com>, Andi Kleen <andi@firstfloor.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Josh Aune <luken@omner.org>,
       Pekka Paalanen <pq@iki.fi>
Subject: Re: [ANNOUNCE] kmemcheck v7
References: <47F630AE.7050801@gmail.com>	 <e2e108260805100207l13b67706h871f5f1c550e58b3@mail.gmail.com>	 <482565A5.8010503@cs.helsinki.fi>	 <e2e108260805100404h63f02194r62e53f79ae2a403f@mail.gmail.com> <19f34abd0805100502k150e3636x33831230d688dd92@mail.gmail.com>
In-Reply-To: <19f34abd0805100502k150e3636x33831230d688dd92@mail.gmail.com>
X-Enigmail-Version: 0.92.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> How is the speed of Valgrind+UML, does anybody know?

The speed of Valgrind+UML is the same as the speed of valgrind
on any application.  On a 2GHz box it took about 2.5 minutes
to reach "login:" from a cold boot of UML (includes udev, etc.)
So if normal boot takes 15 seconds, then that's a factor of 10
slowdown: slow for interactivity, yet bearable for checking.
The memory-intensive portions (linear search, pointer chasing,
etc.) can be slower still, but loops that concentrate on
register arithmetic or conditional branching go faster.
There is almost no system wait time: normal device delays (disk,
network) get totally overlapped by CPU usage for grinding :-)

I'd like to have both kmemcheck and valgrind+UML, and use them
differently.  Run kmemcheck all the time on a box or two as
"background trolling" for infrequent cases.  Use valgrind+UML
for interactivity and programmable flexibility when hunting
specific bugs, or when hardware cannot be dedicated.

-- 
John Reiser, jreiser@BitWagon.com
