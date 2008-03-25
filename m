Return-Path: <linux-kernel-owner+w=401wt.eu-S1757021AbYCYWrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021AbYCYWrB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 18:47:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbYCYWqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 18:46:53 -0400
Received: from mail.tmr.com ([64.65.253.246]:49348 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753932AbYCYWqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 18:46:52 -0400
Message-ID: <47E98108.9000906@tmr.com>
Date: Tue, 25 Mar 2008 18:47:36 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Chris Snook <csnook@redhat.com>
CC: Emmanuel Florac <eflorac@intellique.com>, linux-kernel@vger.kernel.org
Subject: Re: RAID-1 performance under 2.4 and 2.6
References: <20080325194306.4ac71ff2@galadriel.home> <47E975F8.3000702@redhat.com>
In-Reply-To: <47E975F8.3000702@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook wrote:
> Emmanuel Florac wrote:
>> I post there because I couldn't find any information about this
>> elsewhere : on the same hardware ( Athlon X2 3500+, 512MB RAM, 2x400 GB
>> Hitachi SATA2 hard drives ) the 2.4 Linux software RAID-1 (tested 2.4.32
>> and 2.4.36.2, slightly patched to recognize the hardware :p) is way
>> faster than 2.6 ( tested 2.6.17.13, 2.6.18.8, 2.6.22.16, 2.6.24.3)
>> especially for writes. I actually made the test on several different
>> machines (same hard drives though) and it remained consistent across
>> the board, with /mountpoint a software RAID-1.
>> Actually checking disk activity with iostat or vmstat shows clearly a
>> cache effect much more pronounced on 2.4 (i.e. writing goes on much
>> longer in the background) but it doesn't really account for the
>> difference. I've also tested it thru NFS from another machine (Giga
>> ethernet network):
>>
>> dd if=/dev/zero of=/mountpoint/testfile bs=1M count=1024
>>
>> kernel        2.4       2.6        2.4 thru NFS   2.6 thru NFS
>>
>> write        90 MB/s    65 MB/s      70 MB/s       45 MB/s
>> read         90 MB/s    80 MB/s      75 MB/s       65 MB/s
>>
>> Duh. That's terrible. Does it mean I should stick to  (heavily
>> patched...) 2.4 for my file servers or... ? :)
>>
> 
> It means you shouldn't use dd as a benchmark.
> 
What do you use as a benchmark for writing large sequential files or 
reading them, and why is it better than dd at modeling programs which 
read or write in a similar fashion?

Media programs often do data access in just this fashion, multi-channel 
video capture, streaming video servers, and similar.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
