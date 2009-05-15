Return-Path: <linux-kernel-owner+w=401wt.eu-S1758103AbZEOWU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103AbZEOWU2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 18:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756107AbZEOWUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 18:20:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:55467 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715AbZEOWUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 18:20:16 -0400
Message-ID: <4A0DEA84.6010909@kernel.org>
Date: Sat, 16 May 2009 07:19:48 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Pete Zaitcev <zaitcev@redhat.com>
CC: Jens Axboe <jens.axboe@oracle.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Boaz Harrosh <bharrosh@panasas.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH block#for-2.6.31 1/3] ub: use __blk_end_request_all()
References: <4A0D86DB.9000203@kernel.org> <20090515113114.68ae93ae.zaitcev@redhat.com>
In-Reply-To: <20090515113114.68ae93ae.zaitcev@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 15 May 2009 22:19:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pete Zaitcev wrote:
> On Sat, 16 May 2009 00:14:35 +0900, Tejun Heo <tj@kernel.org> wrote:
> 
>> @@ -834,12 +829,7 @@ static void ub_end_rq(struct request *rq
>>  		error = -EIO;
>>  		rq->errors = scsi_status;
>>  	}
>> -	rqlen = blk_rq_bytes(rq);    /* Oddly enough, this is the residue. */
>> -	if (__blk_end_request(rq, error, cmd_len)) {
>> -		printk(KERN_WARNING DRV_NAME
>> -		    ": __blk_end_request blew, %s-cmd total %u rqlen %ld\n",
>> -		    blk_pc_request(rq)? "pc": "fs", cmd_len, rqlen);
>> -	}
>> +	__blk_end_request_all(rq, error);
>>  }
> 
> I applaud this. We needed blk_end_this_mudafakin_request() for a long time.
> Why two underscores?

The ones with two underscores are to be called with queue lock held.
Ones without grab queue lock themselves.

Thanks.

-- 
tejun
