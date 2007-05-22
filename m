Return-Path: <linux-kernel-owner+w=401wt.eu-S1762953AbXEVMsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762953AbXEVMsK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 08:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756617AbXEVMr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 08:47:57 -0400
Received: from mailbigip.dreamhost.com ([208.97.132.5]:52889 "EHLO
	spaceymail-a3.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755931AbXEVMr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 08:47:56 -0400
From: Anant Nitya <kernel@prachanda.info>
Organization: Prachanda Hub
To: linux-kernel@vger.kernel.org
Subject: Re: bad networking related lag in v2.6.22-rc2
Date: Tue, 22 May 2007 18:17:33 +0530
User-Agent: KMail/1.9.6
Cc: Patrick McHardy <kaber@trash.net>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "David S. Miller" <davem@davemloft.net>
References: <20070517174533.GA538@elte.hu> <200705221147.56571.kernel@prachanda.hub> <4652B53B.8080500@trash.net>
In-Reply-To: <4652B53B.8080500@trash.net>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_mZuUGiyErcQIhza"
Message-Id: <200705221817.34854.kernel@prachanda.hub>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_mZuUGiyErcQIhza
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday 22 May 2007 14:47:47 Patrick McHardy wrote:
> Anant Nitya wrote:
> >>Patrick McHardy wrote:
> >>
> >>I think I already found the bug, please try if this patch helps.
> >
> > Sorry, but this patch is not helping here. I recompiled the kernel with
> > this patch but same load pattern still make system to crawl.
> >
> > Here is the link for script I use to shape traffic.
> >
> > http://cybertek.info/taitai/adslbwopt.sh
>
> Thanks. Please also send the output of "tc -s -d qdisc show dev
> ppp0" and "tc -d -s class show dev ppp0" at the time the problem
> occurs.

Here it goes...


Regards
Ananitya


-- 
Out of many thousands, one may endeavor for perfection, and of
those who have achieved perfection, hardly one knows Me in truth.
				-- Gita Sutra Of Mysticism

--Boundary-00=_mZuUGiyErcQIhza
Content-Type: text/plain;
  charset="iso-8859-15";
  name="tc_qdisc_stats_while_crawl"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="tc_qdisc_stats_while_crawl"

qdisc htb 1: r2q 1 default 50 direct_packets_stat 0 ver 3.17
 Sent 837184 bytes 3603 pkt (dropped 0, overlimits 60528154 requeues 0) 
 rate 0bit 0pps backlog 0b 0p requeues 0 
qdisc sfq 4210: parent 1:10 limit 50p quantum 1492b flows 50/1024 perturb 10sec 
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0) 
 rate 0bit 0pps backlog 0b 0p requeues 0 
qdisc sfq 4220: parent 1:20 limit 50p quantum 1492b flows 50/1024 perturb 10sec 
 Sent 102922 bytes 2364 pkt (dropped 0, overlimits 0 requeues 0) 
 rate 0bit 0pps backlog 0b 0p requeues 0 
qdisc sfq 4230: parent 1:30 limit 64p quantum 1492b flows 64/1024 perturb 10sec 
 Sent 12690 bytes 167 pkt (dropped 0, overlimits 0 requeues 0) 
 rate 0bit 0pps backlog 0b 0p requeues 0 
qdisc sfq 4240: parent 1:40 limit 128p quantum 1492b flows 128/1024 perturb 10sec 
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0) 
 rate 0bit 0pps backlog 0b 0p requeues 0 
qdisc sfq 4250: parent 1:50 limit 64p quantum 1492b flows 64/1024 perturb 10sec 
 Sent 714095 bytes 944 pkt (dropped 0, overlimits 0 requeues 0) 
 rate 0bit 0pps backlog 0b 0p requeues 0 
qdisc sfq 666: parent 1:666 limit 128p quantum 1492b flows 128/1024 perturb 10sec 
 Sent 7477 bytes 128 pkt (dropped 0, overlimits 0 requeues 0) 
 rate 0bit 0pps backlog 0b 0p requeues 0 

--Boundary-00=_mZuUGiyErcQIhza
Content-Type: text/x-java;
  charset="iso-8859-15";
  name="tc_class_stats_while_crawl"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="tc_class_stats_while_crawl"

class htb 1:10 parent 1:1 leaf 4210: prio 0 quantum 1000 rate 7000bit ceil 57000bit burst 1599b/8 mpu 0b overhead 0b cburst 1599b/8 mpu 0b overhead 0b level 0 
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0) 
 rate 0bit 0pps backlog 0b 0p requeues 0 
 lended: 0 borrowed: 0 giants: 0
 tokens: 1785713 ctokens: 219297

class htb 1:1 root rate 64000bit ceil 64000bit burst 1599b/8 mpu 0b overhead 0b cburst 1599b/8 mpu 0b overhead 0b level 7 
 Sent 1533899 bytes 5926 pkt (dropped 0, overlimits 0 requeues 0) 
 rate 74640bit 31pps backlog 0b 0p requeues 0 
 lended: 1113 borrowed: 0 giants: 0
 tokens: -255221 ctokens: -255221

class htb 1:20 parent 1:1 leaf 4220: prio 1 quantum 3125 rate 25000bit ceil 57000bit burst 1599b/8 mpu 0b overhead 0b cburst 1599b/8 mpu 0b overhead 0b level 0 
 Sent 171357 bytes 3931 pkt (dropped 0, overlimits 0 requeues 0) 
 rate 7376bit 21pps backlog 0b 0p requeues 0 
 lended: 3931 borrowed: 0 giants: 0
 tokens: 341211 ctokens: 150341

class htb 1:30 parent 1:1 leaf 4230: prio 4 quantum 1250 rate 10000bit ceil 51000bit burst 1600b/8 mpu 0b overhead 0b cburst 1599b/8 mpu 0b overhead 0b level 0 
 Sent 15578 bytes 205 pkt (dropped 0, overlimits 0 requeues 0) 
 rate 336bit 0pps backlog 0b 0p requeues 0 
 lended: 205 borrowed: 0 giants: 0
 tokens: 1137614 ctokens: 223153

class htb 1:40 parent 1:1 leaf 4240: prio 4 quantum 1000 rate 8000bit ceil 51000bit burst 1600b/8 mpu 0b overhead 0b cburst 1599b/8 mpu 0b overhead 0b level 0 
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0) 
 rate 0bit 0pps backlog 0b 0p requeues 0 
 lended: 0 borrowed: 0 giants: 0
 tokens: 1562500 ctokens: 245097

class htb 1:50 parent 1:1 leaf 4250: prio 4 quantum 1000 rate 7000bit ceil 60000bit burst 1599b/8 mpu 0b overhead 0b cburst 1599b/8 mpu 0b overhead 0b level 0 
 Sent 1329025 bytes 1455 pkt (dropped 0, overlimits 0 requeues 0) 
 rate 65384bit 6pps backlog 0b 0p requeues 0 
 lended: 342 borrowed: 1113 giants: 0
 tokens: -2865704 ctokens: 1887

class htb 1:666 parent 1:1 leaf 666: prio 7 quantum 1492 rate 3000bit ceil 48000bit burst 1599b/8 mpu 0b overhead 0b cburst 1599b/8 mpu 0b overhead 0b level 0 
 Sent 17939 bytes 335 pkt (dropped 0, overlimits 0 requeues 0) 
 rate 1104bit 2pps backlog 0b 0p requeues 0 
 lended: 335 borrowed: 0 giants: 0
 tokens: 3937910 ctokens: 246505


--Boundary-00=_mZuUGiyErcQIhza--
