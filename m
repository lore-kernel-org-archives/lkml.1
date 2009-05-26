Return-Path: <linux-kernel-owner+w=401wt.eu-S1754435AbZEZFoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbZEZFoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 01:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbZEZFo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 01:44:27 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:56058 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbZEZFo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 01:44:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=fDsaV7i42tF488+LecP+fvWvgGjXm8n41j4BYdtzlPxxMl55TSj1oKqp4T12/fVuf1
         TYNWZFOdiY5VWk/v4H8Q/NtxzVfJYm9bN1nv1UdT2zNBiad4R31i0XvIcGxEgtO/IPiI
         lLFSQ56X8Jdxeit6Q/ZdnAwxjqvjK7yPLDqew=
Message-ID: <4A1B8193.1010703@gmail.com>
Date: Tue, 26 May 2009 07:43:47 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1pre) Gecko/20090521 Shredder/3.0b3pre
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux.kernel" <linux-kernel@vger.kernel.org>,
       Theodore Tso <tytso@mit.edu>
Subject: Re: 2.6.29 regression: ATA bus errors on resume
References: <clqON-2Xv-7@gated-at.bofh.it>	<clqON-2Xv-9@gated-at.bofh.it>	<clqON-2Xv-11@gated-at.bofh.it>	<clqON-2Xv-13@gated-at.bofh.it>	<clqON-2Xv-15@gated-at.bofh.it>	<clqON-2Xv-17@gated-at.bofh.it>	<clqON-2Xv-19@gated-at.bofh.it>	<clqON-2Xv-5@gated-at.bofh.it>	<cmknZ-8lW-9@gated-at.bofh.it>	<cmoBl-6Ok-21@gated-at.bofh.it>	<cmp4n-7rb-15@gated-at.bofh.it>	<cmsYg-5BR-27@gated-at.bofh.it>	<cmvW7-1Yj-23@gated-at.bofh.it>	<cnheh-3vO-7@gated-at.bofh.it>	<cnPg1-7Q4-19@gated-at.bofh.it>	<cnTWo-7bV-25@gated-at.bofh.it>	<co1Kd-350-5@gated-at.bofh.it>	<co2Qf-4QQ-27@gated-at.bofh.it>	<co4yj-7Mc-5@gated-at.bofh.it>	<cp71c-4py-29@gated-at.bofh.it>	<cEVyE-re-1@gated-at.bofh.it>	<4A17C39E.2030302@gmail.com>	<4A19F006.3000303@kernel.org> <20090525091534.13ae103c@lxorguk.ukuu.org.uk> <4A1B164B.1010108@gmail.com> <4A1B76EB.9040500@kernel.org>
In-Reply-To: <4A1B76EB.9040500@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2009 06:58 AM, Tejun Heo wrote:
> Hello, Niel.
>
> Niel Lambrechts wrote:
>    
>> I've tested all of the kernels I have again since 2.6.29.4 also came out
>> just recently. I did a hibernate/resume for each in the console, then
>> repeated the same in X, then continued to the next kernel.
>>
>> The 2.6.29.4 log is much larger, since some other badness happened there
>> - there is a large kernel trace in there as my first X hibernation
>> attempt failed and came back to X after a few seconds. The system seemed
>> functional, it did not keep generating kernel messages - when I then
>> retried a hibernate it worked, along with the resume. Another unrelated
>> bug perhaps?
>>
>> As for "hard resetting link" messages, they seemed to always happen
>> under X the times I tried it.
>>
>> Kernel       EXT4-errors?    Console:ata1 reset?   Console:ata2-reset?    X:ata1 reset?    X:ata2 reset?
>> 2.6.28.10    No              no                     yes                   yes              no
>> 2.6.29.4*    No              no                     no                    no               no
>> 2.6.29.4**   No              -                      -                     yes              no
>> 2.6.30-rc6   Yes             -                      -                     yes              no
>> 2.6.30-rc6   No              no                     no                    yes              no
>>
>> * Xorg hibernation attempt failed.
>> * Xorg Second hibernation attempt (no extra reboot)
>>
>> I also did a side by side comparison of the messages I have for
>> 2.6.30-rc6, the one with EXT4 errors I reported on yesterday, and
>> another one that worked just fine tonight. I stripped all time-stamps
>> and some pulseaudio messages from the bad one and attached them here,
>> and also saved the full messages for each kernel to
>> http://bugzilla.kernel.org/show_bug.cgi?id=13017 .
>>
>> Since analysing the code-path is still a bit beyond me, I'll leave you
>> with a little summary of the differences I notice.
>>
>> A = 2.6.30-rc6 (EXT4 clean)
>> B = 2.6.30-rc6 (EXT4 errors triggered)
>>      
> Duplicate PHY events are likely to be dependent on timing and
> non-deterministic.  The ext4 corrupting or not depends on whether a
> request with failfast set was in-flight at the time of the second PHY
> event, which again is dependent on timing.  At any rate, this looks
> like a problem of ext4 (or something between ext4 and the driver).  It
> either shouldn't issue failfast command or should take appropriate
> recovery action if it does.  It would be really nice if you can give a
> shot at ext3.

Urgh. My root file-system is mounted with extents on, I would have to 
re-install entirely.

I'm wondering why no one else is complaining, or whether the problem is 
limited to ICH9M/M-E controllers with EXT4 or a certain type of 
hard-drive. The laptop is a Lenovo W500 (fairly similar to T500), so 
maybe not a lot of people with this type of controller is using EXT4 yet.

Anyhow, I think Theodore may have ruled this out as a EXT4 problem 
already (I first copied him) so I'm not sure what to do now, it will 
take some strong will (and even more time) for me to re-install EXT3. I 
just shouldn't have to, dammit. :-p

Regards,
Niel
