Return-Path: <linux-kernel-owner+w=401wt.eu-S1753187AbYLZX5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbYLZX5Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 18:57:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbYLZX47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 18:56:59 -0500
Received: from mail.lang.hm ([64.81.33.126]:33045 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbYLZX47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 18:56:59 -0500
Date: Fri, 26 Dec 2008 16:58:38 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Jan Engelhardt <jengelh@medozas.de>
cc: Roland <devzero@web.de>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] Compress kernel modules on installation
In-Reply-To: <alpine.LSU.2.00.0812270014500.12031@fbirervta.pbzchgretzou.qr>
Message-ID: <alpine.DEB.1.10.0812261656300.10983@asgard.lang.hm>
References: <005401c96797$df055100$6602a8c0@bui.materna.com> <alpine.DEB.1.10.0812261354250.10983@asgard.lang.hm> <alpine.LSU.2.00.0812262210080.12031@fbirervta.pbzchgretzou.qr> <alpine.DEB.1.10.0812261422010.10983@asgard.lang.hm>
 <alpine.LSU.2.00.0812270014500.12031@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Dec 2008, Jan Engelhardt wrote:

> On Friday 2008-12-26 23:28, david@lang.hm wrote:
>>>>> ( see
>>>>> http://www.linuxjournal.com/files/linuxjournal.com/linuxjournal/articles/080/8051/8051f1.png
>>>>> )
>>>>
>>>> this varies a lot on the particulars of the data being compressed.
>>>
>>> see my other reply.
>>
>> IIRC the default is 5
>
> default is 6 (man gzip).
>
>> instead of doing the compression when doing the modules_install do it when they
>> are compiled (just like we do for the kernel itself). if you just spent the cpu
>> to build the thing, the cpu to compress it isn't much.
>
> I'd rather do the compression later on - or do you want
> to spend gzipping all day when doing `make foo.ko`
> as a developer? ;-)
>
>>> $ find . -iname "*.gz" | xargs du -cs -B 4096 | grep total
>>> 7086    total
>>> $ echo $[7086*4096]
>>> 29024256
>>> $ echo $[29024256-24782942]
>>> 4241314
>>>
>>> So that's like 4M going off for the block stuff. Given that
>>> the compression actually saved about 50 MB, I think we
>>> can live with the 4M - especially since they have been
>>> there already one way or another.
>>
>> if I'm reading the numbers correctly that's about 16% of the space taken by the
>> final result
>
> Assuming that the x in (filesize % 4096 == x) is randomly distributed
> over 0..4095 for gzip modules, I proclaim that it is similarly
> randomly distributed for noncompressed modules. As such, the overhead
> is always there and gzipping does not make it worse or better.
> So you always have the overhead.
>
> uncompressed:
> $ du as above
> 113360896
> $ byte counted:
> 109270606
>
> differnece: 4.09 MB
>
> You always pay that price for having single files.
> So I dismiss it from the discussion ;-)

the point I was making is that if we are changing things to add new ways 
to get the module contents does it make sense to add another wrinkle that 
would allow you to eliminate the single files

  one pain point/upgrade of tools to take advantage of it instead of doing 
the first step and then coming back and do the second one.

David Lang
