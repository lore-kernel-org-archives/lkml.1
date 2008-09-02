Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436AbYIBPtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbYIBPtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 11:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbYIBPtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 11:49:31 -0400
Received: from nat.xms.se ([212.181.93.157]:62834 "EHLO arwen.xms.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751295AbYIBPta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 11:49:30 -0400
Message-ID: <48BD6086.1030101@xms.se>
Date: Tue, 02 Sep 2008 17:49:26 +0200
From: "Jonas Petersson" <jonas.petersson@xms.se>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Owen Martin <omartin@netezza.com>
CC: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-ide@vger.kernel.org,
       smartmontools-support@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [smartmontools-support] exception Emask 0x0 SAct 0x0 SErr 0x0
 action 0x2 frozen
References: <48B91198.3020803@xms.se><alpine.DEB.1.10.0808300708330.19513@p34.internal.lan><48B9AE15.7010605@xms.se><alpine.DEB.1.10.0808301710380.11166@p34.internal.lan><48B9C261.4010609@xms.se> <alpine.DEB.1.10.0808301804290.11166@p34.internal.lan> <FAF797E46D786344A7C36218608F791C01F3ABA5@mail1.netezza.com>
In-Reply-To: <FAF797E46D786344A7C36218608F791C01F3ABA5@mail1.netezza.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Owen,

Owen Martin wrote:
 > This looks like a timeout during a read command:
 >
 > ata3.00: cmd c8/00:08:90:3c:59
 >
 > Read dma of 8 blocks from 0x903c59
 >
 > Next time it happens, see if it is the same LBA. Since the drive came
 > back after the bus reset makes me think it was probably in error
 > recovery for an extended amount of time.

Sounds like a good idea. However, I had the drive swapped yesterday and 
have now reinstalled on a (seemingly) identical one which so far seems 
to be free from these messages. Hence, I keep my fingers crossed that 
this was indeed a hw error.

As it was on warranty I was not allowed to keep the bad drive for 
further experiments.

 > Sorry, but I am new to using smartmontools for decoding SMART
 > attributes. Your previous email showed:
 >
 > Device is:        Not in smartctl database [for details use: -P showall]
 >
 > Does that imply the tool will not know the exact meaning of all the
 > attributes? I am not familiar with Fujitsu's implementation.

I believe you are correct.

 >>From the data you sent about the attributes before, it looks like the
 > pending and reallocated sector counts are zero, so the block must have
 > not failed recovery. Can you try to dump the sector using hdparm-8.9 to
 > see if it reproduces?
 >
 > hdparm --read-sector 9452633 /dev/sda

Would if I could... The messages I sent were indeed only from cases 
where the driver succeeded write to the disk in the end (extracts from 
/var/log/messages). In the failure cases I did not make a hard copy.

 > What is the timeout set to?
 >
 > cat /sys/block/sda/device/timeout

30

 > Maybe try to increase that. You want to be sure that it is not a drive
 > issue by verifying the block is readable and the raw values from the
 > pending, uncorrectable or reallocated sector attributes don't change.

Will do if I ever see it again.

			Best / Jonas


