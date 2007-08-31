Return-Path: <linux-kernel-owner+w=401wt.eu-S1759174AbXHaIXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174AbXHaIXY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 04:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755967AbXHaIXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 04:23:16 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:57906 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755657AbXHaIXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 04:23:14 -0400
Message-ID: <46D7CFD7.9030404@free.fr>
Date: Fri, 31 Aug 2007 10:22:47 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: hda: set_drive_speed_status: status=0x51 { DriveReady SeekComplete
 Error }
References: <46D59ED2.4000900@free.fr>	<20070829174657.09c7de3c@the-village.bc.nu>	<46D67D09.6090101@free.fr>	<46D69E03.9080403@vc.cvut.cz>	<46D6B85C.5050509@free.fr>	<46D6DDF6.6080400@free.fr> <20070831003127.6f6950f4@the-village.bc.nu>
In-Reply-To: <20070831003127.6f6950f4@the-village.bc.nu>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:

> John Sigler wrote:
> 
>> http://www.pqimemory.com/documents/domdata.pdf
>> PIO mode 2 is mentioned. Even DMA seems to be supported.
>> Or am I mistaken?
>> 
>> Could there be a bug in my south bridge?
> 
> Nothing there about DMA support.

cf. document's page 12.

DMACK- (DMA acknowledge)

This signal shall be used by the host in response to DMARQ to initiate 
DMA transfers.

DMARQ (DMA request)

This signal, used for DMA data transfer between host and device, shall 
be asserted by the device when it is ready to transfer data to or from 
the host. The direction of data transfer is controlled by DIOR- and 
DIOW-. This signal is used in a handshake manner with DMACK- i.e., the 
device shall wait until the host asserts DMACK- before negating DMARQ, 
and re-asserting DMARQ if there is more data to transfer.

This line shall be released (high impedance state) whenever the device 
is not selected or is selected and no DMA command is in progress. When 
enabled by DMA transfer, it shall be driven high and low by the device.

When a DMA operation is enabled, CS0- and CS1- shall not be asserted and 
transfers shall be 16-bits wide.

I took the above to mean the device was designed to support DMA.
Where did I err?

> The data sheet says the media can only do 4.1MB/second which is
> consistent with only needing PIO2 (actually it's far slower than PIO2)

Is such a slow speed typical of DOMs sold today?

Or do DOMs sold today support DMA bus mastering, much higher interface 
rates, and much higher sustained throughput?

Regards.
