Return-Path: <linux-kernel-owner+w=401wt.eu-S1755374AbZCYFjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbZCYFjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 01:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbZCYFjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 01:39:12 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50486 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbZCYFjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 01:39:11 -0400
Message-ID: <49C9C375.6060306@jp.fujitsu.com>
Date: Wed, 25 Mar 2009 14:39:01 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>
CC: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [PATCH v5 09/13] PCI: Introduce /sys/bus/pci/devices/.../remove
References: <20090320204327.12275.43010.stgit@bob.kio> <20090320205636.12275.1825.stgit@bob.kio> <49C74FCC.7070308@jp.fujitsu.com> <20090324192905.GA25984@ldl.fc.hp.com> <49C9BBD7.4040705@jp.fujitsu.com> <20090325052048.GA1584@ldl.fc.hp.com>
In-Reply-To: <20090325052048.GA1584@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Chiang wrote:
> * Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
>> Alex Chiang wrote:
>>> * Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
>>>> I still have the following kernel error messages in testing with your
>>>> latest set of patches (Jesse's linux-next). The test case is removing
>>>> e1000e device or its parent bridge by "echo 1 > /sys/bus/pci/devices/
>>>> .../remove".
>>>>
>>>> [  537.379995] =============================================
>>>> [  537.380124] [ INFO: possible recursive locking detected ]
>>>> [  537.380128] 2.6.29-rc8-kk #1
>>>> [  537.380128] ---------------------------------------------
>>>> [  537.380128] events/4/56 is trying to acquire lock:
>>>> [  537.380128]  (events){--..}, at: [<ffffffff80257fc0>] flush_workqueue+0x0/0xa0
>>>> [  537.380128]
>>>> [  537.380128] but task is already holding lock:
>>>> [  537.380128]  (events){--..}, at: [<ffffffff80257648>] run_workqueue+0x108/0x230
>>>> [  537.380128]
>>>> [  537.380128] other info that might help us debug this:
>>>> [  537.380128] 3 locks held by events/4/56:
>>>> [  537.380128]  #0:  (events){--..}, at: [<ffffffff80257648>] run_workqueue+0x108/0x230
>>>> [  537.380128]  #1:  (&ss->work){--..}, at: [<ffffffff80257648>] run_workqueue+0x108/0x230
>>>> [  537.380128]  #2:  (pci_remove_rescan_mutex){--..}, at: [<ffffffff803c10d1>] remove_callback+0x21/0x40
>>> I still cannot reproduce this lockdep issue, even using your
>>> .config with an e1000e device on an x86_64 kernel. :(
>>>
>>> I tried removing the endpoint, an intermediate bridge device, and
>>> the parent bus. I don't know what I'm doing wrong...
>>>
>> I don't know either...
>> The reproducibility is 100% on my environment. The steps are
>> just boot the system and remove the device.
>>
>>> Can you please try this patch though, and see if it fixes the
>>> warning? It applies on top of my other sysfs patch that
>>> introduces a mutex in sysfs_schedule_callback.
>> Anyway, I confirmed the kernel error messages were gone with
>> the patch against sysfs. Note that I used the following patch
>> I made for testing instead since your patch could not be
>> applied to Jesse's linux-next. 
> 
> Great, thank you for testing Kenji-san.
>

You're welcome.

Just in case, my patch is just for testing, and it is very buggy
(no destroy operation, lack of module_put() in error code path,
and so on). Please consider it as just for testing.

Thanks,
Kenji Kaneshige



