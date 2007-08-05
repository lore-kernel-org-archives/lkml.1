Return-Path: <linux-kernel-owner+w=401wt.eu-S1761229AbXHEUJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761229AbXHEUJP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 16:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756081AbXHEUJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 16:09:01 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:45870 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756750AbXHEUJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 16:09:00 -0400
Message-ID: <46B62E52.6060600@interia.pl>
Date: Sun, 05 Aug 2007 22:08:50 +0200
From: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 2.0.0.5 (X11/20070720)
MIME-Version: 1.0
To: Dimitrios Apostolou <jimis@gmx.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: high system cpu load during intense disk i/o
References: <200708031903.10063.jimis@gmx.net> <200708051903.12414.jimis@gmx.net> <46B60FB7.8030301@interia.pl> <200708052142.14630.jimis@gmx.net>
In-Reply-To: <200708052142.14630.jimis@gmx.net>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-EMID: 4346cacc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hello and thanks for your reply. 
Hi, 
> The cron job that is running every 10 min on my system is mpop (a 
> fetchmail-like program) and another running every 5 min is mrtg. Both 
> normally finish within 1-2 seconds. 
> 
> The fact that these simple cron jobs don't finish ever is certainly because of 
> the high system CPU load. If you see the two_discs_bad.txt which I attached 
> on my original message, you'll see that *vmlinux*, and specifically the 
> *scheduler*, take up most time. 
> 
> And the fact that this happens only when running two i/o processes but when 
> running only one everything is absolutely snappy (not at all slow, see 
> one_disc.txt), makes me sure that this is a kernel bug. I'd be happy to help 
> but I need some guidance to pinpoint the problem. 
OK, but first can You try to fix Your cron daemon? Just make sure that if mpop 
is already started it won't be started again. Maybe something like "pgrep mpop" 
and "if [ $?". 
I don't remember exactly, but some time ago somebody had problem with to large 
disk buffers and sync(). Check LKML archives. MPOP is doing fsync().
You have VIA chipset. Me too. It isn't very reliable. Don't You have something 
like "error { d0 BUSY }" in dmesg? This would explain high CPU load. Simply 
DMA isn't used after such error and disk goes to PIO mode. On two disk system 
load is about 4.0 in this case. Simple program takes hours to complete if 
there is havy I/O in progress. Btw. SLUB seems to behave better in this 
situation (at least up to 8.0).
> Thanks, 
> Dimitris
Regards
Rafa³


----------------------------------------------------------------------
Dowiedz sie, co naprawde podnieca kobiety. Wiecej wiesz, latwiej je
oczarujesz 

>>>http://link.interia.pl/f1b17

