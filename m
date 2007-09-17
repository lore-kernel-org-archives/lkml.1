Return-Path: <linux-kernel-owner+w=401wt.eu-S1754147AbXIQI1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbXIQI1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbXIQI1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:27:01 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:56662 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbXIQI07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:26:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=kYtKH5xgWYdbw59miRu0+dUM83MPhbpBLzGDV6A0BGRZZVy+gmv5a/Q7ojwBlfdQZ7Fe5RzScJZsgPSOOk6Fja8XijOonk2te+wnF96b50ytidbmnaA7FnKR82/npfb6YcEHmT2KM3XFTAdFXjP1tc/sSW7PESBYzid48XeJHOk=
Message-ID: <46EE09D3.9010201@gmail.com>
Date: Mon, 17 Sep 2007 07:00:03 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Mikael Pettersson <mikpe@it.uu.se>, Jeff Norden <jeff@math.tntech.edu>,
       alan@redhat.com, linux-kernel@vger.kernel.org,
       Albert CC Lee <albertcc@tw.ibm.com>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 1/1] pata_it821x: fix lost interrupt with atapi devices
References: <200709041607.l84G7KsT032647@norden.math.tntech.edu>	<18141.42848.537873.349518@alkaid.it.uu.se> <20070906013929.1621849d@the-village.bc.nu>
In-Reply-To: <20070906013929.1621849d@the-village.bc.nu>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[cc'ing Albert and linux-ide]

Alan Cox wrote:
> /from the media. */
>>  > +	if (qc->nbytes < 2048)
>>  > +		return -EOPNOTSUPP;
>>  > +
>>  >  	/* No ATAPI DMA in smart mode */
>>  >  	if (itdev->smart)
>>  >  		return -EOPNOTSUPP;
>>  > 
>>
>> This looks like a gross hack. Aren't you supposed to inspect
>> the command instead and whitelist the ones you know are OK,
>> like pata_pdc2027x.c and sata_promise.c do?
> 
> It does seem to be about transfer size in the IT821x case not commands.
> It may be to do with how we issue ATAPI command transfer sizes from high
> up (patch went to Jeff) but for now this is definitely the right approach
> 
> Reviewed-by: Alan Cox <alan@redhat.com>

I wonder whether we should be using similar check in generic path too.
We have quite a few cases where MWDMA ATAPI devices choking on commands
with small transfer sizes.  I don't think we'll experience significant
performance regression with this applied and even if there is some, it's
far better to have slightly slower working device.

What do you guys think?

-- 
tejun

