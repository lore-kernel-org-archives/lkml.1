Return-Path: <linux-kernel-owner+w=401wt.eu-S1759564AbZA2Qpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564AbZA2Qpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 11:45:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755593AbZA2QpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 11:45:09 -0500
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:50339 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753076AbZA2QpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 11:45:06 -0500
X-Trace: 138628985/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.44.176.198/None/adrian@newgolddream.dyndns.info
X-SBRS: None
X-RemoteIP: 80.44.176.198
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-MUA: SquirrelMail/1.4.15
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ag4FANtrgUlQLLDG/2dsb2JhbACBbstAhBAG
X-IronPort-AV: E=Sophos;i="4.37,345,1231113600"; 
   d="scan'208";a="138628985"
Message-ID: <3ca9ec7a13c1a13ea7be6c37bbdfdb0c.squirrel@newgolddream.dyndns.info>
In-Reply-To: <20090129031341.GD31096@linux-sh.org>
References: <1233186456.6734.16.camel@localhost.localdomain>
    <1233187069.6734.21.camel@localhost.localdomain>
    <20090129031341.GD31096@linux-sh.org>
Date: Thu, 29 Jan 2009 16:43:50 -0000 (UTC)
Subject: Re: [PATCH RFC] sh: maple: Add support for SEGA Dreamcast VMU and 
     clean up maple bus driver (1/3)
From: "Adrian McMenamin" <adrian@newgolddream.dyndns.info>
To: "Paul Mundt" <lethal@linux-sh.org>,
       "Adrian McMenamin" <adrian@newgolddream.dyndns.info>,
       "Greg KH" <greg@kroah.com>,
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

On Thu, January 29, 2009 3:13 am, Paul Mundt wrote:
> On Wed, Jan 28, 2009 at 11:57:49PM +0000, Adrian McMenamin wrote:
>> Rework the maple bus driver to support block reads and writes, while
>> also cleaning up the code and aiming for a consistent namespace for
>> functions.
>>
>> -	mutex_init(&mq->mutex);
>> +	mq->recvbuf->buf = (void *)P2SEGADDR(&((mq->recvbuf->bufx)[0]));
>>
> Please do not abuse P2SEGADDR in this fashion. No new code should be
> using P2SEGADDR anyways. maple is particularly abusive in this case since
> it bounces back and forth between P2SEGADDR and PHYSADDR to try and
> ignore the fact cache flushing has to be handled.
>
> You may also wish to consider ioremap/ioremap_nocache().
>

Can I just use dma_cache_sync before each dma run and then use the P1
address space?

