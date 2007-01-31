Return-Path: <linux-kernel-owner+w=401wt.eu-S1030251AbXAaQfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030251AbXAaQfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 11:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030247AbXAaQfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 11:35:36 -0500
Received: from mexforward.lss.emc.com ([128.222.32.20]:41616 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030243AbXAaQfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 11:35:34 -0500
Message-ID: <45C0C542.2090609@emc.com>
Date: Wed, 31 Jan 2007 11:35:14 -0500
From: Ric Wheeler <ric@emc.com>
Reply-To: ric@emc.com
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
CC: Mark Lord <liml@rtr.ca>, "Eric D. Mudama" <edmudama@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>, dougg@torque.net
Subject: Re: [PATCH] scsi_lib.c: continue after MEDIUM_ERROR
References: <200701301947.08478.liml@rtr.ca>	<1170206199.10890.13.camel@mulgrave.il.steeleye.com>	<311601c90701301725n53d25a74g652b7ca3bfc64c56@mail.gmail.com>	<45BFF3D6.9050605@rtr.ca>	<45C00AEE.1090708@emc.com>	<45C0B0DC.8030501@rtr.ca> <20070131152301.19a8a5ac@localhost.localdomain>
In-Reply-To: <20070131152301.19a8a5ac@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.0.283055, Antispam-Data: 2007.1.31.80434
X-PerlMx-Spam: Gauge=, SPAM=2%, Reason='EMC_FROM_0+ -2, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __USER_AGENT 0'
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Alan wrote:
>> When libata reports a MEDIUM_ERROR to us, we *know* it's non-recoverable,
>> as the drive itself has already done internal retries (libata uses the
>> "with retry" ATA opcodes for this).
> 
> This depends on the firmware. Some of the "raid firmware" drives don't
> appear to do retries in firmware.

I think that even for these devices, the actual drives behind the controller 
will do retries. In any case, it would be reasonable to be able to set this 
retry/no-retry via /sys to handle exceptional cases...

> 
>> But meanwhile, we still have the original issue too, where a single stray
>> bad sector can blow a system out of the water, because the mid-layer
>> currently aborts everything after it from a large merged request.
>>
>> Thus the original patch from this thread.  :)
> 
> Agreed


