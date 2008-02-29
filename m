Return-Path: <linux-kernel-owner+w=401wt.eu-S1760035AbYB2PS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760035AbYB2PS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 10:18:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbYB2PSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 10:18:46 -0500
Received: from mail.syneticon.net ([213.239.212.131]:42727 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbYB2PSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 10:18:45 -0500
Message-ID: <47C82244.60307@wpkg.org>
Date: Fri, 29 Feb 2008 16:18:28 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Cc: ml_lkml@thefluffyone.net
Subject: Re: Very high IOWait during all disk activity
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I recently noticed on a number of my Linux boxes that during disk
> activity, CPU usage was consistently hitting 100%. A little digging
> showed that the CPU was spending up to around 65% of its time in an
> IOWait state. Checked this with kernels 2.6.22 and 2.6.25-rc3, and
> also across SATA and PATA drives on three different machines, all with
> the same results. I also checked back with an old Ubuntu 6.06 Live CD
> and that also exhibits the problem.
> 
> Having done some digging on the net, I can't get a definitive answer
> as to whether this is considered "normal". Some people suggest that
> IOWait is informational and doesn't indicate a problem, but based on
> my admittedly limited understanding of such things, the CPU shouldn't
> need to spend much time on disk I/O these days due to the use of DMA.
> 
> Is it expected behaviour for the CPU to spend such a large amount of
> time in the IOWait state during disk I/O?

Unless you can write to the disk faster than fetch data from /dev/zero - 
yes, it is normal.

BTW, it doesn't mean that your CPU's cycles are wasted. You will see big 
"wa" numbers when there are no other tasks to schedule at the same time.

Try running:

   cat /dev/zero | bzip2 -c >/dev/null

when your IOwait is big (because you write a big file), and then watch 
the numbers.


-- 
Tomasz Chmielewski
http://wpkg.org

