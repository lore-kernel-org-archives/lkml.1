Return-Path: <linux-kernel-owner+w=401wt.eu-S1758648AbZA2Qw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648AbZA2Qw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 11:52:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbZA2Qwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 11:52:46 -0500
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:54597 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751135AbZA2Qwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 11:52:45 -0500
X-Trace: 138636578/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.44.176.198/None/adrian@newgolddream.dyndns.info
X-SBRS: None
X-RemoteIP: 80.44.176.198
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-MUA: SquirrelMail/1.4.15
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ag4FAMtsgUlQLLDG/2dsb2JhbACBbstLhBAG
X-IronPort-AV: E=Sophos;i="4.37,345,1231113600"; 
   d="scan'208";a="138636578"
Message-ID: <793692118a2f4bdd17326e8bed6c9792.squirrel@newgolddream.dyndns.info>
In-Reply-To: <3ca9ec7a13c1a13ea7be6c37bbdfdb0c.squirrel@newgolddream.dyndns.info>
References: <1233186456.6734.16.camel@localhost.localdomain>
    <1233187069.6734.21.camel@localhost.localdomain>
    <20090129031341.GD31096@linux-sh.org>
    <3ca9ec7a13c1a13ea7be6c37bbdfdb0c.squirrel@newgolddream.dyndns.info>
Date: Thu, 29 Jan 2009 16:51:43 -0000 (UTC)
Subject: Re: [PATCH RFC] sh: maple: Add support for SEGA Dreamcast VMU and  
         clean up maple bus driver (1/3)
From: "Adrian McMenamin" <adrian@newgolddream.dyndns.info>
To: "Adrian McMenamin" <adrian@newgolddream.dyndns.info>
Cc: "Paul Mundt" <lethal@linux-sh.org>, "Greg KH" <greg@kroah.com>,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       "dwmw2" <dwmw2@infradead.org>, "linux-sh" <linux-sh@vger.kernel.org>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "linux-input" <linux-input@vger.kernel.org>,
       "linux-mtd" <linux-mtd@vger.kernel.org>
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, January 29, 2009 4:43 pm, Adrian McMenamin wrote:
> On Thu, January 29, 2009 3:13 am, Paul Mundt wrote:
>> On Wed, Jan 28, 2009 at 11:57:49PM +0000, Adrian McMenamin wrote:
>>> Rework the maple bus driver to support block reads and writes, while
>>> also cleaning up the code and aiming for a consistent namespace for
>>> functions.
>>>
>>> -	mutex_init(&mq->mutex);
>>> +	mq->recvbuf->buf = (void *)P2SEGADDR(&((mq->recvbuf->bufx)[0]));
>>>
>> Please do not abuse P2SEGADDR in this fashion. No new code should be
>> using P2SEGADDR anyways. maple is particularly abusive in this case
>> since
>> it bounces back and forth between P2SEGADDR and PHYSADDR to try and
>> ignore the fact cache flushing has to be handled.
>>
>> You may also wish to consider ioremap/ioremap_nocache().
>>
>
> Can I just use dma_cache_sync before each dma run and then use the P1
> address space?
>

After the dma run I mean - the cache is flushed before the run - but not
after.

