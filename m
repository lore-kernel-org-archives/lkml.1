Return-Path: <linux-kernel-owner+w=401wt.eu-S1758117AbXI3PWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117AbXI3PWk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 11:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755030AbXI3PWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 11:22:33 -0400
Received: from usermail.globalproof.net ([194.146.153.18]:38466 "EHLO
	usermail.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802AbXI3PWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 11:22:32 -0400
From: "Denys" <nuclearcat@nuclearcat.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.21 -> 2.6.22 & 2.6.23-rc8 performance regression
Date: Sun, 30 Sep 2007 18:22:18 +0300
Message-Id: <20070930152218.M1504@nuclearcat.com>
X-Mailer: OpenWebMail 2.52 20060502
X-OriginatingIP: 195.69.208.251 (denys@visp.net.lb)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

P.S. It seems SLAB/SLUB doesn't make much difference, just seems SLUB use a 
bit more some resources.
Still problem appearing with softirqd/0 or softirqd/1 taking a lot CPU (while 
on 2.6.21 it never came up of the "top"), and doesn't matter - if NAPI on 
e1000 disabled or enabled. Additionally disabling all disk operations doesn't 
make any difference.

defaulthost ~ #mpstat 1
Linux 2.6.23-rc8-build-0017 (defaulthost)       09/30/07

21:20:29     CPU   %user   %nice    %sys %iowait    %irq   %soft  %steal
   %idle    intr/s
21:20:30     all   21.11    0.00   14.57    8.04    0.00   48.74    0.00    
7.54   3632.00
21:20:31     all   23.38    0.00   12.94   10.95    0.00   52.74    0.00    
0.00   1524.00
21:20:32     all   21.50    0.00   16.50    8.50    0.00   53.50    0.00    
0.00   1473.00
21:20:33     all   22.39    0.00   14.93    4.98    0.50   53.23    0.00    
3.98   1492.08
21:20:34     all    5.31    0.00    0.97    0.48    0.00   93.24    0.00    
0.00   1351.96

On 2.6.21 it looks:

defaulthost ~ #mpstat 1
Linux 2.6.21-gentoo-r3-build-0015 (defaulthost)         09/30/07

18:21:50     CPU   %user   %nice    %sys %iowait    %irq   %soft  %steal
   %idle    intr/s
18:21:51     all   29.50    0.00   21.50   12.50    0.00    6.00    0.00   
30.50   8416.00
18:21:52     all   26.00    0.00   19.00   12.50    0.50    7.00    0.00   
35.00   8663.64
18:21:53     all   27.23    0.00   17.82   13.37    0.99    6.44    0.00   
34.16   7828.71
18:21:54     all   26.13    0.00   16.08   18.59    0.00    7.04    0.00   
32.16   8657.58
18:21:55     all   22.89    0.00   16.92   18.91    0.50    6.47    0.00   
34.33   7957.43
18:21:56     all   28.14    0.00   21.61   17.59    0.50    6.03    0.00   
26.13   8531.00



--
Denys Fedoryshchenko
Technical Manager
Virtual ISP S.A.L.

