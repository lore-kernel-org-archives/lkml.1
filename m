Return-Path: <linux-kernel-owner+w=401wt.eu-S1754907Ab0A0Coc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab0A0Coc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 21:44:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754868Ab0A0Cob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 21:44:31 -0500
Received: from mail-qy0-f204.google.com ([209.85.221.204]:38543 "EHLO
	mail-qy0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab0A0Coa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 21:44:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=b3OWHNRJBiYNxK2waKuoNTE9MtuVEVr4UEhay45qJrphx/i55ws/GE1d2Xf/BM92mF
         2ldu1oFqnsXKN9wvXXPD8iwaTnID6pWk+RCnV9XF0NdsTVDGZlSVY8VdxYunPN8DTiHn
         tsOVmJaBgICHF9nSkJ1IZOlrHMEdMl+KxuJ8A=
MIME-Version: 1.0
In-Reply-To: <d65b1b151001261110j6c0561a1ifba2da0077698e54@mail.gmail.com>
References: <d65b1b151001191029o66794c24t228177a8ca544e44@mail.gmail.com>
	 <2375c9f91001191926hc80dc50mb264f757295c1337@mail.gmail.com>
	 <d65b1b151001200706k7a60eaf9le2a6cf4e1227bdad@mail.gmail.com>
	 <2375c9f91001251955s1dfc70f9p94054b7824a4c4b7@mail.gmail.com>
	 <4B5F0452.1080306@suse.cz>
	 <d65b1b151001261110j6c0561a1ifba2da0077698e54@mail.gmail.com>
Date: Wed, 27 Jan 2010 10:44:29 +0800
Message-ID: <2375c9f91001261844q474b05a2k6d96237fc925b706@mail.gmail.com>
Subject: Re: [PATCH] Use full path to dnsdomainname and domainname in 
	scripts/mkcompile_h
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Glenn Sommer <glemsom@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 3:10 AM, Glenn Sommer <glemsom@gmail.com> wrote:
> 2010/1/26 Michal Marek <mmarek@suse.cz>:
>> On 26.1.2010 04:55, Américo Wang wrote:
>>> On Wed, Jan 20, 2010 at 11:06 PM, Glenn Sommer <glemsom@gmail.com> wrote:
>>>> Alternatively, if we want it to be more flexible(and allow the above)
>>>> - we should do something like:
>>>>
>>>> domainname_executable=`which domainname`
>>>> if [ ! -z "$domainname_executable" ] && [ -x "$domainname_executable" ]; then
>>>>
>>
>> (or 'if command -v domainname >/dev/null 2>&1; then domainname ...')
>>
>>
>>> Yeah, this seems better for me.
>>
>> Me too. Glenn, could you send a complete patch doing this? I'll add it
>> to the kbuild tree then.
>>
>> Thanks,
>> Michal
>>
>
> Yeah, good idea with "command -v" ! :)
> ( note: `command -v` will return true if the executable is found -
> else it will return false. )
>
> mkcompile_h is changed slightly in 2.6.32. Here's my new proposed patch:
>
>
> --- scripts/mkcompile_h.orig    2010-01-26 18:59:37.000000000 +0100
> +++ scripts/mkcompile_h 2010-01-26 20:03:42.000000000 +0100
> @@ -67,9 +67,9 @@
>   echo \#define LINUX_COMPILE_BY \"`whoami`\"
>   echo \#define LINUX_COMPILE_HOST \"`hostname | $UTS_TRUNCATE`\"
>
> -  if [ -x /bin/dnsdomainname ]; then
> +  if [ `command -v dnsdomainname 2> /dev/null` ]; then
>     domain=`dnsdomainname 2> /dev/null`
> -  elif [ -x /bin/domainname ]; then
> +  elif [ `command -v domainname 2> /dev/null` ]; then
>     domain=`domainname 2> /dev/null`
>   fi
>

No, this doesn't look good.

First, you don't need to redirect stderr for 'command'.

Second, 'command' also searches in shell built-in commands, aliases,
so I prefer 'whereis -b'.
