Return-Path: <linux-kernel-owner+w=401wt.eu-S1754567AbYIVVIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbYIVVIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 17:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbYIVVIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 17:08:34 -0400
Received: from homer.mvista.com ([63.81.120.155]:19072 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753330AbYIVVId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 17:08:33 -0400
Message-ID: <48D80949.4080901@ru.mvista.com>
Date: Tue, 23 Sep 2008 01:08:25 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Mark de Wever <koraq@xs4all.nl>
Cc: petkovbb@gmail.com, Gadi Oxman <gadio@netvision.net.il>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IDE-TAPE NULL terminate strings.
References: <20080921185138.GA16310@localhost> <48D79ABD.8060805@ru.mvista.com> <9ea470500809220656j6dfcf4c9q7a5a4185481ec994@mail.gmail.com> <20080922204129.GA3495@localhost>
In-Reply-To: <20080922204129.GA3495@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Mark de Wever wrote:

>> .. and I know why :). Those ide_tape_obj members (char fw_rev[6], vendor_id[10],
>> product_id[18]) were used only once in idetape_get_inquiry_results() so I moved
>> them there as local stack variables. Originally, they were kzalloc'ed as part of
>> struct ide_tape_obj and now they contain stack garbage therefore the funny
>> values. The simple solution would be to zero them out or:
>>
>>
>> Does the following patch help?
>>     
>
> Yes feel free to add my tested-by.
>   

   And my NAK too. :-)

> Only not sure whether the static is the best solution, the following
> patch also works, by zeroing the memory as you suggested.
>
> Signed-off-by: Mark de Wever <koraq@xs4all.nl>
>
> diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
> index 1bce84b..c41f5b1 100644
> --- a/drivers/ide/ide-tape.c
> +++ b/drivers/ide/ide-tape.c
> @@ -2338,7 +2338,7 @@ static void idetape_get_inquiry_results(ide_drive_t *drive)
>  {
>  	idetape_tape_t *tape = drive->driver_data;
>  	struct ide_atapi_pc pc;
> -	char fw_rev[6], vendor_id[10], product_id[18];
> +	char fw_rev[6] = {'\0'}, vendor_id[10] = {'\0'}, product_id[18] = {'\0'};
>   

   Do you realize how much *absolutely unnecessary* code will this bring 
in? This is certainly worse than your initial patch (if it was correct).
Ugh, looks like I'll have t submit the patch myself to stop this ugliness...

MBR, Sergei


