Return-Path: <linux-kernel-owner+w=401wt.eu-S1762193AbYBLJHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762193AbYBLJHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 04:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757619AbYBLJH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 04:07:29 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:44010 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291AbYBLJHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 04:07:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=PKcvrD1TLG+Hrd4NKiZ05Oe8kP6/LXf3gHDmFNoQEkRUqlsfFF6i8vqeiudmJpaFlOoq6qz95kZq5vGZNcoYk6ctM+DbSx3tOixBQWa23tuOr1MUoaHP1lyu1vtw1YakNw5eArmZGPYn87E6253IIMBz0V9VqaFDZJV+iZavp7M=
Message-ID: <47B161C3.7040200@gmail.com>
Date: Tue, 12 Feb 2008 18:07:15 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: IDE/ATA development list <linux-ide@vger.kernel.org>,
       Mark Lord <liml@rtr.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH #upstream] libata: implement libata.force module parameter
References: <47A3375F.80101@gmail.com> <47A356C3.3010904@garzik.org>
In-Reply-To: <47A356C3.3010904@garzik.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Tejun Heo wrote:
>> This patch implements libata.force module parameter which can
>> selectively override ATA port, link and device configurations
>> including cable type, SATA PHY SPD limit, transfer mode and NCQ.
>>
>> For example, you can say "use 1.5Gbps for all fan-out ports attached
>> to the second port but allow 3.0Gbps for the PMP device itself, oh,
>> the device attached to the third fan-out port chokes on NCQ and
>> shouldn't go over UDMA4" by the following.
>>
>>  libata.force=2:1.5g,2.15:3.0g,2.03:noncq,udma4
>>
>> Signed-off-by: Tejun Heo <htejun@gmail.com>
>> ---
>> I guess it's about time we add something like this.  More than
>> anything else this should help debugging and can serve as a last
>> resort to work around problems.
>>
>> Thanks.
>>
>>  Documentation/kernel-parameters.txt |   35 +++
>>  drivers/ata/libata-core.c           |  375
>> +++++++++++++++++++++++++++++++++++-
>>  drivers/ata/libata-eh.c             |    8
>>  drivers/ata/libata.h                |    1  4 files changed, 415
>> insertions(+), 4 deletions(-)
> 
> ACK, but it breaks the build due to section type conflicts:
> 
> drivers/ata/libata-core.c:108: error: ata_force_param_buf causes a
> section type conflict
> 
> Given that the data is marked __initdata and the code is marked __init,
> I cannot see the problem.

Jeff, this no longer causes build failure whether libata is configured
built-in or as a module.  I have no idea what's going on but there
doesn't seem to be a proper solution on the horizon yet.  I think we can
go ahead and commit this one and convert it to __initdataconst when it
becomes available.

Thanks.

-- 
tejun
