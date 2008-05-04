Return-Path: <linux-kernel-owner+w=401wt.eu-S1757603AbYEDVH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603AbYEDVH3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 17:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbYEDVHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 17:07:22 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:58569 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbYEDVHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 17:07:20 -0400
Message-ID: <481E2535.8080301@oracle.com>
Date: Sun, 04 May 2008 14:05:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Joe Perches <joe@perches.com>,
       linux-next@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] PNP: fix printk format warnings
References: <20080430135608.8b6ee7e0.randy.dunlap@oracle.com> <1209589640.5041.67.camel@localhost> <481E0C13.9010907@keyaccess.nl>
In-Reply-To: <481E0C13.9010907@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> On 30-04-08 23:07, Joe Perches wrote:
> 
>> On Wed, 2008-04-30 at 13:56 -0700, Randy Dunlap wrote:
>>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>>
>>> next-20080430/drivers/pnp/pnpbios/rsparser.c:594: warning: format 
>>> '%d' expects type 'int', but argument 4 has type 'resource_size_t'
>>> next-20080430/drivers/pnp/pnpbios/rsparser.c:605: warning: format 
>>> '%d' expects type 'int', but argument 4 has type 'resource_size_t'
>>
>> resource_size_t can be u64
>> I think you need %llu/(unsigned long long)
>>
>> --- next-20080430.orig/drivers/pnp/pnpbios/rsparser.c
>> +++ next-20080430/drivers/pnp/pnpbios/rsparser.c
>> @@ -591,7 +591,7 @@ static void pnpbios_encode_irq(struct pn
>>      p[1] = map & 0xff;
>>      p[2] = (map >> 8) & 0xff;
>>  
>> -    dev_dbg(&dev->dev, "  encode irq %d\n", res->start);
>> +    dev_dbg(&dev->dev, "  encode irq %llu\n", (unsigned long 
>> long)res->start);
>>  }
>>  
>>  static void pnpbios_encode_dma(struct pnp_dev *dev, unsigned char *p,
>> @@ -602,7 +602,7 @@ static void pnpbios_encode_dma(struct pn
>>      map = 1 << res->start;
>>      p[1] = map & 0xff;
>>  
>> -    dev_dbg(&dev->dev, "  encode dma %d\n", res->start);
>> +    dev_dbg(&dev->dev, "  encode dma %llu\n", (unsigned long 
>> long)res->start);
>>  }
>>  
>>  static void pnpbios_encode_port(struct pnp_dev *dev, unsigned char *p,
> 
> Bjorn? Could swear I previously saw patches that just did an (int) cast 
> here...

My original patch did (int) cast but Joe suggested using
unsigned long long.  I didn't expect DMA channel or irq to be anywhere
near that large, so I thought that (int) would be sufficient,
at the same time recognizing that it does/could truncate the value,
while ull won't truncate.

-- 
~Randy
