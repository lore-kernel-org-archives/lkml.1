Return-Path: <linux-kernel-owner+w=401wt.eu-S932758AbZDHSr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932758AbZDHSr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 14:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758355AbZDHSrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 14:47:48 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:57226 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757585AbZDHSrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 14:47:47 -0400
Message-ID: <49DCF14F.1060407@garzik.org>
Date: Wed, 08 Apr 2009 14:47:43 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libata: Prepare for hard drives w/ non-512 sector sizes
References: <20090408065955.GA29845@havoc.gtf.org> <20090408183243.GK20983@parisc-linux.org>
In-Reply-To: <20090408183243.GK20983@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Wed, Apr 08, 2009 at 02:59:55AM -0400, Jeff Garzik wrote:
>> I checked this into libata-dev.git#sectsize and #NEXT...  comments
>> welcome.  It's willy's patch, cut down such that it introduces no
>> major behavior changes [READ CAPACITY improves slightly].
> 
> Umm.  If you wanted me to split the patch up, why didn't you ask?

I've had trouble until recently simply getting you to post patches at 
all.  It was faster and simpler for me to do it myself.


> I really do think I should be credited as 'Author' here.  You credit me
> in the patch description, but the automated tools don't show that.

If that is your preference, that's fine.  I did it this way to avoid 
your taking the blame for anything I did, while still noting in the 
patch description you did the original work.


>> @@ -2354,10 +2355,25 @@ saving_not_supp:
>>   */
>>  static unsigned int ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *rbuf)
>>  {
>> -	u64 last_lba = args->dev->n_sectors - 1; /* LBA of the last block */
>> +	struct ata_device *dev = args->dev;
>> +	u64 last_lba = dev->n_sectors - 1; /* LBA of the last block */
>> +	u32 sector_size;
>> +	u8 log_per_phys = 1;
> 
> This was a bug I had fixed, but possibly not sent out.  It should be 0,
> not 1 (it's the power of 2, not the raw count).

Ok.

	Jeff



