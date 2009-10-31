Return-Path: <linux-kernel-owner+w=401wt.eu-S1757822AbZJaNqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822AbZJaNqn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 09:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757752AbZJaNqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 09:46:42 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:53425 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbZJaNqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 09:46:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Wf3tCqoVkkMeG4hL8y2W5nUvKduItBp45pP8sX+te1CwrOXNaaJHPGKzXWD9kU6nUK
         tkd9n+DpQo0h2Vm38b0ZUbR+pxUbX5JyTnMm6koxMwFol3dtANHphGp5vIg8C0UdcvH2
         TE14Vpu3nRZgJIbt/9EkTmMHF+/QVcZDWfFAE=
Message-ID: <4AEC3FC3.3090209@gmail.com>
Date: Sat, 31 Oct 2009 14:46:43 +0100
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: linux-kernel@vger.kernel.org, mjg@redhat.com, eric@anholt.net
Subject: Re: no video output after suspend after "drm/i915: force mode set
 at lid open time"
References: <4AE4BBBC.2070809@gmail.com>	<20091026090548.2d4e20a9@jbarnes-g45>	<4AE76463.6010404@gmail.com> <20091027142609.73ac95e2@jbarnes-g45> <4AEC3ED7.6010003@gmail.com>
In-Reply-To: <4AEC3ED7.6010003@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Riccardo Magliocchetti ha scritto:
> Jesse Barnes ha scritto:
>> On Tue, 27 Oct 2009 22:21:39 +0100
>> Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com> wrote:
>>
>>> Jesse,
>>>
>>> Jesse Barnes ha scritto:
>>>> On Sun, 25 Oct 2009 21:57:32 +0100
>>>> Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com> wrote:
>>>>
>>>>> Hello,
>>>>>
>>>>> i lost video output, screen stays black, after suspend after
>>>>> commit c1c7af60892070e4b82ad63bbfb95ae745056de0 "drm/i915: force
>>>>> mode set at lid open time".
>>>>>
>>>>> I'm attaching my dmesg with 2.6.32-rc5 (actually
>>>>> 964fe080d94db82a3268443e9b9ece4c60246414), my bisect log and my
>>>>> config.
>>>>>
>>>>> git bisect response:
>>>>>
>>>>> c1c7af60892070e4b82ad63bbfb95ae745056de0 is the first bad commit
>>>>> commit c1c7af60892070e4b82ad63bbfb95ae745056de0
>>>>> Author: Jesse Barnes <jbarnes@virtuousgeek.org>
>>>>> Date:   Thu Sep 10 15:28:03 2009 -0700
>>>>>
>>>>>      drm/i915: force mode set at lid open time
>>>>>
>>> [snip]
>>>> I wonder if this is the real problem...  This patch introduced an
>>>> issue that was fixed by 06891e27a9b5dba5268bb80e41a283f51335afe7
>>>> that could cause a blank screen on lid open or resume, depending on
>>>> how lid events were delivered.  Should be easy enough to test
>>>> though, you can remove the whole
>>>>
>>>> +       if (acpi_lid_open())
>>>> +               drm_helper_resume_force_mode(dev);
>>>>
>>>> block and see if that also helps (in the current tree there's a lock
>>>> taken around the force_mode call, you'll need to remove those lines
>>>> too for testing).
>>> So i've tried separately both this and the patch with the fix for 
>>> thinkpad (i have a samsung p460aa01 btw) with latest git and they
>>> have not fixed the issue.
>>>
>>> +#if 0
>>>       if (acpi_lid_open() && !dev_priv->suspended) {
>>>           mutex_lock(&dev->mode_config.mutex);
>>>           drm_helper_resume_force_mode(dev);
>>>           mutex_unlock(&dev->mode_config.mutex);
>>>       }
>>> +#endif
>>
>> So just removing the above lines doesn't fix things, but reverting the
>> whole patch (c1c7af60892070e4b82ad63bbfb95ae745056de0) does?  If so the
>> only other thing I can think of is
>> 2c907b72db4dd4e8af6dccb6e0ac122d78627b8d, which is in Linus's tree now,
>> but may not be in the drm-intel tree you're testing?
> 
> Sorry for taking so long to respond. Anyway latest Linus' git master 
> with reverted c1c7af60892070e4b82ad63bbfb95ae745056de0 , per attached 
> patch, does not fix the issue for me. Please note that just reverting 
> the commit does not compile because of an added user of acpi_lid_open() 
> which requires acpi/button.h which has been added in 
> 7121413f2accf14cf05b38539fb7a8be77543370. Will try to revert that too.

Sorry, that commit just change that line, it does not add the 
acpi_lid_open() call.

thanks,
riccardo
