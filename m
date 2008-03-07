Return-Path: <linux-kernel-owner+w=401wt.eu-S1760881AbYCGCRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760881AbYCGCRL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 21:17:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754453AbYCGCQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 21:16:54 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:43016 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754262AbYCGCQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 21:16:53 -0500
Message-ID: <47D0A58D.3050500@garzik.org>
Date: Thu, 06 Mar 2008 21:16:45 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Mark Lord <liml@rtr.ca>, Matthew Wilcox <matthew@wil.cx>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: ata_ram driver
References: <20080222200951.GI16995@parisc-linux.org>	 <47BF3E54.9050609@rtr.ca>  <47CFA9A6.2040506@gmail.com>	 <1204817301.3062.3.camel@localhost.localdomain>	 <47D08478.8010700@gmail.com>	 <1204848119.3062.94.camel@localhost.localdomain>	 <47D08892.3080209@gmail.com> <1204849353.3062.107.camel@localhost.localdomain> <47D08C32.8060907@gmail.com>
In-Reply-To: <47D08C32.8060907@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> James Bottomley wrote:
>>> Yeap, sure.  It's the combination of things that always made me put this
>>> off.  Is there a function I can call to just shutdown the host instead
>>> of destroying it?
>> Not really ... the process of unbinding the ULDs causes their remove
>> methods to call shudown.  It is possible to separate this in the ULDS;
>> but the original design was to make remove and shutdown be similar for
>> the very reason that if you're removing the driver with unflushed data
>> in the cache, we'd really like it flushed (flush is called from
>> shutdown) because you have no way to talk to the device after this
>> without reinserting the driver.
> 
> The problem is that libata EH and other stuff aren't ready to let go of
> the SCSI host up until the last moment and that last moment can't be
> moved before SCSI host destruction because shutdown sequence (flush and
> spindown) requires live EH.  I think this can be solved by shooting down
> individual sdev's instead of destroying the scsi_host.

I'm curious how the picture would change, if we used a scsi_host for 
each ata_host.

	Jeff



