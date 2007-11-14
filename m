Return-Path: <linux-kernel-owner+w=401wt.eu-S1760140AbXKNB6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760140AbXKNB6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 20:58:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756825AbXKNB6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 20:58:09 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:14664 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412AbXKNB6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 20:58:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=AFLT66y3KrR3tt8FuLYxDA9oEHKcjwYAKVFvSbh2qitFM4Pt3/YRbXDlBQWcX8BbYG+CFIC0ju22akquXfZ3NbTEfv6JikJ7MwajzHtZrpNp3veVQ6vQ7JutAGjSRwylDvEvvGEZ5G2o/ZdFJu8QQ/2ftPYkIaGV7ytQz3AYxIM=
Message-ID: <473A5626.7040008@gmail.com>
Date: Wed, 14 Nov 2007 10:57:58 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] sata_nv: fix ADMA ATAPI issues with memory over 4GB
References: <4738DE21.8090702@shaw.ca> <47390B2F.7090105@gmail.com> <47392768.3030509@shaw.ca> <47392B3D.1020101@gmail.com> <4739B0E5.2010303@rtr.ca>
In-Reply-To: <4739B0E5.2010303@rtr.ca>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Tejun Heo wrote:
>> Robert Hancock wrote:
>>> Tejun Heo wrote:
> ..
>>> Yes, it should likely do something with these return values. Though
>>> theoretically it shouldn't fail, since the DMA mask is either 32-bit,
>>> which shouldn't fail, or one that was successfully set before. Also I
>>> don't think the SCSI layer actually checks the slave_config return
>>> value.. sigh.
>>
>> Then please at least add WARN_ON() && another reason why allocating /
>> deallocating resources from ->slave_config isn't such a good idea.
> ..
> 
> The entire point of "slave_configure" is to provide a point for the LLD
> to do per-device data structure allocation/init.
> 
> And yes, SCSI does check the return code.  Whether the code around that
> check
> is buggy or not is another question, but it's always worked for me.

I see but I still prefer having PRD, pad buf allocation/release in
->port_start/stop() primarily for consistency.  Robert, what do you think?

-- 
tejun
