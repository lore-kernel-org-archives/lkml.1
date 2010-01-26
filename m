Return-Path: <linux-kernel-owner+w=401wt.eu-S1752797Ab0AZDzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab0AZDzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 22:55:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817Ab0AZDzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 22:55:18 -0500
Received: from mail-qy0-f204.google.com ([209.85.221.204]:37089 "EHLO
	mail-qy0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab0AZDzR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 22:55:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GTHFICe6bO+RUpbh55t0bNgauFVHgXPe7OM+AKdjABsn1/ougnqEhn5D6E0OpDLhbe
         vx7KPB9kPbQPVvkJygOXSco2sOdCNYzb/LT2ATChYgfzovpiItFNgI08C7ZcGPr+F0mA
         QrnrnFbukCnaZ3o8koX0Wiih8Ql14EGAPyKuQ=
MIME-Version: 1.0
In-Reply-To: <d65b1b151001200706k7a60eaf9le2a6cf4e1227bdad@mail.gmail.com>
References: <d65b1b151001191029o66794c24t228177a8ca544e44@mail.gmail.com>
	 <2375c9f91001191926hc80dc50mb264f757295c1337@mail.gmail.com>
	 <d65b1b151001200706k7a60eaf9le2a6cf4e1227bdad@mail.gmail.com>
Date: Tue, 26 Jan 2010 11:55:15 +0800
Message-ID: <2375c9f91001251955s1dfc70f9p94054b7824a4c4b7@mail.gmail.com>
Subject: Re: [PATCH] Use full path to dnsdomainname and domainname in 
	scripts/mkcompile_h
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Glenn Sommer <glemsom@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 11:06 PM, Glenn Sommer <glemsom@gmail.com> wrote:
> 2010/1/20 Américo Wang <xiyou.wangcong@gmail.com>:
>> On Wed, Jan 20, 2010 at 2:29 AM, Glenn Sommer <glemsom@gmail.com> wrote:
>>> With reference to: http://bugzilla.kernel.org/show_bug.cgi?id=14920
>>> I'll post my suggestion here.
>>>
>>> Currently scripts/mkcompile_h checks for "/bin/dnsdomainname" and
>>> "/bin/domainname" when trying to find the DNS name.
>>> Though, when running the executable - the full path isn't used!
>>>
>>> IMO if we check for "/bin/dnsdomainname", we should also use
>>> "/bin/dnsdomainname" - and not blindly trust /bin is the first directory in
>>> $PATH  which contains a executable named "dnsdomainname"
>>>
>>>
>>> I propose to use the full path, that we know is valid. Here's my proposed patch:
>>>
>>>
>>> --- scripts/mkcompile_h.orig    2009-12-28 23:02:34.000000000 +0100
>>> +++ scripts/mkcompile_h 2009-12-28 23:03:12.000000000 +0100
>>> @@ -66,9 +66,9 @@
>>>   echo \#define LINUX_COMPILE_HOST \"`hostname | $UTS_TRUNCATE`\"
>>>
>>>   if [ -x /bin/dnsdomainname ]; then
>>> -    echo \#define LINUX_COMPILE_DOMAIN \"`dnsdomainname | $UTS_TRUNCATE`\"
>>> +    echo \#define LINUX_COMPILE_DOMAIN \"`/bin/dnsdomainname | $UTS_TRUNCATE`\"
>>>   elif [ -x /bin/domainname ]; then
>>> -    echo \#define LINUX_COMPILE_DOMAIN \"`domainname | $UTS_TRUNCATE`\"
>>> +    echo \#define LINUX_COMPILE_DOMAIN \"`/bin/domainname | $UTS_TRUNCATE`\"
>>>   else
>>>     echo \#define LINUX_COMPILE_DOMAIN
>>>   fi
>>>
>>>
>>> Signed-off-by: Glenn Sommer <glemsom@gmail.com>
>>
>> Makes sense, but is that possible we have 'domainname' installed in two
>> different directories?
>>
>
> Usually "domainname" should be installed in /bin.
> I'm just thinking if one does something like this:
>
> * Place shellscript named "domainname" in /home/stupiduser/scripts
> (This shellscript should output some text... Let's say
> "my-stupid-shell-script")
> * Set PATH=/home/stupiduser/scripts:$PATH
> * Compile Linux kernel
>
> Doing the above will result in scripts/mkcompile_h testing for
> /bin/domainname, but actually using
> /home/stupiduser/scripts/domainname - which is this case will output
> something wrong.
> One could argue it's your own fault then - and I agree! Doing the
> above is stupid!
>
> Anyway, if we test for the executable using a complete path - we
> should also use that complete path when running the executable!
>
>
> Alternatively, if we want it to be more flexible(and allow the above)
> - we should do something like:
>
> domainname_executable=`which domainname`
> if [ ! -z "$domainname_executable" ] && [ -x "$domainname_executable" ]; then
>

Yeah, this seems better for me.
Thanks!
