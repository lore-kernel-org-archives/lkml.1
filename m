Return-Path: <linux-kernel-owner+w=401wt.eu-S1759885AbZFPPGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759885AbZFPPGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 11:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758865AbZFPPGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 11:06:11 -0400
Received: from mail.pentek.com ([12.35.250.145]:2387 "HELO mailhost.pentek.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756731AbZFPPGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 11:06:10 -0400
Message-ID: <4A37B4D8.5090404@pentek.com>
Date: Tue, 16 Jun 2009 11:06:00 -0400
From: Steve Rottinger <steve@pentek.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Leon Woestenberg <leon.woestenberg@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: splice methods in character device driver
References: <4A0838D1.5090102@pentek.com> <20090511192253.GH4694@kernel.dk> <4A0AFC62.3090002@pentek.com> <c384c5ea0906031432x2675c5a4xcc940a567ca408b8@mail.gmail.com> <20090604073218.GT11363@kernel.dk> <4A27CA0A.7060400@pentek.com> <c384c5ea0906121221p <20090616115917.GX11363@kernel.dk>
In-Reply-To: <20090616115917.GX11363@kernel.dk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Jens Axboe wrote:
>
>> Although,  I think that most of the overhead that I was experiencing
>> came from the cumulative
>> overhead of each splice system call.   I increased my pipe size using
>> Jens' pipe size patch,
>> from 16 to 256 pages, and this had a huge effect -- the speed of my
>> transfers more than doubled.
>> Pipe sizes larger that 256 pages, cause my kernel to crash.
>>     
>
> Yes, the system call is more expensive. Increasing the pipe size can
> definitely help there.
>
>   
I know that you have been asked this before, but is there any chance
that we can
get the pipe size patch into the kernel mainline?  It seems like it is
essential to
moving data fast using the splice interface.

>> I'm doing about 300MB/s to my hardware RAID, running two instances of my
>> splice() copy application
>> (One on each RAID channel).  I would like to combine the two RAID
>> channels using a software RAID 0;
>> however, splice, even from /dev/zero runs horribly slow to a software
>> RAID device.  I'd be curious
>> to know if anyone else has tried this?
>>     
>
> Did you trace it and find out why it was slow? It should not be. Moving
> 300MB/sec should not be making any machine sweat.
>
>   
I haven't dug into this too deeply, yet; however, I did discover
something interesting:
The splice runs much faster using the software raid, if I transfer to a
file on a mounted
filesystem, instead of the raw md block device. 

-Steve

