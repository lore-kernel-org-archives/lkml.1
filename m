Return-Path: <linux-kernel-owner+w=401wt.eu-S1758308AbXKUOXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758308AbXKUOXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 09:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbXKUOXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 09:23:42 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:63660 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbXKUOXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 09:23:41 -0500
Date: Wed, 21 Nov 2007 08:23:38 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] sata_nv: fix ADMA ATAPI issues with memory over 4GB	(v2)
In-reply-to: <1195648784.11490.0.camel@kayak.wul.qc.ec.gc.ca>
To: vincent.fortier1@ec.gc.ca
Cc: ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Tejun Heo <htejun@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <47443F6A.3050205@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 8BIT
References: <47438248.7030704@shaw.ca>
 <1195648784.11490.0.camel@kayak.wul.qc.ec.gc.ca>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vincent Fortier wrote:
> Le mardi 20 novembre 2007 à 18:56 -0600, Robert Hancock a écrit :
>> This fixes some problems with ATAPI devices on nForce4 controllers in ADMA
>> mode on systems with memory located above 4GB. We need to delay setting the
>> 64-bit DMA mask until the PRD table and padding buffer are allocated so that
>> they don't get allocated above 4GB and break legacy mode (which is needed for
>> ATAPI devices). Also, explicitly set a 32-bit DMA mask before allocating the
>> legacy buffers since setting the DMA mask affects both ports and we need to
>> ensure the second port's buffers are allocated properly (fixes a problem
>> with the previous version of this patch).
>>
>> Signed-off-by: Robert Hancock <hancockr@shaw.ca>
>>
> 
> Would this be worth sending to stable team for 2.6.22 & 2.6.23 ?

Likely (after it gets merged), those versions would have the same bug..
