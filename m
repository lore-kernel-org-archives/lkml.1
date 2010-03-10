Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108Ab0CJPZR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 10:25:17 -0500
Received: from smtp.turknetserver.com ([193.192.122.40]:60764 "EHLO
	smtp.turknetserver.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756533Ab0CJPZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 10:25:15 -0500
Message-ID: <4B97B9D8.6050103@turknetserver.com>
Date: Wed, 10 Mar 2010 17:25:12 +0200
From: Tarkan Erimer <tarkan@turknetserver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.2pre) Gecko/20100308 SUSE/3.1b1-5.1 Thunderbird/3.1b1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [BISECTED] Re: [BUG] Linux-2.6.33 to 33-git9 intel_drm: drm_fb_helper
 panic
References: <4B8FC4E1.4070509@turknetserver.com> <4B950200.4000305@turknetserver.com>
In-Reply-To: <4B950200.4000305@turknetserver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 03/08/2010 03:56 PM, Tarkan Erimer wrote:
> On 03/04/2010 04:34 PM, Tarkan Erimer wrote:
>> When I booted into 2.6.33, hard lock up occurs via the following error
>> message at boot time :
>>
>> [drm:drm_fb_helper_panic] *ERROR* panic occured,  switching back to text
>> console
>> BUG: scheduling while atomic: init/1/0x00000002
>>
>> This is a KMS enabled kernel on i945 VGA. Also, I tried (I found after
>> googling a bit.)  with "i915.modeset=0 enable_mtrr_cleanup" and
>> "enable_mtrr_cleanup" kernel boot options. But, still the same error
>> occurs.
>>
>> This bug occurs on kernels from 2.6.33 to 2.6.33-git9. 2.6.33-rc8 works
>> fine. My .config attached.
>>
>> Tarkan
>>
> Anybody care to look at this issue ? BTW; it, still,  exist (tested few
> mins ago.) on .33-git14, too.
>
> Tarkan
>

Today, I bisected to find out the bad commit. Here is what I found :

83d90addc829ab56ace49b10fd7d5d415448aac4 is the first bad commit

commit 83d90addc829ab56ace49b10fd7d5d415448aac4
Merge: 75ef7cd 79da064
Author: Linus Torvalds<torvalds@linux-foundation.org>
Date:   Wed Feb 24 07:42:42 2010 -0800

     Merge branch 'for-linus' of git://git.kernel.dk/linux-2.6-block

     * 'for-linus' of git://git.kernel.dk/linux-2.6-block:
       Revert "block: improve queue_should_plug() by looking at IO depths"



