Return-Path: <linux-kernel-owner+w=401wt.eu-S1765445AbYA2P4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765445AbYA2P4m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 10:56:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758262AbYA2P40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 10:56:26 -0500
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:40962 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519AbYA2P4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 10:56:24 -0500
Message-ID: <479F4C4C.2060203@panasas.com>
Date: Tue, 29 Jan 2008 17:54:52 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Greg KH <greg@kroah.com>, Jens Axboe <jens.axboe@oracle.com>,
       Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [BUG] 2.6.24-git usb reset problems
References: <Pine.LNX.4.44L0.0801291032210.4229-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0801291032210.4229-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29 2008 at 17:36 +0200, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Tue, 29 Jan 2008, Boaz Harrosh wrote:
> 
>> --- a/drivers/usb/storage/transport.c
>> +++ b/drivers/usb/storage/transport.c
>> @@ -462,18 +462,24 @@ static int usb_stor_bulk_transfer_sglist(struct us_data *us, unsigned int pipe,
>>   * Common used function. Transfer a complete command
>>   * via usb_stor_bulk_transfer_sglist() above. Set cmnd resid
>>   */
>> -int usb_stor_bulk_srb(struct us_data* us, unsigned int pipe,
>> -		      struct scsi_cmnd* srb)
>> +int usb_stor_bulk_srb_length(struct us_data* us, unsigned int pipe,
>> +		      struct scsi_cmnd* srb, unsigned length)
>>  {
>>  	unsigned int partial;
>>  	int result = usb_stor_bulk_transfer_sglist(us, pipe, scsi_sglist(srb),
>> -				      scsi_sg_count(srb), scsi_bufflen(srb),
>> +				      scsi_sg_count(srb), length,
>>  				      &partial);
>>  
>>  	scsi_set_resid(srb, scsi_bufflen(srb) - partial);
>>  	return result;
>>  }
>>  
>> +int usb_stor_bulk_srb(struct us_data* us, unsigned int pipe,
>> +		struct scsi_cmnd* srb)
>> +{
>> +	return usb_stor_bulk_srb_length(us, pipe, srb, scsi_bufflen(srb));
>> +}
>> +
> 
> I don't like this patch very much.  Why add another layer of 
> indirection when the two subroutines do hardly any work?  Leave 
> usb_stor_bulk_srb() the way it was, and add usb_stor_bulk_srb_length() 
> as a separate routine that simply calls usb_stor_bulk_transfer_sglist() 
> and scsi_set_resid().
> 
> BTW, the standard coding style calls for a blank line after the list of 
> local variables at the start of a function or block.
> 
> Alan Stern
> 
> -
Me neither, it's not a proper patch just a shut to try and find the reported
bug. I will submit a proper bug later.

Thanks for the review, you are right on all accounts
Boaz

