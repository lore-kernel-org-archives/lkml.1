Return-Path: <linux-kernel-owner+w=401wt.eu-S1758311AbZDSM5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311AbZDSM5l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 08:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757809AbZDSM5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 08:57:32 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:35210 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbZDSM5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 08:57:32 -0400
Message-ID: <49EB1FB3.5000609@garzik.org>
Date: Sun, 19 Apr 2009 08:57:23 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: Mark Lord <lkml@rtr.ca>,
       =?UTF-8?B?Um9nw6lyaW8gQnJpdG8=?= <rbrito@ime.usp.br>,
       linux-kernel@vger.kernel.org
Subject: Re: Quick question about libata and hdparm
References: <E693AEE4-7895-4650-A1DC-1FB16D409D5B@ime.usp.br> <49EB1A33.7050808@rtr.ca> <49EB1C9C.3000105@msgid.tls.msk.ru>
In-Reply-To: <49EB1C9C.3000105@msgid.tls.msk.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev wrote:
> Mark Lord wrote:
> []
>> Nearly all of the hdparm flags work fine with libata and SATA/PATA 
>> drives.
>> Among the *very few* that do not, are the -m and -d flags.  -c will be 
>> working
>> in the newest kernels, but not yet in most distro kernels.
>>
>> The -d flag is not permitted by libata, as the kernel prefers to 
>> completely
>> dictate DMA / PIO, and it does do a rather good job of it.
> 
> Well, the kernel does a good job here in *almost* all cases.
> The problematic case is when a device has some bad/unreadable
> blocks/sectors.  When such a place occurs on read, libata
> (or whatever it is) performs several retries, each time
> using "less aggressive" settings - like reducing UDMA and
> PIO mode till the lowest possible PIO/33.  And the device
> stays in that mode until reboot, even if the problematic
> sector has been relocated.  So it'd be nice to be able to
> reset the mode back in such cases.

Do you have a log?

libata worries about speed changes for CRC errors and the like, not for 
media errors that involve sector relocation.

	Jeff




