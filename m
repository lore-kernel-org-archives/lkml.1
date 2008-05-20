Return-Path: <linux-kernel-owner+w=401wt.eu-S1764058AbYETXFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764058AbYETXFh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 19:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbYETXF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 19:05:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:57694 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbYETXF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 19:05:28 -0400
Date: Wed, 21 May 2008 01:04:32 +0200 (CEST)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: LKML <linux-kernel@vger.kernel.org>
cc: kanoj@netxen.com
Subject: kswapd busy but not swapping
Message-ID: <alpine.DEB.1.10.0805210050440.13780@sheep.housecafe.de>
User-Agent: Alpine 1.10 (DEB 1032 2008-04-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1/ORSpIjF8W377Nu9LdUUSobt8oEyE2ocWsno0
 Ocr4CNxEehBPqSk+SDdtSTIUVRxvu2AhMhnSlU93DWcwV8ymwx
 +bTaT7Dpam2Sdo3ntbbjQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed that the [kswapd0] thread was eating 3-7% cpu time but no 
swapspace has been used yet. This is with a just booted 2.6.25.4 system,
currently with some disk i/o going on.

So I figured that kswapd might not be responsible for "swapping" after 
all, although the name suggests it. Grep'ing Documentation/ for kswapd did 
not reveal much. Is the paper from Kanoj[0] still valid for 2.6 kernels? 
The SGI page referenced in Documentation/kernel-docs.txt is down, but 
there's a .txt version on [1] which tells me:

   "When memory runs low, and a process can not find a free page, it wakes
    up kswapd, the memory stealer"

So, if I'd run low on memory, kswapd would be active. But I don't see that 
in free(1):

# free -m
              total       used       free     shared    buffers     cached
Mem:          2023       1662        360          0        820        315
-/+ buffers/cache:        526       1496
Swap:         1505          0       1505

If you're interested, there are more details at 
http://nerdbynature.de/bits/2.6.25.4/kswapd

Thanks,
Christian.

[0] http://reality.sgi.com/kanoj_engr/vm229.html
[1] http://www.cse.unsw.edu.au/~neilb/oss/linux-commentary/
-- 
BOFH excuse #197:

I'm sorry a pentium won't do, you need an SGI to connect with us.
