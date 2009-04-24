Return-Path: <linux-kernel-owner+w=401wt.eu-S1754977AbZDXIqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbZDXIqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 04:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155AbZDXIqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 04:46:36 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:62104 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbZDXIqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 04:46:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Wv/J77zIVUzQfmnmN5f3VqG10QBVmaDhLXw0Ia1gD8RSo+LIaAi0uccW1O2hHNqimh
         TR+JTaOnYNfXgwfRSULdwMXX733Zy73a3CCgw2eDRk9Hx+nTBk2nzbcoAG8TfSuwVNB+
         DGq5577oPl1kDZuj/tZe1Y35jQIjy3VAa7K9M=
MIME-Version: 1.0
In-Reply-To: <20090423130930.50a6c9db.akpm@linux-foundation.org>
References: <c4e36d110904170213q24c2688ag9bcaa8562dddaa3f@mail.gmail.com>
	 <20090423130930.50a6c9db.akpm@linux-foundation.org>
Date: Fri, 24 Apr 2009 10:46:33 +0200
Message-ID: <b647ffbd0904240146mdcb84f7mcefa0850da425155@mail.gmail.com>
Subject: Re: WARNING: at fs/sysfs/group.c:138 sysfs_remove_group
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/23 Andrew Morton <akpm@linux-foundation.org>:
> On Fri, 17 Apr 2009 11:13:08 +0200
> Zdenek Kabelac <zdenek.kabelac@gmail.com> wrote:
>
>> Hi
>>
>>
>> When I've checked  2.6.30-rc2 kernel and  I've got among other errors
>> with Wifi message below.
>> As I've noticed - some people were reporting this problem already earlier:
>>
>> http://www.gossamer-threads.com/lists/linux/kernel/1058276?page=last
>>
>> But for me - it started with 2.6.30-rc kernels.
>> I've T61, 4GB, C2D, X86_64.
>>
>>
>>
>> Zdenek
>>
>>
>> platform microcode: firmware: requesting intel-ucode/06-0f-0a
>> platform microcode: firmware: requesting intel-ucode/06-0f-0a
>
> Lots of people are reporting this.  One person reported that each
> attempt takes 60 seconds, thus delaying boot be several minutes.

These microcode messages are normal per-se.

>From the original report [1] follows that there is another 60s. delay
when loading a firmware for an eth device.

[quote]

[  257.833775] tg3: eth0: Flow control is off for TX and off for RX.
[  269.643973] tg3 0000:03:01.1: firmware: requesting tigon/tg3_tso.bin
[  329.640456] eth1: Failed to load firmware "tigon/tg3_tso.bin"
...

 We see 60 seconds for eth1, complaining about a failed firmware load.
/lib/firmware/tigon/tg3_tso.bin does exist and is from the current
build.

[/quote]

IOW, the issue likely has something to do with firmware loading in general.


-- 
Best regards,
Dmitry Adamushko
