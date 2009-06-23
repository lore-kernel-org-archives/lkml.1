Return-Path: <linux-kernel-owner+w=401wt.eu-S1757244AbZFWNrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244AbZFWNrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 09:47:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758608AbZFWNqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 09:46:44 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:49740 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757060AbZFWNqn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 09:46:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=SGFI2YpHAq2BKBv5KiJZ+aKisMxjQ2HSG65Da3GCwOzavJn/e9GUqugEPcdqvJZJmS
         DoCgXzb6RCjC4sDcC7NxuXVbcAE3TzRx5L2CZG3AeiLR3mFVz0tdHvJQJ3z5qiY7I29t
         FSX7URiPWNtb+R5iZxndx3VuB1gCBzmIH8Q8w=
MIME-Version: 1.0
In-Reply-To: <20090623133954.GA11764@fluff.org.uk>
References: <1245763114-7753-1-git-send-email-vapier@gentoo.org> 
	<20090623133954.GA11764@fluff.org.uk>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 23 Jun 2009 09:46:25 -0400
Message-ID: <8bd0f97a0906230646l248aa5e2t2922a3ba7bdc19d9@mail.gmail.com>
Subject: Re: [PATCH] USB: isp1760: allow platform devices to customize 
	devflags
To: Ben Dooks <ben-linux@fluff.org>
Cc: gregkh@suse.de, bigeasy@linuxtronix.de, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 09:39, Ben Dooks wrote:
> On Tue, Jun 23, 2009 at 09:18:34AM -0400, Mike Frysinger wrote:
>> From: Michael Hennerich <michael.hennerich@analog.com>
>>
>> Platform device support was merged earlier, but support for boards to
>> customize the devflags aspect of the controller was not.  We want this on
>> Blackfin systems to control the bus width, but might as well expose all of
>> the fields while we're at it.
>>
>> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
>> Signed-off-by: Bryan Wu <cooloney@kernel.org>
>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>> ---
>>  drivers/usb/host/isp1760-hcd.c |    4 ++++
>>  drivers/usb/host/isp1760-hcd.h |    2 ++
>>  drivers/usb/host/isp1760-if.c  |   21 ++++++++++++++++++++-
>>  include/linux/usb/isp1760.h    |   18 ++++++++++++++++++
>>  4 files changed, 44 insertions(+), 1 deletions(-)
>>  create mode 100644 include/linux/usb/isp1760.h
>>
>> diff --git a/drivers/usb/host/isp1760-hcd.c b/drivers/usb/host/isp1760-hcd.c
>> index 1543846..9600a58 100644
>> --- a/drivers/usb/host/isp1760-hcd.c
>> +++ b/drivers/usb/host/isp1760-hcd.c
>> @@ -386,6 +386,10 @@ static int isp1760_hc_setup(struct usb_hcd *hcd)
>>               hwmode |= HW_DACK_POL_HIGH;
>>       if (priv->devflags & ISP1760_FLAG_DREQ_POL_HIGH)
>>               hwmode |= HW_DREQ_POL_HIGH;
>> +     if (priv->devflags & ISP1760_FLAG_INTR_POL_HIGH)
>> +             hwmode |= HW_INTR_HIGH_ACT;
>> +     if (priv->devflags & ISP1760_FLAG_INTR_EDGE_TRIG)
>> +             hwmode |= HW_INTR_EDGE_TRIG;
>
> better move these to the irq resource flags from the resource array
> in the platfrom device.

dont really know what you mean.  the setup() function is shared
between multiple bus types (pci/platform/...), so the bits cant really
be pushed from the setup() to the platform resources ...
-mike
