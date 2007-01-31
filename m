Return-Path: <linux-kernel-owner+w=401wt.eu-S965128AbXAaPNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965128AbXAaPNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 10:13:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965125AbXAaPNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 10:13:25 -0500
Received: from rtr.ca ([64.26.128.89]:3573 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965007AbXAaPNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 10:13:23 -0500
Message-ID: <45C0B211.2030305@rtr.ca>
Date: Wed, 31 Jan 2007 10:13:21 -0500
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ric Wheeler <ric@emc.com>, "Eric D. Mudama" <edmudama@gmail.com>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>, dougg@torque.net
Subject: Re: [PATCH] scsi_lib.c: continue after MEDIUM_ERROR
References: <200701301947.08478.liml@rtr.ca>	 <1170206199.10890.13.camel@mulgrave.il.steeleye.com>	 <311601c90701301725n53d25a74g652b7ca3bfc64c56@mail.gmail.com>	 <45BFF3D6.9050605@rtr.ca>  <45C00AEE.1090708@emc.com> <1170217288.10890.37.camel@mulgrave.il.steeleye.com>
In-Reply-To: <1170217288.10890.37.camel@mulgrave.il.steeleye.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
>
> For the MD case, this is what REQ_FAILFAST is for.

I cannot find where SCSI honours that flag.  James?

And for that matter, even when I patch SCSI so that it *does* honour it,
I don't actually see the flag making it into the SCSI layer from above.

And I don't see where/how the block layer takes care when considering
merge FAILFAST/READA requests with non FAILFAST/READA requests.
To me, it looks perfectly happy to add non-FAILFAST/READA bios
to a FAILFAST request, risking data loss if a lower-layer decides
to honour the FAILFAST/READA flags.

So it's a pretty Good Thing(tm) that SCSI doesn't currently honour it. ;)
 

