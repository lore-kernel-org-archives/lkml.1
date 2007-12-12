Return-Path: <linux-kernel-owner+w=401wt.eu-S1754232AbXLLXy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbXLLXy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 18:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbXLLXys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 18:54:48 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:58701 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbXLLXyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 18:54:47 -0500
Date: Thu, 13 Dec 2007 00:54:45 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Rene Herman <rene.herman@gmail.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz, andi@firstfloor.org,
       rol@as2917.net, Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
       hpa@zytor.com, john@stoffel.org, linux-os@analogic.com
Subject: Re: [RFT] Port 0x80 I/O speed
In-Reply-To: <475F1DC6.5090403@keyaccess.nl>
Message-ID: <Pine.LNX.4.64.0712130041590.32346@fbirervta.pbzchgretzou.qr>
References: <475F1DC6.5090403@keyaccess.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 12 2007 00:31, Rene Herman wrote:
>
> Would some people on x86 (both 32 and 64) be kind enough to compile and run the
> attached program? This is about testing how long I/O port access to port 0x80
> takes. It measures in CPU cycles so CPU speed is crucial in reporting.
>

Transmeta TM5800 CPU with nominal frequency 933 MHz, but it has a
hardware(!) 'ondemand' governor over the range of frequencies that
the user allowed scaling over, irrespective of the software governor.
(That is, if the CPU can do 300,533 and 933 MHz, and setting the
min/max to 300/533 will cause the hardware to 'ondemand' between 300
and 533 only. And that even if 'performance' is set on the software
side - so the only way to enforce 'performance' is to actually set
min=933.)

00:46 takeshi:../cpu0/cpufreq # echo 300000 >scaling_min_freq
00:46 takeshi:../cpu0/cpufreq # echo 933000 >scaling_max_freq
00:42 takeshi:/dev/shm # for ((x=1;x<=10;++x)); do ./port80 ; done
cycles: out 1514, in 584
cycles: out 1371, in 516
cycles: out 1291, in 472
cycles: out 1304, in 437
cycles: out 1308, in 410
cycles: out 1315, in 419
cycles: out 1315, in 419
cycles: out 1314, in 419
cycles: out 1315, in 420
cycles: out 1315, in 419
00:44 takeshi:/dev/shm # for ((x=1;x<=10;++x)); do ./port80 ; done
cycles: out 1511, in 596
cycles: out 1373, in 517
cycles: out 1293, in 470
cycles: out 1294, in 424
cycles: out 1304, in 414
cycles: out 1315, in 420
cycles: out 1313, in 418
cycles: out 1313, in 418
cycles: out 1314, in 420
cycles: out 1314, in 419

Increasing x above 10 yields only 1313-1315 values, so nothing more to see.
Note the values < 1313!! They only happen during scaling.
(I think scaling is the most important sideexercise in this test,
even on hardware which does not have hardware governors - e.g. your
average Intel/AMD CPUs.)

Single frequencies:
00:46 takeshi:../cpu0/cpufreq # echo 933000 >scaling_min_freq
00:46 takeshi:../cpu0/cpufreq # echo 933000 >scaling_max_freq
00:46 takeshi:../cpu0/cpufreq # for ((x=1;x<=10;++x)); do /dev/shm/port80 ;
donecycles: out 1314, in 419
cycles: out 1315, in 420
cycles: out 1314, in 419
cycles: out 1312, in 417
cycles: out 1315, in 420
cycles: out 1314, in 419
cycles: out 1313, in 419
cycles: out 1313, in 419
cycles: out 1314, in 419
cycles: out 1312, in 418

00:47 takeshi:../cpu0/cpufreq # echo 533000 >scaling_min_freq
00:47 takeshi:../cpu0/cpufreq # echo 533000 >scaling_max_freq
00:49 takeshi:../cpu0/cpufreq # for ((x=1;x<=10;++x)); do /dev/shm/port80 ;
donecycles: out 1372, in 508
cycles: out 1370, in 509
cycles: out 1372, in 515
cycles: out 1372, in 503
cycles: out 1372, in 503
cycles: out 1370, in 509
cycles: out 1368, in 513
cycles: out 1372, in 516
cycles: out 1372, in 504
cycles: out 1372, in 516

00:47 takeshi:../cpu0/cpufreq # echo 300000 >scaling_min_freq
00:47 takeshi:../cpu0/cpufreq # echo 300000 >scaling_max_freq
00:48 takeshi:../cpu0/cpufreq # for ((x=1;x<=10;++x)); do /dev/shm/port80 ;
donecycles: out 1515, in 650
cycles: out 1516, in 649
cycles: out 1517, in 651
cycles: out 1513, in 645
cycles: out 1514, in 649
cycles: out 1516, in 644
cycles: out 1517, in 651
cycles: out 1516, in 644
cycles: out 1512, in 647
cycles: out 1514, in 649
