Return-Path: <linux-kernel-owner+w=401wt.eu-S1763796AbXEUKVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763796AbXEUKVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764122AbXEUKPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:15:33 -0400
Received: from mailbigip.dreamhost.com ([208.97.132.5]:48347 "EHLO
	spaceymail-a4.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1764096AbXEUKPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:15:30 -0400
From: Anant Nitya <kernel@prachanda.info>
Organization: Prachanda Hub
To: linux-kernel@vger.kernel.org
Subject: Re: bad networking related lag in v2.6.22-rc2
Date: Mon, 21 May 2007 15:44:54 +0530
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "David S. Miller" <davem@davemloft.net>
References: <20070517174533.GA538@elte.hu> <20070521080351.GA13375@elte.hu> <20070521081201.GB13858@elte.hu>
In-Reply-To: <20070521081201.GB13858@elte.hu>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_hEXUGZq2hZizpvb"
Message-Id: <200705211544.58018.kernel@prachanda.hub>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_hEXUGZq2hZizpvb
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 21 May 2007 13:42:01 Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> > > ouch! a nearly 1 second delay got observed by the scheduler - something
> > > is really killing your system!
> >
> > ah, you got the latency tracer from Thomas, as part of the -hrt patchset
> > - that makes it quite a bit easier to debug. [...]
>
> and ... you already did a trace for Thomas, for the softirq problem:
>
>    http://cybertek.info/taitai/trace.txt.bz2
>
> this trace shows really bad networking related kernel activities!
>
> gkrellm-5977 does this at timestamp 0:
>
>  gkrellm-5977  0..s.    0us : cond_resched_softirq (established_get_next)
>
> 2 milliseconds later it's still in established_get_next() (!):
>
>  gkrellm-5977  0..s. 2001us : cond_resched_softirq (established_get_next)
>
> and the whole thing takes ... 455 msecs:
>
>  gkrellm-5977  0..s. 455443us+: cond_resched_softirq (established_get_next)
>
> i think this suggests that you have tons of open sockets. What does
> "netstat -ts" say on your box?
On 2.6.21.1 doing normal work while seeding few torrents produces this 
with "netstat -ts". I will send you same information for 2.6.22-rc2 after a 
reboot.

Regards
Ananitya

>
> 	Ingo



-- 
Out of many thousands, one may endeavor for perfection, and of
those who have achieved perfection, hardly one knows Me in truth.
				-- Gita Sutra Of Mysticism

--Boundary-00=_hEXUGZq2hZizpvb
Content-Type: text/plain;
  charset="iso-8859-1";
  name="netstat-ts-normal-workload.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="netstat-ts-normal-workload.txt"

Tcp:
    1233 active connections openings
    845 passive connection openings
    9 failed connection attempts
    164 connection resets received
    5 connections established
    44995 segments received
    43171 segments send out
    183 segments retransmited
    0 bad segments received.
    192 resets sent
UdpLite:
TcpExt:
    696 TCP sockets finished time wait in fast timer
    3273 delayed acks sent
    12 delayed acks further delayed because of locked socket
    Quick ack mode was activated 38 times
    4867 packets directly queued to recvmsg prequeue.
    31660 packets directly received from backlog
    6759887 packets directly received from prequeue
    12038 packets header predicted
    3228 packets header predicted and directly queued to user
    4795 acknowledgments not containing data received
    12680 predicted acknowledgments
    15 times recovered from packet loss due to SACK data
    4 congestion windows recovered after partial ack
    12 TCP data loss events
    5 timeouts after SACK recovery
    8 timeouts in loss state
    20 fast retransmits
    25 retransmits in slow start
    65 other TCP timeouts
    5 sack retransmits failed
    3 times receiver scheduled too late for direct processing
    16 DSACKs sent for old packets
    152 connections reset due to unexpected data
    5 connections reset due to early user close

--Boundary-00=_hEXUGZq2hZizpvb--
