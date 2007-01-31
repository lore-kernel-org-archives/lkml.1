Return-Path: <linux-kernel-owner+w=401wt.eu-S932815AbXAaDwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815AbXAaDwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 22:52:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932803AbXAaDwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 22:52:46 -0500
Received: from mexforward.lss.emc.com ([128.222.32.20]:15756 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932783AbXAaDwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 22:52:43 -0500
X-Greylist: delayed 1937 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Jan 2007 22:52:43 EST
Message-ID: <45C00AEE.1090708@emc.com>
Date: Tue, 30 Jan 2007 22:20:14 -0500
From: Ric Wheeler <ric@emc.com>
User-Agent: Mozilla Thunderbird 1.0.7 (X11/20050923)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: "Eric D. Mudama" <edmudama@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi_lib.c: continue after MEDIUM_ERROR
References: <200701301947.08478.liml@rtr.ca>	 <1170206199.10890.13.camel@mulgrave.il.steeleye.com> <311601c90701301725n53d25a74g652b7ca3bfc64c56@mail.gmail.com> <45BFF3D6.9050605@rtr.ca>
In-Reply-To: <45BFF3D6.9050605@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.0.283055, Antispam-Data: 2007.1.30.184433
X-PerlMx-Spam: Gauge=, SPAM=2%, Reason='EMC_FROM_0+ -2, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __USER_AGENT 0'
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Mark Lord wrote:

> Eric D. Mudama wrote:
>
>>
>> Actually, it's possibly worse, since each failure in libata will 
>> generate 3-4 retries.  With existing ATA error recovery in the 
>> drives, that's about 3 seconds per retry on average, or 12 seconds 
>> per failure.  Multiply that by the number of blocks past the error to 
>> complete the request..
>
>
> It really beats the alternative of a forced reboot
> due to, say, superblock I/O failing because it happened
> to get merged with an unrelated I/O which then failed..
> Etc..
>
> Definitely an improvement.
>
> The number of retries is an entirely separate issue.
> If we really care about it, then we should fix SD_MAX_RETRIES.
>
> The current value of 5 is *way* too high.  It should be zero or one.
>
> Cheers
>
I think that drives retry enough, we should leave retry at zero for 
normal (non-removable) drives. Should this  be a policy we can set like 
we do with NCQ queue depth via /sys ?

We need to be able to layer things like MD on top of normal drive errors 
in a way that will produce a system that provides reasonable response 
time despite any possible IO error on a single component.  Another case 
that we end up doing on a regular basis is drive recovery. Errors need 
to be limited in scope to just the impacted area and dispatched up to 
the application layer as quickly as we can so that you don't spend days 
watching a copy of  huge drive (think 750GB or more) ;-)

ric

