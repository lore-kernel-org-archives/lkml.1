Return-Path: <linux-kernel-owner+w=401wt.eu-S1765642AbXFSUFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765642AbXFSUFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 16:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763009AbXFSUFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 16:05:40 -0400
Received: from h155.mvista.com ([63.81.120.155]:39852 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762080AbXFSUFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 16:05:39 -0400
Message-ID: <46783777.10607@ru.mvista.com>
Date: Wed, 20 Jun 2007 00:07:19 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Linas Vepstas <linas@austin.ibm.com>, Stuart_Hayes@dell.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] ide dma_timer_expiry, then hard lockup
References: <20070618175713.GD5836@austin.ibm.com> <4677FFF1.2010308@ru.mvista.com> <20070619164854.GR5836@austin.ibm.com> <200706192043.40298.bzolnier@gmail.com>
In-Reply-To: <200706192043.40298.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

>>There are two distinct issues.
>>-- libata locks up in partition table read on an hpt366+old maxtor disk
>>   that has ben working fine for many years with old ide driver. (It
>>   still works fine when I boot to the alternate ide-based kernel).

>>-- ide driver locks up on hpt366+new maxtor disk under heavy 
>>   i/o load. I was able to copy 60GB from old to new disk without a
>>   problem; however, raid reconstruction locks it up, maybe after 5-15
>>   seconds.

>>   This probably is "hardware related"; its something that the new 
>>   hard drive does. Given that its being sold at a big discount, it
>>   may even be that the sellers know that this is a crappy disk. :-)

>>   All I want is some way of resetting the disk, and continuing on.

> It would be useful to see hdparm --Istdout output for *both* disks.

>>I'm stalled in debugging; I'm not sue what I'm looking for.

> Sergei, do you think that testing the drive with DMA disabled may
> tell us something new?

    Not sure. I'll try to come up with a patch esetting the state machine in 
dma_timeout() method (following Alan's idea) -- HPT366 regs are different 
enough to use the one for HPT370.

> Thanks,
> Bart

MBR, Sergei
