Return-Path: <linux-kernel-owner+w=401wt.eu-S1753535AbXKXAc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbXKXAc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 19:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbXKXAcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 19:32:48 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:26558 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbXKXAcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 19:32:47 -0500
Date: Fri, 23 Nov 2007 18:31:59 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] sata_nv: fix ADMA ATAPI issues with memory over 4GB (v3)
In-reply-to: <47476E31.2070801@garzik.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Mark Lord <liml@rtr.ca>, "Morrison, Tom" <tmorrison@empirix.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>
Message-id: <474770FF.6040503@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <47463534.9010100@shaw.ca> <4746F02D.2060204@rtr.ca>
 <BD261180E6D35F4D9D32F3E44FD3D901053E8542@EMPBEDEX.empirix.com>
 <474711FE.8040805@rtr.ca> <47476CB9.2040409@shaw.ca>
 <47476E31.2070801@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Robert Hancock wrote:
>> Based on a quick look at sata_mv it appears it sets a 64-bit DMA mask 
>> unconditionally, but for non-ATA_PROT_DMA commands (which includes all 
>> ATAPI), it just falls back to ata_qc_issue_prot which issues via the 
>> legacy SFF interface and can only handle 32-bit addressing. So yes, it 
>> appears to have a similar bug as sata_nv had.
> 
> 
> sata_mv doesn't do ATAPI at all...

Right.. missed that ATA_FLAG_NO_ATAPI. So these issues Tom is reporting 
are just with a normal SATA hard drive?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


