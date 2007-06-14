Return-Path: <linux-kernel-owner+w=401wt.eu-S1753147AbXFNMbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbXFNMbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 08:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbXFNMat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 08:30:49 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:31933 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbXFNMar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 08:30:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=NqeVf4UGPrdTXgS2feZxEQnvPKDx68qD91ImHXJN35ll1dJ57u6kXZKjgB3gygdhTemAY5LK/W1mN4K9IrgVMQrv7gmSIMC3aLq/myh2Q5GwqDxrcd7KVkOazMynq+6E58EiOhBGIlZMsSyahoP2i4e0xvbM124pXSRS6iVcvFA=
Message-ID: <467134F1.1010009@gmail.com>
Date: Thu, 14 Jun 2007 21:30:41 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Arjan van de Ven <arjan@linux.intel.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>, jeff@garzik.org,
       james.bottomley@steeleye.com, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch 0/3] AHCI Link Power Management
References: <20070611114600.7fca1c24.kristen.c.accardi@intel.com> <466DFDB5.9030901@gmail.com> <466E0642.5020506@linux.intel.com> <466E1D51.9070007@gmail.com> <20070614115600.GF6149@kernel.dk>
In-Reply-To: <20070614115600.GF6149@kernel.dk>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
>> 1. It didn't have proper interface with userland.  This was mainly
>> because of missing ATA sysfs nodes.  I'm not sure whether adding this to
>> scsi node is a good idea.
>>
>> 2. It was focused on SATA link PS and couldn't cover the Lenovo case.
>>
>> I think we need something at the block layer.
> 
> I think the hardware method is preferable, actually. Doing this in the
> block layer would mean keeping track of idle time, and that quickly
> turns into a lot of timer management. Not exactly free, in terms of CPU
> usage.

Yeah, software implementation certainly has complexity overhead.

> I've yet to do some power measurements with this ahci patch, I just
> noticed that with min_power performance drops from ~55mb/sec to
> ~15mb/sec sequential on my drive. That's pretty drastic :-)

That's another thing I don't like about ALPE/ASP.  According to the
spec, there is no idle timer whatsoever.  The controller is supposed to
drive the link into PS mode whenever FIS is not in flight, so the link
goes in and out of PS state repeatedly when commands are issued
back-to-back.  Getting out of PS state takes a bit of time and slows
down things.

-- 
tejun
