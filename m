Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbYBFFIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbYBFFIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 00:08:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750863AbYBFFIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 00:08:12 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:58507 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbYBFFIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 00:08:10 -0500
Date: Tue, 5 Feb 2008 23:08:05 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Kohei KaiGai <kaigai@ak.jp.nec.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       "Andrew G. Morgan" <morgan@kernel.org>, akpm@osdl.org,
       jmorris@namei.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/3] exporting capability code/name pairs (try #3)
Message-ID: <20080206050805.GD3258@sergelap.austin.ibm.com>
References: <47997122.3070504@ak.jp.nec.com> <479990A1.3050103@kernel.org> <4799CAE0.7010400@ak.jp.nec.com> <47A2AB60.5000403@ak.jp.nec.com> <20080204162103.GA20130@sergelap.ibm.com> <47A91B00.9080301@ak.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A91B00.9080301@ak.jp.nec.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kohei KaiGai (kaigai@ak.jp.nec.com):
> Serge E. Hallyn wrote:
>> Quoting Kohei KaiGai (kaigai@ak.jp.nec.com):
>>>>> All that being said, the friendliness factor of this is somewhat
>>>>> undeniable, and so I can see why folk might want it in the kernel
>>>>> anyway. If so, would it possible to move this code into
>>>>> security/capability.c and not in the main kernel per-se - protected 
>>>>> with
>>>>> a configuration option? If it does appear in the kernel, we'll 
>>>>> obviously
>>>>> add your libcap changes too. If it doesn't, then perhaps we can meet
>>>>> your needs with a slight modification to your libcap patch to read the
>>>>> capabilities from an optional /etc/XXX file - and make text visibility
>>>>> of 'late breaking' capabilities something that the admin can tweak as
>>>>> needed?
>>>> I think optional configuration file is not a good idea.
>>>> It can make unneeded confusion.
>>>>
>>>> If necessary, I'll move this features into security/capability.c and
>>>> add a Kconfig option to select it.
>>> The following patch enables to export the list of capabilities supported
>>> on the running kernel, under /sys/kernel/capability .
>>>
>>> Changelog from the previous version:
>>> - Implementation is moved into security/capability.c from 
>>> kernel/capability.c
>>> - A Kconfig option SECURITY_CAPABILITIES_EXPORT is added to tuen on/off 
>>> this feature.
>> can you explain one more time exactly what this lets you do that you
>> absolutely can't do with the current api?
>
> Please consider the following situation:
>
> A user intend to run an application which use a new capability supported
> at new kernel without synced libcap. In this case, the application cannot
> work well, because libcap prevent to use new capability.

(Though we don't want to encourage application writers to not use
libcap...)

> When the kernel and libcap are not synced, the header files provided by
> libcap pacakge is not reliable. Typically, kernel developer sometimes
> faces such a situation. :)

Yeah it would definately be nice for me.

> This feature can fill the gap with providing a new interface to collect
> capabilities supported by the running kernel collectly.
>
>> I for one don't really object even if it is "duplicated" since it is far
>> easier to use, and I frequently have systems where kernel and userspace
>> are out of sync so /usr/include/sys/capabilities is worthless...  Though
>> I'm a little worried that b/scripts/mkcapnames.sh is the kind of thing
>> that'll eventually break, but I suppose that's my fault for objecting
>> two duplicated list of capability definitions :)
>
> Are you worried about "mkcapnames.sh" get broken in the future version?
>
> If so, we can add a code to check whether this script works correctly, or 
> not
>
> like:
>   -- at security/capability.c
>   #include <linux/capability.h>
>            :
>   #if CAP_LAST_CAP != ARRAY_SIZE(capability_attrs)
>   #error "mkcapnames.sh added fewer or more entries than expected!"
>   #endif

Yeah, the regexp misfiring was my biggest concern so this should help.

thanks,
-serge
