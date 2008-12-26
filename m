Return-Path: <linux-kernel-owner+w=401wt.eu-S1753516AbYLZV0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbYLZV0U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 16:26:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbYLZV0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 16:26:12 -0500
Received: from mail.lang.hm ([64.81.33.126]:40477 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326AbYLZV0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 16:26:12 -0500
Date: Fri, 26 Dec 2008 14:28:03 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Jan Engelhardt <jengelh@medozas.de>
cc: Roland <devzero@web.de>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] Compress kernel modules on installation
In-Reply-To: <alpine.LSU.2.00.0812262210080.12031@fbirervta.pbzchgretzou.qr>
Message-ID: <alpine.DEB.1.10.0812261422010.10983@asgard.lang.hm>
References: <005401c96797$df055100$6602a8c0@bui.materna.com> <alpine.DEB.1.10.0812261354250.10983@asgard.lang.hm> <alpine.LSU.2.00.0812262210080.12031@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Dec 2008, Jan Engelhardt wrote:

> On Friday 2008-12-26 23:02, david@lang.hm wrote:
>>> ( see
>>> http://www.linuxjournal.com/files/linuxjournal.com/linuxjournal/articles/080/8051/8051f1.png
>>> )
>>
>> this varies a lot on the particulars of the data being compressed.
>
> see my other reply.

IIRC the default is 5, from the graph you posted going to 6 or 7 would be 
a fairly significant win (final size to final size) without eathing _that_ 
much more cpu.

instead of doing the compression when doing the modules_install do it when 
they are compiled (just like we do for the kernel itself). if you just 
spent the cpu to build the thing, the cpu to compress it isn't much.

>> however, I do need to ask what the sizes of the resulting files end up being
>> (on my system the last kernel that used modules was 2.4.31, so I can't just
>> look this up myself). in most cases disks are formatted with 4K blocks, so
>> unless it shrinks across such a boundry it's not actually going to help much.
>
> Hey, don't forget exotic filesystems that pack that together anyway.
> And if I fired up du right, then...
>
> $ find . -iname "*.gz" | xargs du -cs -B 4096 | grep total
> 7086    total
> $ echo $[7086*4096]
> 29024256
> $ echo $[29024256-24782942]
> 4241314
>
> So that's like 4M going off for the block stuff. Given that
> the compression actually saved about 50 MB, I think we
> can live with the 4M - especially since they have been
> there already one way or another.

if I'm reading the numbers correctly that's about 16% of the space taken 
by the final result

>> one other thing to consider would be some ability to load the
>> module out of a tar or cpio bundle, that way you end up saving all
>> the partial blocks from each module as well.
>
> tarfs, it's somewhere around the corner on the fuse pages probably.

watch out for a deadlock here. the more external tools that you need to 
get at the kernel modules, the more likely it is that one of those tools 
will need something that you can't get to without the modules loaded.

David Lang

