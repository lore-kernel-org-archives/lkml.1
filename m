Return-Path: <linux-kernel-owner+w=401wt.eu-S1754351AbYIWRJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbYIWRJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 13:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbYIWRJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 13:09:46 -0400
Received: from h155.mvista.com ([63.81.120.155]:42287 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751580AbYIWRJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 13:09:46 -0400
Message-ID: <48D92313.3060605@ru.mvista.com>
Date: Tue, 23 Sep 2008 21:10:43 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Mark de Wever <koraq@xs4all.nl>
Cc: petkovbb@gmail.com, Gadi Oxman <gadio@netvision.net.il>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IDE-TAPE NULL terminate strings.
References: <20080921185138.GA16310@localhost> <48D79ABD.8060805@ru.mvista.com> <9ea470500809220656j6dfcf4c9q7a5a4185481ec994@mail.gmail.com> <20080922204129.GA3495@localhost> <48D80949.4080901@ru.mvista.com> <20080923161434.GA4444@localhost>
In-Reply-To: <20080923161434.GA4444@localhost>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark de Wever wrote:

>>>diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
>>>index 1bce84b..c41f5b1 100644
>>>--- a/drivers/ide/ide-tape.c
>>>+++ b/drivers/ide/ide-tape.c
>>>@@ -2338,7 +2338,7 @@ static void idetape_get_inquiry_results(ide_drive_t *drive)
>>> {
>>> 	idetape_tape_t *tape = drive->driver_data;
>>> 	struct ide_atapi_pc pc;
>>>-	char fw_rev[6], vendor_id[10], product_id[18];
>>>+	char fw_rev[6] = {'\0'}, vendor_id[10] = {'\0'}, product_id[18] = {'\0'};

>>  Do you realize how much *absolutely unnecessary* code will this bring
>>in?

> I did not, I just had a look at the code GCC produced. I did expect much
> smaller code, but maybe that's only generated with -Os.

    My imagination sufficed to foresee how much code a compiler would have to 
produce to completely initialize the arrays of the *auto* memory class -- even 
regardless of optimization. And all that mostly to no purpose.

>>This is certainly worse than your initial patch (if it was correct).

> My initial patch did work, 

    If ide_fixstring() wouldn't have to do any space compression, it would 
work. If it would have to compress spaces, 2 garbage characters would be 
copied by it and then printed.

> but that doesn't matter much, since Boris
> posted another patch based on your suggestions. I like that patch better
> as my initial patch. I'm testing it now and I expect it to work.

    Me too. :-)

> Regards,
> Mark de Wever

WBR, Sergei
