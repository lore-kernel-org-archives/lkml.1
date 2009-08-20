Return-Path: <linux-kernel-owner+w=401wt.eu-S1754385AbZHTMrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385AbZHTMrm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 08:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754351AbZHTMrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 08:47:41 -0400
Received: from mail-px0-f196.google.com ([209.85.216.196]:49423 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349AbZHTMrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 08:47:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=U3TjyNWzQzkHRn2BjSXT7a7kt+Lu9eBp9MdIqYjGWyH3jlxII9nvsxg9ukDAm+DF+X
         aVPrpTiPuszAtP38wcQoOwglZe0kSKBZMqX1QDM2bMAkSB3CfV2O6B2ohbLyppz5dE7p
         C88gf7D7VuPOzOwyEzBuJ7/D6YGZ/VGbYGHkY=
Message-ID: <4A8D45DF.8010307@gmail.com>
Date: Thu, 20 Aug 2009 21:47:27 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Jens Axboe <jens.axboe@oracle.com>, Mark Lord <liml@rtr.ca>,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata: use single threaded work queue
References: <20090819112554.GY12579@kernel.dk> <4A8BE932.5090300@garzik.org>	 <20090819120458.GZ12579@kernel.dk> <4A8BECC2.2060607@rtr.ca>	 <20090819122320.GA12579@kernel.dk> <1250720545.4810.37.camel@pasglop>
In-Reply-To: <1250720545.4810.37.camel@pasglop>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Wed, 2009-08-19 at 14:23 +0200, Jens Axboe wrote:
>> Well, that's the same thread pool suggestion that Jeff came up with.
>> And
>> I agree, that's a nicer long term solution (it's also how the per-bdi
>> flushing replacement works). The problem with that appears to be that
>> any suggested patchset for thread pools spiral into certain "but what
>> color should it be?!" death.
>>
>> I'll try and work up a simple create_threadpool() implementation, we
>> can
>> literally cut away hundreds of threads with that.
> 
> Don't we have one already ? Dave Howells slow_work or such ?

Yes, it addresses different aspect of the concurrency problem.  Might
be more suitable for ATA workqueues but definitely more costly to
convert to.  Argh...

-- 
tejun
