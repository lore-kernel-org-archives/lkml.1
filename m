Return-Path: <linux-kernel-owner+w=401wt.eu-S1761667AbZCaCna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761667AbZCaCna (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 22:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755509AbZCaCnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 22:43:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:33855 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269AbZCaCnP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 22:43:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PiXXfsV8zerBW5+r8CjmVrvof/W7piRPWKufGz4qPjfz0CYFJBcPYFs9SZ3SPjzsVG
         j4Ls3rtjqZbWv86YmYxSXInSrXcDiVjG2HCryIe/OpToBb3RjyrR3/fgukvNWFu6LWl+
         YMTg45GSI17vG+eLazNURC5K5mmfDVL5JCgro=
MIME-Version: 1.0
In-Reply-To: <20090330163529.2c587ef5.akpm@linux-foundation.org>
References: <ea11fea30903222032x4490af0dy60de450cf4ce6e58@mail.gmail.com> 
	<20090330163529.2c587ef5.akpm@linux-foundation.org>
Date: Tue, 31 Mar 2009 08:12:58 +0530
Message-ID: <ea11fea30903301942w2e6d8555k2dcbb36829778b4f@mail.gmail.com>
Subject: Re: [PATCH] : Convert simple_strtoul to strict_strtoul in fs/inode.c
From: Manish Katiyar <mkatiyar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: trivial@kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 31, 2009 at 5:05 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 23 Mar 2009 09:02:04 +0530
> Manish Katiyar <mkatiyar@gmail.com> wrote:
>
>> Hi Andrew,
>>
>> Below patch converts simple_strtoul to strict_strtoul in fs/inode.c
>>
>> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
>> ---
>>  fs/inode.c |    8 +++++++-
>>  1 files changed, 7 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/inode.c b/fs/inode.c
>> index e0dad15..ef4a9b1 100644
>> --- a/fs/inode.c
>> +++ b/fs/inode.c
>> @@ -1447,9 +1447,15 @@ EXPORT_SYMBOL(inode_double_unlock);
>>  static __initdata unsigned long ihash_entries;
>>  static int __init set_ihash_entries(char *str)
>>  {
>> +     int ret;
>> +
>>       if (!str)
>>               return 0;
>> -     ihash_entries = simple_strtoul(str, &str, 0);
>> +
>> +     ret = strict_strtoul(str, 0, &ihash_entries);
>> +     if (ret < 0 || ihash_entries == 0)
>> +             return 0;
>> +
>>       return 1;
>>  }
>>  __setup("ihash_entries=", set_ihash_entries);
>
> Again, there is no reason given for making the change.

Hi Andrew,

It showed up during cleanup of this file via checkpatch.pl.

>
> Bear in mind that this is not a backward-compatible change!  If someone
> (stupidly) has
>
>        ihash_entries=42foo
>
> in their grub.conf then your change would break their kernels.
>
> it's not a serious problem and we can probably make this change, but
> trivial@kernel.org is not a suitable list for discussing and
> promulgating the change.

I have cced lkml.

Thanks -
Manish
>
>
