Return-Path: <linux-kernel-owner+w=401wt.eu-S1758843AbXGVOZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843AbXGVOZV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 10:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbXGVOZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 10:25:10 -0400
Received: from main.gmane.org ([80.91.229.2]:56526 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbXGVOZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 10:25:09 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "treul" <lgijnpuhx@gmail.com>
Subject: dma hardware underrun
Date: Sun, 22 Jul 2007 21:59:44 +0800
Message-ID: <f7vnsh$aun$1@sea.gmane.org>
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 58.24.170.49
X-MSMail-Priority: Normal
X-Newsreader: Microsoft Outlook Express 6.00.2900.3138
X-RFC2646: Format=Flowed; Original
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,


I'm currently experiencing a tough DMA underrun problem.

The system is like:

                 global bus
                      ||
data-compressor ------||------//---- memory
IDE-PCI harddisk -----||
data-decompressor ----||
data-consumer --------||
                      ||

1. harddisk has the compressed data, read to compressed buffer by DMA1;
2. data-decompressor gets data from compressed buffer by DMA2, and puts 
decompressed data to decompressed buffers in ISR;
3. data-consumer eats the decompressed data at an uncompromisable speed;

The data-consumer encounters DMA underrun...

My debugging result shows the underrun goes away if I put 2 printf's in the 
harddisk ISR. The printf is at milli-seconds whereas the duration of the 
original ISR is at lower magnitude. In addition, I find a SATA-PCI harddisk 
does not have the underrun problem. IDE-PCI device gets the trouble.

In addition, all interrupts are at the same priority and ISR's can not be 
preempted by others.

So, do you have any idea about where the root cause can be hiding? Or what 
do you think of adding printf's in ISR? (performance? incurring other 
problems by disabling interrupt too long?)

Thanks!!


-treul



