Return-Path: <linux-kernel-owner+w=401wt.eu-S1752010AbXFLENa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbXFLENa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 00:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750854AbXFLENV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 00:13:21 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:25428 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbXFLENT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 00:13:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=LaLt+ok9Ia4E6qn8nvdAR1fSIcEa5AhvSIAyF48GBZEyJAbI9cImhiEJif+GUXa0GvHhKGQhNtpJIkE65MlOJ0oH5f6i6YhETodpYtQILYgF6+PiYq4pYR10rc6rVKMWHDre+ICgiC+rjrmUVZwK/6fYjCd/tIwlDBFTdG1ZoXs=
Message-ID: <466E1D51.9070007@gmail.com>
Date: Tue, 12 Jun 2007 13:13:05 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Kristen Carlson Accardi <kristen.c.accardi@intel.com>, jeff@garzik.org,
       james.bottomley@steeleye.com, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch 0/3] AHCI Link Power Management
References: <20070611114600.7fca1c24.kristen.c.accardi@intel.com> <466DFDB5.9030901@gmail.com> <466E0642.5020506@linux.intel.com>
In-Reply-To: <466E0642.5020506@linux.intel.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
>> I'm not sure about this.  We need better PM framework to support 
>> powersaving in other controllers and some ahcis don't save much
>> when only link power management is used,
> 
> do you have data to support this?

Yeah, it was some Lenovo notebook.  Pavel is more familiar with the
hardware.  Pavel, what was the notebook which didn't save much power
with standard SATA power save but needed port to be completely turned off?

> The data we have from this patch is that it saves typically a Watt of
> power (depends on the machine of course, but the range is 0.5W to
> 1.5W). If you want to also have an even more agressive thing where
> you want to start disabling the entire controller... I don't see how
> this is in conflict with saving power on the link level by "just"
> enabling a hardware feature ....

Well, both implement about the same thing.  I prefer software
implementation because it's more generic and ALPE/ASP seems too
aggressive to me.  Here are reasons why sw implementation wasn't merged.

1. It didn't have proper interface with userland.  This was mainly
because of missing ATA sysfs nodes.  I'm not sure whether adding this to
scsi node is a good idea.

2. It was focused on SATA link PS and couldn't cover the Lenovo case.

I think we need something at the block layer.

Thanks.

-- 
tejun
