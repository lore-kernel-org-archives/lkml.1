Return-Path: <linux-kernel-owner+w=401wt.eu-S1755913AbYADB4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbYADB4p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 20:56:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbYADB4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 20:56:35 -0500
Received: from mail1.asahi-net.or.jp ([202.224.39.197]:56930 "EHLO
	mail.asahi-net.or.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753115AbYADB4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 20:56:34 -0500
Message-ID: <477D926C.8000707@ak.jp.nec.com>
Date: Fri, 04 Jan 2008 10:57:00 +0900
From: KaiGai Kohei <kaigai@ak.jp.nec.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Andrew Morgan <morgan@kernel.org>
CC: KaiGai Kohei <kaigai@kaigai.gr.jp>, "Serge E. Hallyn" <serue@us.ibm.com>,
       jmorris@namei.org, akpm@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Exporting capability code/name pairs
References: <477321C8.3070004@ak.jp.nec.com> <20071227161435.GB9677@sergelap.austin.ibm.com> <477455A0.7060603@ak.jp.nec.com> <477494C3.2040301@ak.jp.nec.com> <4777C745.8080700@kernel.org> <477B468A.3050702@kaigai.gr.jp> <477C3EE9.2060600@kernel.org>
In-Reply-To: <477C3EE9.2060600@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There is also the issue of compiled code which explicitly raises and
> lowers capabilities around critical code sections (ie., as they were
> intended to be used) is also not well served by this change.
> 
> That is, unless the code was compiled with things like CAP_MAC_ADMIN
> being #define'd then it won't be able to do things like cap_set_flag()
> appropriately.

A new function will be necessary, like:
    cap_value_t cap_get_value_by_name(const char *cap_name);

If a program tries to use specific capabilities explicitly, it can
apply pre-defined capability code like CAP_MAC_ADMIN.

However, when we implement a program which can deal with arbitrary
capabilities, it should obtain codes of them dynamically, because
it enables to work itself on the feature kernel.

Thanks,

> Cheers
> 
> Andrew
> 
> KaiGai Kohei wrote:
>> Andrew Morgan wrote:
>>> -----BEGIN PGP SIGNED MESSAGE-----
>>> Hash: SHA1
>>>
>>> KaiGai Kohei wrote:
>>>> Remaining issues:
>>>> - We have to mount securityfs explicitly, or use /etc/fstab.
>>>>   It can cause a matter when we want to use this feature on
>>>>   very early phase on boot. (like /sbin/init)
>>> I'm not altogether clear how you intend this to work.
>>>
>>> Are you saying that some future version of libcap will require that
>>> securityfs be mounted before it (libcap) will work?
>> Yes, but implementing this feature on securityfs might be not good
>> idea as as James said. If this feature is on procfs or sysfs, it is
>> not necessary to mount securityfs explicitly.
>>
>> Thanks,
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.7 (Darwin)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org
> 
> iD8DBQFHfD7n+bHCR3gb8jsRAsgcAKDY6qXBR3JV2addHUg5sxyZHJEkDQCfdLOL
> zJlf3T4SQsUNENr3kwR5pr8=
> =v8C5
> -----END PGP SIGNATURE-----
> 
> 

