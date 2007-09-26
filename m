Return-Path: <linux-kernel-owner+w=401wt.eu-S1757667AbXIZKUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667AbXIZKUo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 06:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbXIZKUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 06:20:37 -0400
Received: from mail.gmx.net ([213.165.64.20]:44274 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754349AbXIZKUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 06:20:36 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+f3CsheYqfNIKrfapXTWpgtZrXKjyPoOaUgthIdw
	28ve1wDFMA/IdC
Subject: Re: Network slowdown due to CFS
From: Mike Galbraith <efault@gmx.de>
To: Martin Michlmayr <tbm@cyrius.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070926085202.GE3337@deprecation.cyrius.com>
References: <20070926085202.GE3337@deprecation.cyrius.com>
Content-Type: text/plain
Date: Wed, 26 Sep 2007 12:20:32 +0200
Message-Id: <1190802032.7318.1.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-26 at 10:52 +0200, Martin Michlmayr wrote:
> I noticed that my network performance has gone down from 2.6.22
> >from   [  3]  0.0-10.0 sec    113 MBytes  95.0 Mbits/sec
> to     [  3]  0.0-10.0 sec   75.7 MBytes  63.3 Mbits/sec
> with 2.6.23-rc1 (and 2.6.23-rc8), as measured with iperf.

FWIW, on my box blasting localhost, I see the opposite, repeatably.

root@Homer: iperf -v
iperf version 2.0.2 (03 May 2005) pthreads

2.6.22.1-smp
for i in `seq 1 3`; do iperf -c localhost; done >> /xx

------------------------------------------------------------
Client connecting to localhost, TCP port 5001
TCP window size: 49.2 KByte (default)
------------------------------------------------------------
[  3] local 127.0.0.1 port 21383 connected with 127.0.0.1 port 5001
[  3]  0.0-10.1 sec    518 MBytes    432 Mbits/sec
------------------------------------------------------------
Client connecting to localhost, TCP port 5001
TCP window size: 49.2 KByte (default)
------------------------------------------------------------
[  3] local 127.0.0.1 port 21384 connected with 127.0.0.1 port 5001
[  3]  0.0-10.0 sec    325 MBytes    273 Mbits/sec
------------------------------------------------------------
Client connecting to localhost, TCP port 5001
TCP window size: 49.2 KByte (default)
------------------------------------------------------------
[  3] local 127.0.0.1 port 21385 connected with 127.0.0.1 port 5001
[  3]  0.0-10.0 sec    434 MBytes    363 Mbits/sec

2.6.23-rc8-smp-d
for i in `seq 1 3`; do iperf -c localhost; done >> /xx

------------------------------------------------------------
Client connecting to localhost, TCP port 5001
TCP window size: 49.2 KByte (default)
------------------------------------------------------------
[  3] local 127.0.0.1 port 11650 connected with 127.0.0.1 port 5001
[  3]  0.0-10.0 sec  2.01 GBytes  1.72 Gbits/sec
------------------------------------------------------------
Client connecting to localhost, TCP port 5001
TCP window size: 49.2 KByte (default)
------------------------------------------------------------
[  3] local 127.0.0.1 port 11651 connected with 127.0.0.1 port 5001
[  3]  0.0-10.0 sec  2.02 GBytes  1.74 Gbits/sec
------------------------------------------------------------
Client connecting to localhost, TCP port 5001
TCP window size: 49.2 KByte (default)
------------------------------------------------------------
[  3] local 127.0.0.1 port 11652 connected with 127.0.0.1 port 5001
[  3]  0.0-10.0 sec  2.10 GBytes  1.81 Gbits/sec


