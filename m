Return-Path: <linux-kernel-owner+w=401wt.eu-S1755118AbYBOPpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118AbYBOPpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 10:45:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbYBOPo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 10:44:56 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:50413 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbYBOPoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 10:44:54 -0500
Message-ID: <47B5B374.2080403@garzik.org>
Date: Fri, 15 Feb 2008 10:44:52 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Boaz Harrosh <bharrosh@panasas.com>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] gdth: convert to PCI hotplug API
References: <20080212234928.GA13892@havoc.gtf.org> <1203024822.3158.29.camel@localhost.localdomain>
In-Reply-To: <1203024822.3158.29.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
>> diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
>> index c825239..1b53e92 100644
>> --- a/drivers/scsi/gdth.c
>> +++ b/drivers/scsi/gdth.c
>> @@ -595,85 +595,107 @@ static int __init gdth_search_isa(ulong32 bios_adr)
>>  #endif /* CONFIG_ISA */
>>  
>>  #ifdef CONFIG_PCI
>> -static void gdth_search_dev(gdth_pci_str *pcistr, ushort *cnt,
>> -                            ushort vendor, ushort dev);
>> +static gdth_pci_str gdth_pcistr[MAXHA];
>> +static int gdth_pci_cnt;
>> +static bool gdth_pci_registered;
> 
> Could we get rid of these static arrays and MAXHA entirely?  It should
> be possible just to bung the parameters in pci_str into gdth_ha_str and
> dump the arrays.


I kept those array for one reason:  you need it to preserve the existing 
in-driver PCI device sort.

If we can eliminate the sorting, then the array can easily disappear.

I /think/ the sort can be eliminated now because we have pci=reverse, 
but I have not verified that guess.

	Jeff



