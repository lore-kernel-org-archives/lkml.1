Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbXLLBa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbXLLBa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 20:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbXLLBaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 20:30:21 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:12531 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbXLLBaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 20:30:20 -0500
Date: Tue, 11 Dec 2007 17:28:28 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Rene Herman <rene.herman@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz, andi@firstfloor.org,
       rol@as2917.net, Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
       hpa@zytor.com, john@stoffel.org, linux-os@analogic.com
Subject: Re: [RFT] Port 0x80 I/O speed
Message-Id: <20071211172828.50e68804.randy.dunlap@oracle.com>
In-Reply-To: <475F1DC6.5090403@keyaccess.nl>
References: <475F1DC6.5090403@keyaccess.nl>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Dec 2007 00:31:18 +0100 Rene Herman wrote:

> Good day.
> 
> Would some people on x86 (both 32 and 64) be kind enough to compile and run 
> the attached program? This is about testing how long I/O port access to port 
> 0x80 takes. It measures in CPU cycles so CPU speed is crucial in reporting.
> 
> Posted a previous incarnation of this before, buried in the outb 0x80 thread 
> which had a serialising problem. This one should as far as I can see measure 
> the right thing though. Please yell if you disagree...
> 
> For me, on a Duron 1300 (AMD756 chipset) I have a constant:
> 
> rene@7ixe4:~/src/port80$ su -c ./port80
> cycles: out 2400, in 2400
> 
> and on a PII 400 (Intel 440BX chipset) a constant:
> 
> rene@6bap:~/src/port80$ su -c ./port80
> cycles: out 553, in 251
> 
> Results are (mostly) independent of compiler optimisation, but testing with 
> an -O2 compile should be most useful. Thanks!

(-m32 build on x86_64)

midway:/home/rddunlap/src # ./port80
cycles: out 2702, in 1903
midway:/home/rddunlap/src # ./port80
cycles: out 2688, in 1893
midway:/home/rddunlap/src # ./port80
cycles: out 2703, in 1909
midway:/home/rddunlap/src # ./port80
cycles: out 2687, in 1893
midway:/home/rddunlap/src # ./port80
cycles: out 2687, in 1893
midway:/home/rddunlap/src # ./port80
cycles: out 2701, in 1907
midway:/home/rddunlap/src # ./port80
cycles: out 2701, in 1919
midway:/home/rddunlap/src # ./port80
cycles: out 2687, in 1893
midway:/home/rddunlap/src # ./port80
cycles: out 2701, in 1909
midway:/home/rddunlap/src # ./port80
cycles: out 2706, in 1906

/proc/cpuinfo says CPU speed is
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 4
model name      :               Intel(R) Pentium(R) D CPU 3.00GHz
stepping        : 4
cpu MHz         : 2999.988


---
~Randy
