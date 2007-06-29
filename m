Return-Path: <linux-kernel-owner+w=401wt.eu-S933663AbXF2SvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933663AbXF2SvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 14:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760316AbXF2SvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 14:51:11 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:15523 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755734AbXF2SvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 14:51:10 -0400
Message-ID: <46855505.1070702@ru.mvista.com>
Date: Fri, 29 Jun 2007 22:52:53 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Linas Vepstas <linas@austin.ibm.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] ide dma_timer_expiry, then hard lockup
References: <20070618175713.GD5836@austin.ibm.com> <467BED34.4080004@ru.mvista.com>
In-Reply-To: <467BED34.4080004@ru.mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I wrote:

>> I've got a hard lockup in the ide subsystem, probably
>> due to some irq spew or something like that.

>> I've just bought a brand new Maxtor 320GB disk driver for the insane 
>> price of $70 US to replace another failing drive. It works well under 
>> light load;
>> I was able to copy about 60GB to it. However, under heavy load, such 
>> as reconstruction of an MD RAID-1 array, it'll lock up the kernel.  
>> Which means
>> that my system won't boot :-(

>> I'm running 2.6.21.1, although the problem seems to occur in 2.6.19 
>> and 2.6.18 too; its been there a while; I vageuly
>> remember similar problems in 2.6.5 or 2.6.10.

>    Ah... so you're saying that the old disk works OK, yet you've already 
> observed alike behavior on other disks... That speaks against 
> blacklisting the drive.

    I'm going to shortly post the patches blacklisting the drive and using the 
proper HPT36x enablebits (as much as this stupid design may be fixed :-)...
Please test.

>> I can get the system to boot by sneaking in an "hdparm -d0 /dev/hdc" 
>> early in the boot process, to turn off 

>    Could probably do the same trick and specify the lower DMA speed by 
> using -X n option (where n ranges from 64 to 70 for UltraDMA modes 0 to 
> 6) and see if it changes anything...

    Note that for the hpt366.c driver, this is also achievable by setting 
HPT366_ALLOW_ATA66_[34] to 0 and recompiling. It will limit its UltraDMA 
capabilities to modes 2 or 3.

MBR, Sergei
