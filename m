Return-Path: <linux-kernel-owner+w=401wt.eu-S1752846AbZHXQqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbZHXQqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 12:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbZHXQqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 12:46:31 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:43443 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbZHXQqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 12:46:30 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19090.50074.62901.633104@stoffel.org>
Date: Mon, 24 Aug 2009 12:45:14 -0400
From: "John Stoffel" <john@stoffel.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org, htejun@gmail.com, bzolnier@gmail.com,
       alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Subject: Re: [PATCH 4/7] libata: use lazy workqueues for the pio task
In-Reply-To: <4A92C081.50207@garzik.org>
References: <1251100616-28604-1-git-send-email-jens.axboe@oracle.com>
	<1251100616-28604-5-git-send-email-jens.axboe@oracle.com>
	<4A92C081.50207@garzik.org>
X-Mailer: VM 8.0.9 under Emacs 22.3.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jeff" == Jeff Garzik <jeff@garzik.org> writes:

Jeff> On 08/24/2009 03:56 AM, Jens Axboe wrote:
>> Signed-off-by: Jens Axboe<jens.axboe@oracle.com>
>> ---
>> drivers/ata/libata-core.c |    2 +-
>> 1 files changed, 1 insertions(+), 1 deletions(-)
>> 
>> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
>> index 072ba5e..35f74c9 100644
>> --- a/drivers/ata/libata-core.c
>> +++ b/drivers/ata/libata-core.c
>> @@ -6580,7 +6580,7 @@ static int __init ata_init(void)
>> {
>> ata_parse_force_param();
>> 
>> -	ata_wq = create_workqueue("ata");
>> +	ata_wq = create_lazy_workqueue("ata");
>> if (!ata_wq)
>> goto free_force_tbl;

Jeff> No objections to the code, operationally...

Jeff> But it is disappointing that the "1 thread on UP" problem is not
Jeff> solved while changing this libata area.  Is there no way to
Jeff> specify a minimum lazy-thread count?

Jeff> A key problem continues to be tying to the number of CPUs, which
Jeff> is quite inappropriate for libata.

So should the minimum number be the NumATADisks on the system?  Actual
or potential?  I've got a system with dual CPUs and two IDE disk, two
SATA disks and two SCSI disks, plus two SCSI Tape drives.  All on
seperate controllers... how would that work?

John


