Return-Path: <linux-kernel-owner+w=401wt.eu-S1754198AbYABIEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbYABIEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 03:04:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbYABIDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 03:03:55 -0500
Received: from mail1.asahi-net.or.jp ([202.224.39.197]:12375 "EHLO
	mail.asahi-net.or.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752480AbYABIDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 03:03:54 -0500
Message-ID: <477B457E.6000802@kaigai.gr.jp>
Date: Wed, 02 Jan 2008 17:04:14 +0900
From: KaiGai Kohei <kaigai@kaigai.gr.jp>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: KaiGai Kohei <kaigai@ak.jp.nec.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       akpm@osdl.org, morgan@kernel.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Exporting capability code/name pairs
References: <477321C8.3070004@ak.jp.nec.com> <20071227161435.GB9677@sergelap.austin.ibm.com> <477455A0.7060603@ak.jp.nec.com> <477494C3.2040301@ak.jp.nec.com> <Xine.LNX.4.64.0712281957520.23510@us.intercode.com.au>
In-Reply-To: <Xine.LNX.4.64.0712281957520.23510@us.intercode.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris wrote:
> On Fri, 28 Dec 2007, KaiGai Kohei wrote:
> 
>> Remaining issues:
>> - We have to mount securityfs explicitly, or use /etc/fstab.
>>   It can cause a matter when we want to use this feature on
>>   very early phase on boot. (like /sbin/init)
> 
> Why can't early userspace itself mount securityfs?

Hmm,,,
It might be possible as load_policy() doing, if necessary.
Please forget the previous my opinion.

> I'm not even sure this is a good idea at all.  Existing capabilities will 
> never disappear, and, as with syscalls, it's probably up to userland to 
> handle new ones not existing.

When we use libcap built on older kernel for newer kernel, libcap cannot
handle newly added capabilities, because it is not exist on the build environment.
Therefore, any available capabilities should be exported dynamically by the kernel.

> In any case, some more technical issues:
> 
>> kernel/cap_names.sh generates the body of cap_entries[] array,
> 
> This needs to be in the scripts directory.

OK, it will be moved.

> The generated header should be made idempotent (#ifdef wrapping), and also 
> include a warning that it is automatically generated (identifying the 
> script which does so), and that is should not be edited.
> 
>> +	d_caps = securityfs_create_dir("capability", NULL);
>> +	if (!d_caps)
> 
> Wrong way to check for error -- the function returns an ERR_PTR().
> 
>> +		f_caps[i] = securityfs_create_file(cap_entries[i].name, 0444,
>> +						   d_caps, &cap_entries[i],
>> +						   &cap_entry_fops);
>> +		if (!f_caps[i])
> 
> Ditto.

OK,

> Another issue is that securityfs depends on CONFIG_SECURITY, which might 
> be undesirable, given that capabilities are a standard feature.

We can implement this feature on another pseudo filesystems.
Do you think what filesystem is the best candidate?
I prefer procfs or sysfs instead.

Thanks,
-- 
KaiGai Kohei <kaigai@kaigai.gr.jp>
