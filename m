Return-Path: <linux-kernel-owner+w=401wt.eu-S1756572AbYH1Wdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572AbYH1Wdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 18:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756547AbYH1WdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 18:33:10 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:28228 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756226AbYH1WdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 18:33:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=AUIIQ8Ot7HKJgjhkBk56t/ZeQgJ2OymxDKMsSqH9iip1zLvHaXfeQJWTkF9bclRfk0
         PExxnsONf8RKkRvWfB0gCwgon997WYCpYPyeaXVpp6PpgKBNpSOA+nYXHNUWfD/8B2Qv
         t1GeCpluS/pgEpTnvIwmLkFgDF+xIK5S9GAVI=
Message-ID: <86802c440808281533q21cd690fm4e39e76cd32ac5e0@mail.gmail.com>
Date: Thu, 28 Aug 2008 15:33:05 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Bjorn Helgaas" <bjorn.helgaas@hp.com>
Subject: Re: [PATCH] pci: Fix printk warnings in probe.c
Cc: "Johann Felix Soden" <johfel@gmx.de>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200808281627.42171.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1219430819.7010.5.camel@localhost>
	 <200808281627.42171.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 3:27 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> On Friday 22 August 2008 12:46:59 pm Johann Felix Soden wrote:
>> From: Johann Felix Soden <johfel@users.sourceforge.net>
>>
>> Fix printk format warnings:
>> drivers/pci/probe.c: In function 'pci_read_bridge_bases':
>> drivers/pci/probe.c:386: warning: format '%llx' expects type 'long long unsigned int', but argument 3 has type 'resource_size_t'
>> drivers/pci/probe.c:386: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'resource_size_t'
>> drivers/pci/probe.c:398: warning: format '%llx' expects type 'long long unsigned int', but argument 3 has type 'resource_size_t'
>> drivers/pci/probe.c:398: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'resource_size_t'
>> drivers/pci/probe.c:434: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'resource_size_t'
>> drivers/pci/probe.c:434: warning: format '%llx' expects type 'long long unsigned int', but argument 5 has type 'resource_size_t'
>>
>> Signed-off-by: Johann Felix Soden <johfel@users.sourceforge.net>
>> ---
>>  drivers/pci/probe.c |   11 ++++++++---
>>  1 files changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
>> index cce2f4c..0ad9367 100644
>> --- a/drivers/pci/probe.c
>> +++ b/drivers/pci/probe.c
>> @@ -383,7 +383,9 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
>>                       res->start = base;
>>               if (!res->end)
>>                       res->end = limit + 0xfff;
>> -             printk(KERN_INFO "PCI: bridge %s io port: [%llx, %llx]\n", pci_name(dev), res->start, res->end);
>> +             printk(KERN_INFO "PCI: bridge %s io port: [%llx, %llx]\n",
>> +                     pci_name(dev), (unsigned long long) res->start,
>> +                     (unsigned long long) res->end);
>
> Thanks for fixing the warnings.  I wish you'd changed these at the
> same time to use dev_info() and "[%#llx-%#llx]" like the rest of PCI.
>
> I confess I don't understand where the ioport, mmio, and prefetchable
> mmio resources are coming from here, but before your patch, these
> printed values that look like junk on an HP nw8000:
>
>  PCI: bridge 0000:00:01.0 io port: [2fff00002000, ef92eae800000300]
>  PCI: bridge 0000:00:01.0 32bit mmio: [904fffff90400000, ef92eae800000300]
>  PCI: bridge 0000:00:01.0 32bit mmio pref: [9fffffff98000000, ef92eae8]
>
> I just returned the laptop, or I'd double-check to see whether your casts
> fixed this.

you must use 32 bit with !64bit_resource..

can we just make resource_t to be ull to 32bit unconditionally?

YH
