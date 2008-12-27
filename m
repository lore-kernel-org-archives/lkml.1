Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbYL0UO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbYL0UO4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 15:14:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753417AbYL0UOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 15:14:45 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:6338 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbYL0UOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 15:14:44 -0500
Message-ID: <49568CAD.7050509@gawab.com>
Date: Sat, 27 Dec 2008 12:14:37 -0800
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081205)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: lkml <linux-kernel@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Garzik <jeff@garzik.org>
Subject: Re: [2.6.28-rc] Sata soft reset filling log
References: <494318F5.4060007@gawab.com> <494EFD79.7020008@kernel.org> <494F3AD2.3060201@gawab.com> <494F3E41.60304@kernel.org> <49500BE2.6050106@gawab.com> <49504B8C.8080907@kernel.org>
In-Reply-To: <49504B8C.8080907@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
>> What changes happened between .27 and .28 could've caused this?
>> Anyways, below is what I get now (with your patch), including the
>> frequency of occurrence.
>>     
>
> I have no idea and I'm afraid we'll need a bisection here. :-( Can you
> please try the attached patch?
>
> Thanks.
>
>   

I applied the patch and get the following:

ata2: XXX status=50 after 100 tries
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata2.00: ST_FIRST: !(DRQ|ERR|DF)
ata2.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         cdb 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
         res 50/00:01:00:00:00/00:00:00:00:00/a0 Emask 0x2 (HSM violation)
ata2.00: status: { DRDY }
ata2: soft resetting link
ata2.00: configured for UDMA/33
ata2: EH complete

I tried to git bisect the problem. First time I thought the error was 
between rc2 and rc3,
but the bisect gave inconclusive results because I couldn't tell for 
sure a good commit from a bad.
I tried again with .27 to .28-rc3, but I was unable to bisect because of 
compile errors (in pre-rc1),
and doing git bisect skip, again landed on a commit with compile errors.

Unless you can think of anything else, I'm just going to wait and see if 
a commit in .29 will fix the problem.

Justin Madru
