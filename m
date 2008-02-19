Return-Path: <linux-kernel-owner+w=401wt.eu-S1762271AbYBSCY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762271AbYBSCY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 21:24:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760210AbYBSCYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 21:24:05 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54838 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759128AbYBSCYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 21:24:01 -0500
Message-ID: <47BA3D6B.20804@cn.fujitsu.com>
Date: Tue, 19 Feb 2008 10:22:35 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Glauber Costa <gcosta@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       andrew.grover@intel.com, paul.s.diefenbaugh@intel.com, linux@brodo.de,
       anil.s.keshavamurthy@intel.com, lenb@kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 4/4] remove goto statement
References: <1203368213-30528-1-git-send-email-gcosta@redhat.com> <1203368213-30528-2-git-send-email-gcosta@redhat.com> <1203368213-30528-3-git-send-email-gcosta@redhat.com> <1203368213-30528-4-git-send-email-gcosta@redhat.com> <47BA2E93.4040002@cn.fujitsu.com> <47BA39FA.7050102@redhat.com>
In-Reply-To: <47BA39FA.7050102@redhat.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa wrote:
> Li Zefan wrote:
>> Glauber Costa Ð´µÀ:
>>> This patch removes goto statements in favour of plain returns
>>> in places that had nothing left behind that would justify
>>> such construction
>>> ---
>>>  drivers/acpi/processor_core.c |    4 ++--
>>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
>>> index 06a230a..70f62b6 100644
>>> --- a/drivers/acpi/processor_core.c
>>> +++ b/drivers/acpi/processor_core.c
>>> @@ -651,7 +651,7 @@ static int __cpuinit acpi_processor_star
>>>  
>>>  	result = acpi_processor_add_fs(device);
>>>  	if (result)
>>> -		goto end;
>>> +		return result;
>>>  
>>>  	status = acpi_install_notify_handler(pr->handle, ACPI_DEVICE_NOTIFY,
>>>  					     acpi_processor_notify, pr);
>>> @@ -675,7 +675,7 @@ #endif
>>>  			"%s is registered as cooling_device%d\n",
>>>  			device->dev.bus_id, cdev->id);
>>>  	else
>>> -		goto end;
>>> +		return result;
>>>  
>>>  	result = sysfs_create_link(&device->dev.kobj, &cdev->device.kobj,
>>>  					"thermal_cooling");
>> Seems you forgot to remove the 'end' label ?
> yes, in fact, thanks for pointing.
> 
> However, the patches are as split up as I could do, and it should not
> affect the others. I can re send this one, the whole series, or
> whatever, depending on what the maintainer wants.
> 
> So, what's gonna be?
> 

IMO a revised [PATCH 4/4] will do, since it won't affect the other 3 patches :)
