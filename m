Return-Path: <linux-kernel-owner+w=401wt.eu-S1757842AbXH3KsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842AbXH3KsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 06:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbXH3KsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 06:48:00 -0400
Received: from mail.cargoscan.com ([213.145.173.179]:62840 "EHLO quark"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750845AbXH3Kr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 06:47:59 -0400
Message-ID: <46D6A053.3020600@rutger.no>
Date: Thu, 30 Aug 2007 12:47:47 +0200
From: "Espen M. Rutger" <espen@rutger.no>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: linux-kernel@vger.kernel.org
Subject: Re: ide.c and compactFlash
References: <46CD75F3.6030707@rutger.no> <20070829132653.GA11130@csclub.uwaterloo.ca>
In-Reply-To: <20070829132653.GA11130@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
> On Thu, Aug 23, 2007 at 01:56:35PM +0200, Espen M. Rutger wrote:
>   
>> I got problems with the IDE code which causes the kernel to freez after 
>> printing out:
>>
>> hda: status timeout: status=0xd0 { Busy }
>>
>> kernel used: 2.4.18 crosscompiled with Montavista tools (ppc_82xx-gcc 
>> (GCC) 3.2.1 20020930 (MontaVista))
>>
>> The ide interface chip is a PD6729 configured to ATA mode.
>>
>> CompactFlash cards: winsys 1GB industrial grade and simpleTech 1GB 
>> industrial grade.
>>
>> I beleive this is a timing issue and have tried to increase a udelay () 
>> to 2 microseconds (instead of 1 microsecond) in the ide_wait_stat() 
>> function - it took longer time to freez, but it still freezes...
>>     
>
> Try booting with 'ide=nodma'.  Some compact flash cards support DMA
> mode, and of course most IDE controllers support DMA mode, and if both
> support it the kernel tends to try and enable it but if you don't have
> the DMA lines connected it will fail and give annoying errors similar to
> that one.  The DMA part of compact flash was a fairly recent addition
> and the two affected lines used to be reserved on compact flash.  The
> product I work on did not have the DMA lines on the previous board
> design but we have it on the latest board revision.  On the old boards
> we had to disable DMA support for IDE since otherwise certain types of
> compact flash would have annoying timeouts trying to enable DMA.  On our
> new board with the DMA lines, everything just works and the DMA access
> gives about twice the read/write speed to the compact flash cards we are
> using.
>
> --
> Len Sorensen
>
>   

Thank you very much for your response Lennart, but unfortunately this 
did not solve my problem - the system (got four machines in my test 
setup) still generate the error and make the kernel wait forever.

regards
Espen M. Rutger

