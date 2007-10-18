Return-Path: <linux-kernel-owner+w=401wt.eu-S1762430AbXJRIii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762430AbXJRIii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 04:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755795AbXJRIib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 04:38:31 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33078 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755821AbXJRIia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 04:38:30 -0400
Message-ID: <47171B78.9060901@garzik.org>
Date: Thu, 18 Oct 2007 04:38:16 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [bug] ata subsystem related crash with latest -git
References: <20071017172932.GI15552@kernel.dk> <20071017173408.GA1960@elte.hu> <20071017174503.GA4622@elte.hu> <20071017175337.GN15552@kernel.dk> <20071017183716.GU15552@kernel.dk> <20071017190901.GA13780@elte.hu> <alpine.LFD.0.999.0710171217160.26902@woody.linux-foundation.org> <20071017193542.GA15552@kernel.dk> <20071018070706.GA7435@elte.hu> <471717BF.4030108@pobox.com> <20071018083213.GN5063@kernel.dk>
In-Reply-To: <20071018083213.GN5063@kernel.dk>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Thu, Oct 18 2007, Jeff Garzik wrote:
>> Ingo Molnar wrote:
>>> * Jens Axboe <jens.axboe@oracle.com> wrote:
>>>> --- a/drivers/scsi/scsi_lib.c
>>>> +++ b/drivers/scsi/scsi_lib.c
>>>> @@ -39,7 +39,7 @@
>>>>   * (unless chaining is used). Should ideally fit inside a single page, 
>>>> to
>>>>   * avoid a higher order allocation.
>>>>   */
>>>> -#define SCSI_MAX_SG_SEGMENTS	128
>>>> +#define SCSI_MAX_SG_SEGMENTS	129
>>> this one finally made the trick and it's booting fine now, without any 
>>> crashes!
>> Alas, this didn't help me here.  I did manage to capture the error messages 
>> this time, and in the two machines I'm actively testing on, sata_mv is the 
>> driver that's dying in both cases.  Machine A additionally has sata_nv, 
>> which is working.  Machine B additionally has ata_piix, which is working.  
>> So in both cases, its sata_mv that is throwing SError complaints:
> 
> Theory - ata_sg_is_last() isn't returning true for the last entry. Can
> you double check that it correcly marks the last entry in mv_fill_sg()?
> Alternatively, just try this patch.

Will check in a few minutes, after my current test:  I noticed that 
sg_tablesize in sata_mv is not LIBATA_MAX_PRD.  This is expected 
behavior, but I wonder if that difference -- most notably being smaller 
than SCSI_MAX_SG_SEGMENTS -- would trigger any latent bugs.

Anyway, we will both have answers momentarily...

	Jeff



