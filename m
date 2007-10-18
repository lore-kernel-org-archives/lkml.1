Return-Path: <linux-kernel-owner+w=401wt.eu-S932787AbXJRIXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787AbXJRIXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 04:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762227AbXJRIWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 04:22:46 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:40050 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762139AbXJRIWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 04:22:43 -0400
Message-ID: <471717BF.4030108@pobox.com>
Date: Thu, 18 Oct 2007 04:22:23 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [bug] ata subsystem related crash with latest -git
References: <20071017170804.GG15552@kernel.dk> <20071017172158.GH15552@kernel.dk> <20071017172932.GI15552@kernel.dk> <20071017173408.GA1960@elte.hu> <20071017174503.GA4622@elte.hu> <20071017175337.GN15552@kernel.dk> <20071017183716.GU15552@kernel.dk> <20071017190901.GA13780@elte.hu> <alpine.LFD.0.999.0710171217160.26902@woody.linux-foundation.org> <20071017193542.GA15552@kernel.dk> <20071018070706.GA7435@elte.hu>
In-Reply-To: <20071018070706.GA7435@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -39,7 +39,7 @@
>>   * (unless chaining is used). Should ideally fit inside a single page, to
>>   * avoid a higher order allocation.
>>   */
>> -#define SCSI_MAX_SG_SEGMENTS	128
>> +#define SCSI_MAX_SG_SEGMENTS	129
> 
> this one finally made the trick and it's booting fine now, without any 
> crashes!

Alas, this didn't help me here.  I did manage to capture the error 
messages this time, and in the two machines I'm actively testing on, 
sata_mv is the driver that's dying in both cases.  Machine A 
additionally has sata_nv, which is working.  Machine B additionally has 
ata_piix, which is working.  So in both cases, its sata_mv that is 
throwing SError complaints:

> ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x400000 action 0x6 frozen
> ata7.00: edma_err 0x04000080, EDMA self-disable
> ata7: SError: { Handshk }
> ata7.00: cmd ca/00:08:c7:40:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 out
>          res 50/00:00:ce:40:00/00:00:00:00:00/e0 Emask 0x100 (unknown error)
> ata7.00: status: { DRDY }
> ata7: hard resetting link
> ata7: SATA link up 1.5 Gbps (SStatus 113 SControl 300)

Still digging...  this behavior showed up after libata changes went in, 
FWIW.

	Jeff


