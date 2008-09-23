Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbYIWQRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbYIWQRL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 12:17:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbYIWQQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 12:16:55 -0400
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1696 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbYIWQQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 12:16:54 -0400
Date: Tue, 23 Sep 2008 18:14:35 +0200
From: Mark de Wever <koraq@xs4all.nl>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: petkovbb@gmail.com, Gadi Oxman <gadio@netvision.net.il>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IDE-TAPE NULL terminate strings.
Message-ID: <20080923161434.GA4444@localhost>
References: <20080921185138.GA16310@localhost> <48D79ABD.8060805@ru.mvista.com> <9ea470500809220656j6dfcf4c9q7a5a4185481ec994@mail.gmail.com> <20080922204129.GA3495@localhost> <48D80949.4080901@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D80949.4080901@ru.mvista.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 01:08:25AM +0400, Sergei Shtylyov wrote:
>> diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
>> index 1bce84b..c41f5b1 100644
>> --- a/drivers/ide/ide-tape.c
>> +++ b/drivers/ide/ide-tape.c
>> @@ -2338,7 +2338,7 @@ static void idetape_get_inquiry_results(ide_drive_t *drive)
>>  {
>>  	idetape_tape_t *tape = drive->driver_data;
>>  	struct ide_atapi_pc pc;
>> -	char fw_rev[6], vendor_id[10], product_id[18];
>> +	char fw_rev[6] = {'\0'}, vendor_id[10] = {'\0'}, product_id[18] = {'\0'};
>>   
>
>   Do you realize how much *absolutely unnecessary* code will this bring
> in?

I did not, I just had a look at the code GCC produced. I did expect much
smaller code, but maybe that's only generated with -Os.

> This is certainly worse than your initial patch (if it was correct).

My initial patch did work, but that doesn't matter much, since Boris
posted another patch based on your suggestions. I like that patch better
as my initial patch. I'm testing it now and I expect it to work.

Regards,
Mark de Wever
