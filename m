Return-Path: <linux-kernel-owner+w=401wt.eu-S1753866AbXC3PL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbXC3PL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 11:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753508AbXC3PL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 11:11:56 -0400
Received: from web26701.mail.ukl.yahoo.com ([217.146.176.64]:38282 "HELO
	web26701.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753867AbXC3PLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 11:11:55 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Mar 2007 11:11:55 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.gr;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=Lc6bWryU2SB0ZiBOa/GZ4GbBySrNDMLTfAvGchOiyxCPesn/Fta03yq4U87Oj88BwF9rp2C/Bt7TJyjqVY4w2GFO+cDSQeyTzjSAkEYtmm5aaubZUR2WtjmxXT1/gCnek2U00MTxLExwJhLkGalUMkElko3qYwa4o+qFxGn6i64=;
X-YMail-OSG: 4RyLqkcVM1knN2ZSPDl.pJjekHVAW7AoseQhsdVz0EB2WSJEBE0GfjjRWh2V4.w3uJj4I11dooZkaCtx_NGoQdk-
X-Mailer: YahooMailRC/476 YahooMailWebService/0.7.41.8
Date: Fri, 30 Mar 2007 15:05:13 +0000 (GMT)
From: Xenofon Antidides <xantidides@yahoo.gr>
Subject: Re: [test] hackbench.c interactivity results: vanilla versus SD/RSDL
To: Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>
Cc: linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
Message-ID: <325618.89505.qm@web26701.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----
From: Ingo Molnar <mingo@elte.hu>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux list <linux-kernel@vger.kernel.org>; Andrew Morton <akpm@linux-foundation.org>; Mike Galbraith <efault@gmx.de>
Sent: Thursday, March 29, 2007 9:22:49 PM
Subject: [test] hackbench.c interactivity results: vanilla versus SD/RSDL


* Ingo Molnar <mingo@elte.hu> wrote:

> * Con Kolivas <kernel@kolivas.org> wrote:
> 
> > I'm cautiously optimistic that we're at the thin edge of the bugfix 
> > wedge now.
[...]

> and the numbers he posted:
> 
>  http://marc.info/?l=linux-kernel&m=117448900626028&w=2

We been staring at these numbers for while now and we come to the conclusion they wrong.

The test is f is 3 tasks, two on different and one on same cpu as sh here:
virgin 2.6.21-rc3-rsdl-smp
top - 13:52:50 up 7 min, 12 users,  load average: 3.45, 2.89, 1.51

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
 6560 root      31   0  2892 1236 1032 R   82  0.1   1:50.24 1 sh
 6558 root      28   0  1428  276  228 S   42  0.0   1:00.09 1 f
 6557 root      30   0  1424  280  228 R   35  0.0   1:00.25 0 f
 6559 root      39   0  1424  276  228 R   33  0.0   0:58.36 0 f

6560 sh is asking for 100% cpu on cpu number 1
6558 f is asking for 50% cpu on cpu number 1
6557 f is asking for 50% cpu on cpu number 0
6559 f is asking for 50% cpu on cpu number 0

So if 6560 and 6558 are asking for cpu from cpu number 1:
6560 wants 100% and 6558 wants 50%.
6560 should get 2/3 cpu 6558 should get 1/3 cpu

2.6.21-rc3-rsdl-smp gives 65% sh and 35% f

patched 2.6.21-rc3-rsdl-smp gives 60% sh and 40% f

2.6.20.3-smp gives 51% sh and 49% f

We think cpu correctness is 2.6.21-rc3-rsdl-smp
 in that test.

Xant





 
____________________________________________________________________________________
Food fight? Enjoy some healthy debate 
in the Yahoo! Answers Food & Drink Q&A.
http://answers.yahoo.com/dir/?link=list&sid=396545367
