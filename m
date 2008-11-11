Return-Path: <linux-kernel-owner+w=401wt.eu-S1753100AbYKKWqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbYKKWqy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 17:46:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYKKWqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 17:46:45 -0500
Received: from cantor.suse.de ([195.135.220.2]:41713 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbYKKWqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 17:46:44 -0500
From: "NeilBrown" <neilb@suse.de>
To: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
Date: Wed, 12 Nov 2008 09:46:36 +1100 (EST)
Message-ID: <5f46e30cc6798d8b201c2e25aa2c04e1.squirrel@neil.brown.name>
In-Reply-To: <200811112328.15522.s.L-H@gmx.de>
References: <20081111180958.4480949037@coco.kroah.org>
    <200811112328.15522.s.L-H@gmx.de>
Subject: Re: patch 
     md-linear-fix-a-division-by-zero-bug-for-very-small-arrays.patch 
     added to 2.6.27-stable tree
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, maan@systemlinux.org,
       stable@kernel.org
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, November 12, 2008 9:28 am, Stefan Lippers-Hollmann wrote:
> Hi
>
> On Dienstag, 11. November 2008, gregkh@suse.de wrote:

>>
>> --- a/drivers/md/linear.c
>> +++ b/drivers/md/linear.c
>> @@ -157,6 +157,8 @@ static linear_conf_t *linear_conf(mddev_
>>
>>  	min_spacing = conf->array_sectors / 2;
>>  	sector_div(min_spacing, PAGE_SIZE/sizeof(struct dev_info *));
>> +	if (min_sectors == 0)
>> +		min_sectors = 1;
>>
>>  	/* min_spacing is the minimum spacing that will fit the hash
>>  	 * table in one PAGE.  This may be much smaller than needed.
>
> drivers/md/linear.c: In function 'linear_conf':
> drivers/md/linear.c:160: error: 'min_sectors' undeclared (first use in
> this function)
> drivers/md/linear.c:160: error: (Each undeclared identifier is reported
> only once
> drivers/md/linear.c:160: error: for each function it appears in.)
> make[5]: *** [drivers/md/linear.o] Error 1
> make[4]: *** [drivers/md] Error 2
> make[4]: *** Waiting for unfinished jobs....
>
> This one obviously depends on:
>
> commit 23242fbb470ff4c8c4d41f178832cf1929273d7d
> Author: Andre Noll <maan@systemlinux.org>
> Date:   Mon Oct 13 11:55:12 2008 +1100
>
>     md: linear.c: Make two local variables sector-based.
>
> which in turn depends on previous changes.

Yes, but only syntactically, not semantically.

In 2.6.27, it needs to be
   if (min_spacing == 0)
           min_spacing = 1;

The other previous patches don't need to be backported.

Thanks for reporting this.

NeilBrown


>
> Regards
> 	Stefan Lippers-Hollmann
>

