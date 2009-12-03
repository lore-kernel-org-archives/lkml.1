Return-Path: <linux-kernel-owner+w=401wt.eu-S1755921AbZLCKHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbZLCKHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 05:07:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbZLCKHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 05:07:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbZLCKHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 05:07:54 -0500
Message-ID: <4B178DD9.7040502@redhat.com>
Date: Thu, 03 Dec 2009 18:07:21 +0800
From: Danny Feng <dfeng@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH -tip] x86: reboot_fixup_32.c add missing pci_dev_put
References: <1259291762-17735-1-git-send-email-dfeng@redhat.com> <20091202100928.GE22654@elte.hu> <4B169B1B.8010007@zytor.com> <20091202171422.GB28061@elte.hu>
In-Reply-To: <20091202171422.GB28061@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2009 01:14 AM, Ingo Molnar wrote:
>
> * H. Peter Anvin<hpa@zytor.com>  wrote:
>
>> On 12/02/2009 02:09 AM, Ingo Molnar wrote:
>>>
>>> * Xiaotian Feng<dfeng@redhat.com>  wrote:
>>>
>>>> pci_get_device increments reference count to the found pci device,
>>>> that should be decremented using pci_dev_put.
>>>
>>>> +++ b/arch/x86/kernel/reboot_fixups_32.c
>>>> @@ -80,6 +80,7 @@ void mach_reboot_fixups(void)
>>>>   			continue;
>>>>
>>>>   		cur->reboot_fixup(dev);
>>>> +		pci_dev_put(dev);
>>>
>>> Does this matter in practice? We are about to reboot. (but if it's
>>> cleaner to do it like this or if there's some real bug fixed by this
>>> then please spell it out in the changelog.)
>>>
>>
>> Even if it doesn't actually matter, doing things cleanly makes it
>> easier to handle failure scenarios, possibly that are discovered in
>> the future.
>
> certainly - but it would be nice to know whether there's any other
> reason for this but cleanliness/consistency.

Just for consistency:-) pci_get_device will increase the ref count of 
found device,
then we should use pci_dev_put to decrease the ref count although we're 
going to reset soon.
I should point out this in my changelog, sorry for the unclear changelog.

>
> 	Ingo
>

