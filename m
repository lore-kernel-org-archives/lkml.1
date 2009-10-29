Return-Path: <linux-kernel-owner+w=401wt.eu-S1751708AbZJ2HsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbZJ2HsX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 03:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbZJ2HsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 03:48:22 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58023 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbZJ2HsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 03:48:22 -0400
Message-ID: <4AE948D6.2080809@np.css.fujitsu.com>
Date: Thu, 29 Oct 2009 16:48:38 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Lon Hohberger <lhh@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       LKLM <linux-kernel@vger.kernel.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Neil Horman <nhorman@redhat.com>
Subject: Re: [PATCH] [RFC][Patch x86-tip] add notifier before kdump
References: <4AE6B1CC.6040603@np.css.fujitsu.com>	<20091027150725.GD10513@redhat.com>	<1256660208.15137.102.camel@localhost.localdomain>	<4AE91645.8080903@np.css.fujitsu.com> <m1fx927okr.fsf@fess.ebiederm.org>
In-Reply-To: <m1fx927okr.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric

Thanks for your comment.
I will consider the method you suggested. Thank you very much.

Best regards,
Jin Dongming

Eric W. Biederman wrote:
> Jin Dongming <jin.dongming@np.css.fujitsu.com> writes:
> 
>> Vivek, Lon Hohberger
>>
>> Thanks for your comments.
>>
>> I also agree with your opinion, too. But I still have problems listed
>> as following.
>>     1. Nobody knows when the second kernel does not work well
>>     2. Too much time cost to startup the second kernel
>>
>> So I hope that following work could be done. 
>>     1. Add some code before kdump to monitor the actions of second kernel
>>        Something we worried about is that nobody knows when the kdump will not
>>        work well. If the second kernel does not work well, nobody knows when
>>        the best time is to restart. So we need to add some code such as setting
>>        watchdog. If we want to monitor second kernel, some work need to be done
>>        before it starts to work.
> 
> Any extra work done in the crashing kernel decreases the likely hood
> of the second kernel working.  If you want a watchdog I recommend you always
> run it and have the interval set large enough for the second kernel to boot
> before it starts petting it.  That way no code needs to run after a kernel crash.
> 
>>     2. Shorten the startup time of second kernel
>>        I think that the purpose of second kernel is used for backup information
>>        stored in memory to storage only. But the time cost is different
>>        according to the system architecture. And also I think that there are
>>        too many of device is not useful to get the memory information to
>>        storage. I think the startup time of second kernel should be shortened.
>>        I don't know much about second kernel, these are only my thought.
> 
> The second kernel can be anything you like.  Including a standalone executable
> if needed for very precise requirements.  Any improvements in boot time for a
> normal linux image should apply to the dump kernel.
> 
> Currently with a tight initrd and just dumping dmesg to disk I get away with
> a 20M crashkernel reservation, and it typically runs and does it's work before
> my watchdog fires.
> 
> Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


