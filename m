Return-Path: <linux-kernel-owner+w=401wt.eu-S1753126AbYFEGS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbYFEGS0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 02:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbYFEGSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 02:18:15 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53502 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbYFEGSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 02:18:14 -0400
Message-ID: <48478247.30809@jp.fujitsu.com>
Date: Thu, 05 Jun 2008 15:05:59 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alex Chiang <achiang@hp.com>, jbarnes@virtuousgeek.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Wilcox <matthew@wil.cx>, kristen.c.accardi@intel.com,
       greg@kroah.com, lenb@kernel.org, pbadari@us.ibm.com,
       linux-pci@vger.kernel.org, pcihpd-discuss@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kobject: Export kobject_rename for pci_hotplug_core
References: <20080604200829.GC379@ldl.fc.hp.com>	<20080604201606.GE379@ldl.fc.hp.com> <20080604224838.6b556a51.akpm@linux-foundation.org>
In-Reply-To: <20080604224838.6b556a51.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 4 Jun 2008 14:16:06 -0600 Alex Chiang <achiang@hp.com> wrote:
> 
>> From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
>>
>> Export kobject_rename() to fix the following link error.  This happens when
>> pci_hotplug_core driver is compiled as a kernel module.
>>
>> ERROR: "kobject_rename" [drivers/pci/hotplug/pci_hotplug.ko] undefined!
>> make[1]: *** [__modpost] Error 1
>> make: *** [modules] Error 2
>> make: *** Waiting for unfinished jobs....
>>
>> Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
>> Acked-by: Alex Chiang <achiang@hp.com>
>> Cc: Greg KH <greg@kroah.com>
>> Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
>> Cc: Len Brown <lenb@kernel.org>
>> Signed-off-by: Alex Chiang <achiang@hp.com>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> ---
>>  lib/kobject.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/lib/kobject.c b/lib/kobject.c
>> index 718e510..dcade05 100644
>> --- a/lib/kobject.c
>> +++ b/lib/kobject.c
>> @@ -439,6 +439,7 @@ out:
>>  
>>  	return error;
>>  }
>> +EXPORT_SYMBOL_GPL(kobject_rename);
> 
> Shouldn't this go straight into 2.6.26?
> 
> 

I think "No", because currently its only required by Alex's "pci slot"
patches.

Thanks,
Kenji Kaneshige



