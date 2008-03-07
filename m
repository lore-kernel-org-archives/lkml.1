Return-Path: <linux-kernel-owner+w=401wt.eu-S1765906AbYCGA24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765906AbYCGA24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 19:28:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760024AbYCGA2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 19:28:45 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:41776 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758245AbYCGA2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 19:28:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=nS+wFLnhRA/bUh268AL/tGHsgSjzrYXXoxIZIpvpbBSohNKjWXHI/SUYZQQkI7nZ7g7CmHIlgXyvPNY1yPuiqFTNHLZYFYS6aWeHcWM7NwRW+iegDc3Nm80ry8T7KsDVyT/JzIOHtKQvlxGBq2ssmQgAdYWKPbrerav/Q8XzBIE=
Message-ID: <47D08C32.8060907@gmail.com>
Date: Fri, 07 Mar 2008 09:28:34 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Mark Lord <liml@rtr.ca>, Matthew Wilcox <matthew@wil.cx>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: ata_ram driver
References: <20080222200951.GI16995@parisc-linux.org>	 <47BF3E54.9050609@rtr.ca>  <47CFA9A6.2040506@gmail.com>	 <1204817301.3062.3.camel@localhost.localdomain>	 <47D08478.8010700@gmail.com>	 <1204848119.3062.94.camel@localhost.localdomain>	 <47D08892.3080209@gmail.com> <1204849353.3062.107.camel@localhost.localdomain>
In-Reply-To: <1204849353.3062.107.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
>> Yeap, sure.  It's the combination of things that always made me put this
>> off.  Is there a function I can call to just shutdown the host instead
>> of destroying it?
> 
> Not really ... the process of unbinding the ULDs causes their remove
> methods to call shudown.  It is possible to separate this in the ULDS;
> but the original design was to make remove and shutdown be similar for
> the very reason that if you're removing the driver with unflushed data
> in the cache, we'd really like it flushed (flush is called from
> shutdown) because you have no way to talk to the device after this
> without reinserting the driver.

The problem is that libata EH and other stuff aren't ready to let go of
the SCSI host up until the last moment and that last moment can't be
moved before SCSI host destruction because shutdown sequence (flush and
spindown) requires live EH.  I think this can be solved by shooting down
individual sdev's instead of destroying the scsi_host.

Thanks.

-- 
tejun
